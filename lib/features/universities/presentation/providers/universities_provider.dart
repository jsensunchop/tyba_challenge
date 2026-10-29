import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/providers.dart';
import '../../domain/entities/university.dart';

class UniversitiesState {
  const UniversitiesState({required this.all, required this.visibleCount});

  final List<University> all;
  final int visibleCount;

  List<University> get visible => all.take(visibleCount).toList();
  bool get hasMore => visibleCount < all.length;
}

/// The API returns every university in a single response, so pagination
/// happens in memory: the notifier only decides how many items are visible.
class UniversitiesNotifier extends AsyncNotifier<UniversitiesState> {
  static const pageSize = 20;

  @override
  Future<UniversitiesState> build() async {
    final universities =
        await ref.watch(universitiesRepositoryProvider).getUniversities();
    return UniversitiesState(all: universities, visibleCount: pageSize);
  }

  /// Synchronous because the data is already in memory: there is nothing to
  /// wait for and nothing that can fail.
  void loadMore() {
    final current = state.value;
    if (current == null || !current.hasMore) return;

    state = AsyncData(
      UniversitiesState(
        all: current.all,
        visibleCount: min(current.visibleCount + pageSize, current.all.length),
      ),
    );
  }
}

final universitiesProvider =
    AsyncNotifierProvider<UniversitiesNotifier, UniversitiesState>(
  UniversitiesNotifier.new,
  // Riverpod 3 retries failed providers automatically, which would keep the
  // spinner up for about a minute while offline. The screen offers an
  // explicit "Reintentar" button instead.
  retry: (_, _) => null,
);
