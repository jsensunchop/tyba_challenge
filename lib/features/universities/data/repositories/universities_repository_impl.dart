import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../../core/errors/app_exception.dart';
import '../../domain/entities/university.dart';
import '../../domain/repositories/universities_repository.dart';
import '../parsers/universities_parser.dart';

class UniversitiesRepositoryImpl implements UniversitiesRepository {
  UniversitiesRepositoryImpl(
    this._client, {
    Duration timeout = const Duration(seconds: 15),
  }) : _timeout = timeout;

  final http.Client _client;
  final Duration _timeout;

  static final _url = Uri.parse(
    'https://tyba-assets.s3.amazonaws.com/FE-Engineer-test/universities.json',
  );

  @override
  Future<List<University>> getUniversities() async {
    final http.Response response;
    try {
      response = await _client.get(_url).timeout(_timeout);
    } on http.ClientException {
      throw const AppException(
        'No se pudo conectar. Revisa tu conexión a internet.',
      );
    } on TimeoutException {
      throw const AppException(
        'El servidor tardó demasiado en responder. Intenta de nuevo.',
      );
    }

    if (response.statusCode != 200) {
      throw AppException(
        'No se pudieron cargar las universidades '
        '(código ${response.statusCode}).',
      );
    }

    try {
      return parseUniversities(utf8.decode(response.bodyBytes));
    } catch (_) {
      throw const AppException(
        'Los datos recibidos no tienen el formato esperado.',
      );
    }
  }
}
