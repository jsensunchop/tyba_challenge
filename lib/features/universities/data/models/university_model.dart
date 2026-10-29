import '../../domain/entities/university.dart';

class UniversityModel {
  const UniversityModel({
    required this.id,
    required this.name,
    required this.country,
    required this.stateProvince,
    required this.domains,
    required this.webPages,
  });

  /// [id] comes from the caller because the JSON item has none
  /// (see [University.id]).
  factory UniversityModel.fromJson(Map<String, dynamic> json, int id) {
    return UniversityModel(
      id: id,
      name: _cleanName(json['name'] as String),
      country: json['country'] as String,
      stateProvince: json['state-province'] as String?,
      domains: _stringList(json['domains']),
      webPages: _stringList(json['web_pages']),
    );
  }

  final int id;
  final String name;
  final String country;
  final String? stateProvince;
  final List<String> domains;
  final List<String> webPages;

  University toEntity() {
    return University(
      id: id,
      name: name,
      country: country,
      stateProvince: stateProvince,
      domains: domains,
      webPages: webPages,
    );
  }

  // The source data has two known artifacts: an escaped `&` and invisible
  // zero-width spaces. These are the only ones present, so no generic decoder.
  static String _cleanName(String raw) {
    return raw.replaceAll('&amp;', '&').replaceAll('​', '');
  }

  static List<String> _stringList(Object? value) {
    if (value == null) return const [];
    return List<String>.from(value as List);
  }
}
