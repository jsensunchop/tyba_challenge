import 'dart:async';
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
    test('returns the parsed universities on a 200 response', () async {
      final body = jsonEncode([_item('A'), _item('B')]);

      final result = await _repositoryReturning(body, 200).getUniversities();

      expect(result.map((u) => u.name), ['A', 'B']);
    });

    test('throws AppException on a non-200 status', () {
      final repository = _repositoryReturning('Internal error', 500);

      expect(repository.getUniversities(), throwsA(isA<AppException>()));
    });

    test('throws AppException when the request times out', () {
      final repository = UniversitiesRepositoryImpl(
        MockClient((_) => Completer<http.Response>().future),
        timeout: const Duration(milliseconds: 10),
      );

      expect(repository.getUniversities(), throwsA(isA<AppException>()));
    });

    test('throws AppException on a network error', () {
      final repository = UniversitiesRepositoryImpl(
        MockClient((_) async => throw http.ClientException('No internet')),
      );

      expect(repository.getUniversities(), throwsA(isA<AppException>()));
    });

    test('throws AppException on invalid JSON', () {
      final repository = _repositoryReturning('{not json', 200);

      expect(repository.getUniversities(), throwsA(isA<AppException>()));
    });

    test('throws AppException on a malformed field', () {
      final body = jsonEncode([_item('A')..['name'] = null]);

      final repository = _repositoryReturning(body, 200);

      expect(repository.getUniversities(), throwsA(isA<AppException>()));
    });
  });
}
