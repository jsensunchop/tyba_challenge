import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/errors/app_exception.dart';
import '../../domain/entities/university.dart';
import '../providers/universities_provider.dart';
import '../providers/university_custom_data_provider.dart';
import '../utils/formatters.dart';
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
      body: universities.when(
        skipLoadingOnRefresh: false,
        loading: () => _buildScrollView([
          const SliverFillRemaining(
            hasScrollBody: false,
            child: Center(child: CircularProgressIndicator()),
          ),
        ]),
        error: (error, _) => _buildScrollView([
          SliverFillRemaining(
            hasScrollBody: false,
            child: ErrorView(
              message: error is AppException
                  ? error.message
                  : 'Ocurrió un error inesperado.',
              onRetry: () => ref.invalidate(universitiesProvider),
            ),
          ),
        ]),
        data: (state) {
          if (state.all.isEmpty) {
            return _buildScrollView([
              const SliverFillRemaining(
                hasScrollBody: false,
                child: Center(child: Text('No se encontraron universidades.')),
              ),
            ]);
          }
          return _buildUniversities(state);
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

  Widget _buildScrollView(List<Widget> slivers, {String subtitle = ''}) {
    return CustomScrollView(
      slivers: [
        SliverAppBar.large(
          title: const Text('Universidades'),
          actions: [
            IconButton(
              tooltip: _isGrid ? 'Ver como lista' : 'Ver como cuadrícula',
              icon: Icon(_isGrid ? Icons.view_list : Icons.grid_view),
              onPressed: () => setState(() => _isGrid = !_isGrid),
            ),
          ],
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(40),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  subtitle,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
            ),
          ),
        ),
        ...slivers,
      ],
    );
  }

  Widget _buildUniversities(UniversitiesState state) {
    final visible = state.visible;
    final customData = ref.watch(universityCustomDataProvider);
    final textTheme = Theme.of(context).textTheme;

    return NotificationListener<ScrollNotification>(
      onNotification: (notification) {
        if (notification.metrics.extentAfter < _loadMoreThreshold &&
            _requestedAt != visible.length) {
          _requestedAt = visible.length;
          ref.read(universitiesProvider.notifier).loadMore();
        }
        return false;
      },
      child: _buildScrollView(
        subtitle:
            'Mostrando ${formatThousands(visible.length)} '
            'de ${formatThousands(state.all.length)}',
        [
          if (_isGrid)
            SliverPadding(
              padding: const EdgeInsets.all(16),
              sliver: SliverGrid.builder(
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 220,
                  childAspectRatio: 0.75,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                ),
                itemCount: visible.length,
                itemBuilder: (context, index) {
                  final university = visible[index];
                  final data = customData[university.id];
                  return UniversityGridCard(
                    key: ValueKey(university.id),
                    university: university,
                    imagePath: data?.imagePath,
                    studentCount: data?.studentCount,
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
                final data = customData[university.id];
                return UniversityListTile(
                  key: ValueKey(university.id),
                  university: university,
                  imagePath: data?.imagePath,
                  studentCount: data?.studentCount,
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
                  style: textTheme.bodySmall,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
