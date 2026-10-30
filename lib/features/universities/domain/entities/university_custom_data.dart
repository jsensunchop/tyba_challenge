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
