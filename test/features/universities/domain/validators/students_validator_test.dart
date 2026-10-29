import 'package:flutter_test/flutter_test.dart';
import 'package:tyba_universities/features/universities/domain/validators/students_validator.dart';

void main() {
  group('validateStudents', () {
    test('rejects empty input', () {
      expect(validateStudents(''), 'Ingresa el número de estudiantes');
      expect(validateStudents(null), 'Ingresa el número de estudiantes');
    });

    test('rejects whitespace only', () {
      expect(validateStudents('   '), 'Ingresa el número de estudiantes');
    });

    test('rejects letters', () {
      expect(validateStudents('abc'), 'Debe ser un número entero');
    });

    test('rejects decimals', () {
      expect(validateStudents('12.5'), 'Debe ser un número entero');
    });

    test('rejects zero', () {
      expect(validateStudents('0'), 'Debe ser mayor que cero');
    });

    test('rejects negative numbers', () {
      expect(validateStudents('-5'), 'Debe ser mayor que cero');
    });

    test('rejects values above the maximum', () {
      expect(validateStudents('1000001'), 'El valor no es realista');
    });

    test('accepts a valid number', () {
      expect(validateStudents('1500'), isNull);
      expect(validateStudents('1000000'), isNull);
    });

    test('accepts a valid number surrounded by spaces', () {
      expect(validateStudents('  1500  '), isNull);
    });
  });
}
