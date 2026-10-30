import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/university_custom_data.dart';

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
    state = {...state, id: change(current)};
  }
}

final universityCustomDataProvider =
    NotifierProvider<
      UniversityCustomDataNotifier,
      Map<int, UniversityCustomData>
    >(UniversityCustomDataNotifier.new);
