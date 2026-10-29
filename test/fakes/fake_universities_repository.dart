import 'package:tyba_universities/core/errors/app_exception.dart';
import 'package:tyba_universities/features/universities/domain/entities/university.dart';
import 'package:tyba_universities/features/universities/domain/repositories/universities_repository.dart';

class FakeUniversitiesRepository implements UniversitiesRepository {
  FakeUniversitiesRepository({this.count = 45, this.error});

  final int count;
  AppException? error;

  int calls = 0;

  @override
  Future<List<University>> getUniversities() async {
    calls++;
    if (error != null) throw error!;
    return List.generate(
      count,
      (i) => University(
        id: i,
        name: 'University $i',
        country: 'Country',
        stateProvince: null,
        domains: ['university$i.edu'],
        webPages: const [],
      ),
    );
  }
}
