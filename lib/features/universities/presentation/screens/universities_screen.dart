import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/errors/app_exception.dart';
import '../../domain/entities/university.dart';
import '../providers/universities_provider.dart';
import '../providers/university_custom_data_provider.dart';
import 'university_detail_screen.dart';
import '../widgets/error_view.dart';
import '../widgets/university_grid_card.dart';
import '../widgets/university_list_tile.dart';

class UniversitiesScreen extends ConsumerStatefulWidget {
  const UniversitiesScreen({super.key});

  @override
  ConsumerState<UniversitiesScreen> createState() => _UniversitiesScreenState();
}

class _UniversitiesScreenState extends ConsumerState<UniversitiesScreen> {
  bool _isGrid = false;
  int? _requestedAt;

  static const _loadMoreThreshold = 400.0;

  @override
  Widget build(BuildContext context) {
    final universities = ref.watch(universitiesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Universidades'),
        actions: [
          IconButton(
            tooltip: _isGrid ? 'Ver como lista' : 'Ver como cuadrícula',
            icon: Icon(_isGrid ? Icons.view_list : Icons.grid_view),
            onPressed: () => setState(() => _isGrid = !_isGrid),
          ),
        ],
      ),
      body: universities.when(
        // Show the spinner again when retrying after an error, so the tap on
        // "Reintentar" has visible feedback.
        skipLoadingOnRefresh: false,
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => ErrorView(
          message: error is AppException
              ? error.message
              : 'Ocurrió un error inesperado.',
          onRetry: () => ref.invalidate(universitiesProvider),
        ),
        data: (state) {
          if (state.all.isEmpty) {
            return const Center(
              child: Text('No se encontraron universidades.'),
            );
          }
          return _buildScrollView(state);
        },
      ),
    );
  }

  void _openDetail(University university) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => UniversityDetailScreen(university: university),
      ),
    );
  }

  Widget _buildScrollView(UniversitiesState state) {
    final visible = state.visible;
    final customData = ref.watch(universityCustomDataProvider);

    return NotificationListener<ScrollNotification>(
      onNotification: (notification) {
        if (notification.metrics.extentAfter < _loadMoreThreshold &&
            _requestedAt != visible.length) {
          _requestedAt = visible.length;
          ref.read(universitiesProvider.notifier).loadMore();
        }
        return false;
      },
      child: CustomScrollView(
        slivers: [
          if (_isGrid)
            SliverPadding(
              padding: const EdgeInsets.all(12),
              sliver: SliverGrid.builder(
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 220,
                  childAspectRatio: 0.8,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                ),
                itemCount: visible.length,
                itemBuilder: (context, index) {
                  final university = visible[index];
                  return UniversityGridCard(
                    key: ValueKey(university.id),
                    university: university,
                    imagePath: customData[university.id]?.imagePath,
                    onTap: () => _openDetail(university),
                  );
                },
              ),
            )
          else
            SliverList.builder(
              itemCount: visible.length,
              itemBuilder: (context, index) {
                final university = visible[index];
                return UniversityListTile(
                  key: ValueKey(university.id),
                  university: university,
                  imagePath: customData[university.id]?.imagePath,
                  onTap: () => _openDetail(university),
                );
              },
            ),
          if (!state.hasMore)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  'No hay más items para mostrar',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
