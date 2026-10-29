import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/university.dart';
import '../providers/image_picker_service_provider.dart';
import '../providers/university_custom_data_provider.dart';
import '../widgets/students_form.dart';
import '../widgets/university_image.dart';

// Own enum instead of image_picker's ImageSource, so the screen doesn't
// depend on the plugin; only ImagePickerService does.
enum _ImageOrigin { camera, gallery }

class UniversityDetailScreen extends ConsumerWidget {
  const UniversityDetailScreen({super.key, required this.university});

  final University university;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final customData = ref.watch(
      universityCustomDataProvider.select((all) => all[university.id]),
    );
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Detalle')),
      // Scrollable so the form stays reachable with the keyboard open.
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: UniversityImage(path: customData?.imagePath),
              ),
            ),
            const SizedBox(height: 8),
            OutlinedButton.icon(
              onPressed: () => _pickImage(context, ref),
              icon: const Icon(Icons.add_a_photo_outlined),
              label: Text(
                customData?.imagePath == null
                    ? 'Agregar imagen'
                    : 'Cambiar imagen',
              ),
            ),
            const SizedBox(height: 16),
            Text(university.name, style: textTheme.headlineSmall),
            const SizedBox(height: 16),
            _InfoItem(label: 'País', value: university.country),
            if (university.stateProvince != null)
              _InfoItem(
                label: 'Estado / provincia',
                value: university.stateProvince!,
              ),
            if (university.domains.isNotEmpty)
              _InfoItem(
                label: 'Dominios',
                value: university.domains.join('\n'),
              ),
            if (university.webPages.isNotEmpty)
              _InfoItem(
                label: 'Páginas web',
                value: university.webPages.join('\n'),
              ),
            const Divider(height: 32),
            StudentsForm(
              initialValue: customData?.studentCount,
              onSaved: (count) => ref
                  .read(universityCustomDataProvider.notifier)
                  .setStudentCount(university.id, count),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickImage(BuildContext context, WidgetRef ref) async {
    final origin = await showModalBottomSheet<_ImageOrigin>(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo_camera_outlined),
              title: const Text('Cámara'),
              onTap: () => Navigator.pop(context, _ImageOrigin.camera),
            ),
            ListTile(
              leading: const Icon(Icons.photo_library_outlined),
              title: const Text('Galería'),
              onTap: () => Navigator.pop(context, _ImageOrigin.gallery),
            ),
          ],
        ),
      ),
    );
    if (origin == null) return;

    // Read before awaiting: `ref` can't be used once the screen is gone.
    final picker = ref.read(imagePickerServiceProvider);
    final notifier = ref.read(universityCustomDataProvider.notifier);

    try {
      final path = origin == _ImageOrigin.camera
          ? await picker.pickFromCamera()
          : await picker.pickFromGallery();
      if (path == null) return;
      notifier.setImage(university.id, path);
    } on Exception {
      // Denied permission or no camera (e.g. iOS simulator).
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No se pudo obtener la imagen')),
      );
    }
  }
}

class _InfoItem extends StatelessWidget {
  const _InfoItem({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: textTheme.labelMedium),
          Text(value, style: textTheme.bodyLarge),
        ],
      ),
    );
  }
}
