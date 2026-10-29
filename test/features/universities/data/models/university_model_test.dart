import 'package:flutter_test/flutter_test.dart';
import 'package:tyba_universities/features/universities/data/models/university_model.dart';

Map<String, dynamic> _json({
  String name = 'Marywood University',
  String? stateProvince,
  List<String>? domains = const ['marywood.edu'],
}) {
  return {
    'alpha_two_code': 'US',
    'domains': domains,
    'country': 'United States',
    'state-province': stateProvince,
    'web_pages': ['http://www.marywood.edu'],
    'name': name,
  };
}

void main() {
  group('UniversityModel.fromJson', () {
    test('parses a regular item', () {
      final model = UniversityModel.fromJson(_json(), 7);

      expect(model.id, 7);
      expect(model.name, 'Marywood University');
      expect(model.country, 'United States');
      expect(model.domains, ['marywood.edu']);
      expect(model.webPages, ['http://www.marywood.edu']);
    });

    test('keeps a null state-province as null', () {
      final model = UniversityModel.fromJson(_json(), 0);

      expect(model.stateProvince, isNull);
    });

    test('reads state-province when present', () {
      final model = UniversityModel.fromJson(_json(stateProvince: 'PA'), 0);

      expect(model.stateProvince, 'PA');
    });

    test('decodes &amp; in the name', () {
      final model = UniversityModel.fromJson(
        _json(name: 'Washington &amp; Jefferson College'),
        0,
      );

      expect(model.name, 'Washington & Jefferson College');
    });

    test('removes zero-width spaces from the name', () {
      final model = UniversityModel.fromJson(
        _json(name: 'Mid-​South Community College'),
        0,
      );

      expect(model.name, 'Mid-South Community College');
    });

    test('parses several domains', () {
      final model = UniversityModel.fromJson(
        _json(domains: ['rutgers.edu', 'camden.rutgers.edu']),
        0,
      );

      expect(model.domains, ['rutgers.edu', 'camden.rutgers.edu']);
    });

    test('treats null lists as empty', () {
      final json = _json(domains: null)..['web_pages'] = null;

      final model = UniversityModel.fromJson(json, 0);

      expect(model.domains, isEmpty);
      expect(model.webPages, isEmpty);
    });
  });

  test('toEntity copies every field', () {
    final entity = UniversityModel.fromJson(
      _json(stateProvince: 'PA'),
      3,
    ).toEntity();

    expect(entity.id, 3);
    expect(entity.name, 'Marywood University');
    expect(entity.country, 'United States');
    expect(entity.stateProvince, 'PA');
    expect(entity.domains, ['marywood.edu']);
    expect(entity.webPages, ['http://www.marywood.edu']);
  });
}
