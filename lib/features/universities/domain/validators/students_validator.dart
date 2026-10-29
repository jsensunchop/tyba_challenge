const maxStudents = 1000000;

/// Returns an error message, or null when [input] is a valid student count.
/// Pure function so the rule can be tested without widgets.
String? validateStudents(String? input) {
  final value = input?.trim() ?? '';
  if (value.isEmpty) return 'Ingresa el número de estudiantes';

  final count = int.tryParse(value);
  if (count == null) return 'Debe ser un número entero';
  if (count <= 0) return 'Debe ser mayor que cero';
  if (count > maxStudents) return 'El valor no es realista';

  return null;
}
