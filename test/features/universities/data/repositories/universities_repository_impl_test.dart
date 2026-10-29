import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:tyba_universities/core/errors/app_exception.dart';
import 'package:tyba_universities/features/universities/data/repositories/universities_repository_impl.dart';

Map<String, dynamic> _item(String name) {
  return {
    'alpha_two_code': 'US',
    'domains': ['example.edu'],
    'country': 'United States',
    'state-province': null,
    'web_pages': ['http://www.example.edu'],
    'name': name,
  };
}

UniversitiesRepositoryImpl _repositoryReturning(String body, int status) {
  return UniversitiesRepositoryImpl(
    MockClient((_) async => http.Response(body, status)),
  );
}

void main() {
  group('UniversitiesRepositoryImpl.getUniversities', () {
    test('returns entities with ids assigned by position', () async {
      final body = jsonEncode([_item('A'), _item('B'), _item('C')]);

      final result = await _repositoryReturning(body, 200).getUniversities();

      expect(result.map((u) => u.id), [0, 1, 2]);
      expect(result.map((u) => u.name), ['A', 'B', 'C']);
    });

    test('gives distinct ids to items with the same name', () async {
      final body = jsonEncode([
        _item('College of DuPage'),
        _item('College of DuPage'),
      ]);

      final result = await _repositoryReturning(body, 200).getUniversities();

      expect(result[0].name, result[1].name);
      expect(result[0].id, isNot(result[1].id));
    });

    test('throws AppException on a non-200 status', () {
      final repository = _repositoryReturning('Internal error', 500);

      expect(repository.getUniversities(), throwsA(isA<AppException>()));
    });

    test('throws AppException on invalid JSON', () {
      final repository = _repositoryReturning('{not json', 200);

      expect(repository.getUniversities(), throwsA(isA<AppException>()));
    });

    test('throws AppException on a network error', () {
      final repository = UniversitiesRepositoryImpl(
        MockClient((_) async => throw http.ClientException('No internet')),
      );

      expect(repository.getUniversities(), throwsA(isA<AppException>()));
    });
  });
}
