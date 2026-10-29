/// What the user adds to a university. Kept apart from `University`, which
/// mirrors the API, so local edits never mix with remote data.
class UniversityCustomData {
  const UniversityCustomData({this.imagePath, this.studentCount});

  final String? imagePath;
  final int? studentCount;

  UniversityCustomData copyWith({String? imagePath, int? studentCount}) {
    return UniversityCustomData(
      imagePath: imagePath ?? this.imagePath,
      studentCount: studentCount ?? this.studentCount,
    );
  }
}
