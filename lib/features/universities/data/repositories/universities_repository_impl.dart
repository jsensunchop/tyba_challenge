import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../../core/errors/app_exception.dart';
import '../../domain/entities/university.dart';
import '../../domain/repositories/universities_repository.dart';
import '../models/university_model.dart';

class UniversitiesRepositoryImpl implements UniversitiesRepository {
  UniversitiesRepositoryImpl(this._client);

  final http.Client _client;

  static final _url = Uri.parse(
    'https://tyba-assets.s3.amazonaws.com/FE-Engineer-test/universities.json',
  );
  static const _timeout = Duration(seconds: 15);

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
      // Decode bytes as UTF-8 explicitly instead of trusting the
      // Content-Type header to declare the charset.
      final items = jsonDecode(utf8.decode(response.bodyBytes)) as List;
      return [
        for (var i = 0; i < items.length; i++)
          UniversityModel.fromJson(
            items[i] as Map<String, dynamic>,
            i,
          ).toEntity(),
      ];
    } catch (_) {
      // Invalid JSON (FormatException) or an unexpected shape (TypeError).
      throw const AppException(
        'Los datos recibidos no tienen el formato esperado.',
      );
    }
  }
}
