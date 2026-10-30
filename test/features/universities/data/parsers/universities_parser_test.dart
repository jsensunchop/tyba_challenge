import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:tyba_universities/features/universities/data/parsers/universities_parser.dart';

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

void main() {
  group('parseUniversities', () {
    test('assigns ids by position', () {
      final body = jsonEncode([_item('A'), _item('B'), _item('C')]);

      final result = parseUniversities(body);

      expect(result.map((u) => u.id), [0, 1, 2]);
      expect(result.map((u) => u.name), ['A', 'B', 'C']);
    });

    test('gives distinct ids to items with the same name', () {
      final body = jsonEncode([
        _item('College of DuPage'),
        _item('College of DuPage'),
      ]);

      final result = parseUniversities(body);

      expect(result[0].name, result[1].name);
      expect(result[0].id, isNot(result[1].id));
    });

    test('cleans &amp; and zero-width spaces from names', () {
      final body = jsonEncode([
        _item('Washington &amp; Jefferson College'),
        _item('Mid-​South Community College'),
      ]);

      final result = parseUniversities(body);

      expect(result[0].name, 'Washington & Jefferson College');
      expect(result[1].name, 'Mid-South Community College');
    });

    test('throws FormatException when the root is not a list', () {
      expect(
        () => parseUniversities(jsonEncode({'name': 'A'})),
        throwsFormatException,
      );
    });

    test('throws FormatException when an item is not an object', () {
      expect(
        () => parseUniversities(jsonEncode([_item('A'), 'not an object'])),
        throwsFormatException,
      );
    });
  });
}
