import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../domain/validators/students_validator.dart';

class StudentsForm extends StatefulWidget {
  const StudentsForm({
    super.key,
    required this.initialValue,
    required this.onSaved,
  });

  final int? initialValue;
  final ValueChanged<int> onSaved;

  @override
  State<StudentsForm> createState() => _StudentsFormState();
}

class _StudentsFormState extends State<StudentsForm> {
  final _formKey = GlobalKey<FormState>();
  late final _controller = TextEditingController(
    text: widget.initialValue?.toString() ?? '',
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;

    widget.onSaved(int.parse(_controller.text.trim()));
    FocusScope.of(context).unfocus();
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        icon: const Icon(Icons.check_circle, color: Colors.green, size: 48),
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
    return Form(
      key: _formKey,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: TextFormField(
              controller: _controller,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: const InputDecoration(
                hintText: 'Ej. 1200',
                border: OutlineInputBorder(),
              ),
              validator: validateStudents,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              onFieldSubmitted: (_) => _save(),
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
    );
  }
}
