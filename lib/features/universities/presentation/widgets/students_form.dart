import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../domain/validators/students_validator.dart';
import '../utils/formatters.dart';

class StudentsForm extends StatefulWidget {
  const StudentsForm({
    super.key,
    required this.savedValue,
    required this.onSaved,
  });

  final int? savedValue;
  final ValueChanged<int> onSaved;

  @override
  State<StudentsForm> createState() => _StudentsFormState();
}

class _StudentsFormState extends State<StudentsForm> {
  late final _controller = TextEditingController(
    text: widget.savedValue?.toString() ?? '',
  );

  String? _errorText;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onChanged(String value) {
    setState(() => _errorText = validateStudents(value));
  }

  void _save() {
    final error = validateStudents(_controller.text);
    setState(() => _errorText = error);
    if (error != null) return;

    widget.onSaved(int.parse(_controller.text.trim()));
    FocusScope.of(context).unfocus();
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        icon: Icon(
          Icons.check_circle,
          color: Theme.of(context).colorScheme.primary,
          size: 48,
        ),
        title: const Text('¡Listo!'),
        content: const Text('Los cambios se guardaron correctamente.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Aceptar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: TextField(
                controller: _controller,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                onChanged: _onChanged,
                onSubmitted: (_) => _save(),
                decoration: InputDecoration(
                  hintText: 'Ej. 1200',
                  border: const OutlineInputBorder(),
                  error: _errorText != null ? const SizedBox.shrink() : null,
                ),
              ),
            ),
            const SizedBox(width: 12),
            FilledButton(
              onPressed: _save,
              style: FilledButton.styleFrom(minimumSize: const Size(0, 56)),
              child: const Text('Guardar'),
            ),
          ],
        ),
        const SizedBox(height: 6),
        _errorText != null
            ? _ErrorMessage(text: _errorText!)
            : _SavedStatus(savedValue: widget.savedValue),
      ],
    );
  }
}

class _ErrorMessage extends StatelessWidget {
  const _ErrorMessage({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Icon(Icons.error_outline, size: 16, color: theme.colorScheme.error),
        const SizedBox(width: 4),
        Flexible(
          child: Text(
            text,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.error,
            ),
          ),
        ),
      ],
    );
  }
}

class _SavedStatus extends StatelessWidget {
  const _SavedStatus({required this.savedValue});

  final int? savedValue;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final saved = savedValue;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          saved == null ? Icons.warning_amber_rounded : Icons.check_circle,
          size: 16,
          color: saved == null
              ? theme.colorScheme.tertiary
              : theme.colorScheme.primary,
        ),
        const SizedBox(width: 4),
        Flexible(
          child: Text(
            saved == null
                ? 'Aún no registrado'
                : 'Último valor guardado: ${formatThousands(saved)}',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ),
      ],
    );
  }
}
