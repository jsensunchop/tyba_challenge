import 'package:flutter_test/flutter_test.dart';
import 'package:tyba_universities/features/universities/presentation/utils/formatters.dart';

void main() {
  group('initialsFor', () {
    test('uses the first letter of the first two words', () {
      expect(initialsFor('Marywood University'), 'MU');
    });

    test('ignores connector words', () {
      expect(initialsFor('Florida State College at Jacksonville'), 'FS');
      expect(initialsFor('University of Pittsburgh'), 'UP');
      expect(initialsFor('Washington & Jefferson College'), 'WJ');
      expect(initialsFor('Universidad de Antioquia'), 'UA');
    });

    test('ignores words that do not start with a letter', () {
      expect(initialsFor('Columbia College (SC)'), 'CC');
    });

    test('uses a single letter for a single word', () {
      expect(initialsFor('Harvard'), 'H');
    });

    test('tolerates extra spaces and lowercase', () {
      expect(initialsFor('  rice   university  '), 'RU');
    });
  });

  group('formatThousands', () {
    test('adds dots as thousands separators', () {
      expect(formatThousands(0), '0');
      expect(formatThousands(999), '999');
      expect(formatThousands(1000), '1.000');
      expect(formatThousands(1200), '1.200');
      expect(formatThousands(1000000), '1.000.000');
    });
  });
}
