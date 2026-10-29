import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

import '../domain/repositories/universities_repository.dart';
import 'repositories/universities_repository_impl.dart';

/// Typed with the interface so consumers depend on the contract, and tests
/// can override it with a fake.
final universitiesRepositoryProvider = Provider<UniversitiesRepository>((ref) {
  final client = http.Client();
  ref.onDispose(client.close);
  return UniversitiesRepositoryImpl(client);
});
