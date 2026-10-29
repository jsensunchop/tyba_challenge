import '../entities/university.dart';

abstract class UniversitiesRepository {
  /// Throws `AppException` on any failure, so callers handle a single type.
  Future<List<University>> getUniversities();
}
