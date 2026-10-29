import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/university_custom_data.dart';

/// User edits indexed by `University.id`. Separate from the universities
/// provider on purpose: reloading the list must not wipe what the user edited.
class UniversityCustomDataNotifier
    extends Notifier<Map<int, UniversityCustomData>> {
  @override
  Map<int, UniversityCustomData> build() => const {};

  void setImage(int id, String path) {
    _update(id, (data) => data.copyWith(imagePath: path));
  }

  void setStudentCount(int id, int count) {
    _update(id, (data) => data.copyWith(studentCount: count));
  }

  void _update(
    int id,
    UniversityCustomData Function(UniversityCustomData data) change,
  ) {
    final current = state[id] ?? const UniversityCustomData();
    // A new map, so listeners see a new state instead of a mutated one.
    state = {...state, id: change(current)};
  }
}

final universityCustomDataProvider =
    NotifierProvider<
      UniversityCustomDataNotifier,
      Map<int, UniversityCustomData>
    >(UniversityCustomDataNotifier.new);
