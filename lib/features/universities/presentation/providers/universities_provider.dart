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

class UniversitiesNotifier extends AsyncNotifier<UniversitiesState> {
  static const pageSize = 20;

  @override
  Future<UniversitiesState> build() async {
    final universities = await ref
        .watch(universitiesRepositoryProvider)
        .getUniversities();
    return UniversitiesState(all: universities, visibleCount: pageSize);
  }

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
      retry: (_, _) => null,
    );
