import 'dart:convert';

import '../../domain/entities/university.dart';
import '../models/university_model.dart';

List<University> parseUniversities(String body) {
  final decoded = jsonDecode(body);
  if (decoded is! List) {
    throw const FormatException('Expected a JSON list of universities');
  }

  final universities = <University>[];
  for (var i = 0; i < decoded.length; i++) {
    final item = decoded[i];
    if (item is! Map<String, dynamic>) {
      throw FormatException('Item $i is not a JSON object');
    }
    universities.add(UniversityModel.fromJson(item, i).toEntity());
  }
  return universities;
}
