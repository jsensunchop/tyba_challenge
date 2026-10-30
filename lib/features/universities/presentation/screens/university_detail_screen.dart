import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/university.dart';
import '../providers/image_picker_service_provider.dart';
import '../providers/university_custom_data_provider.dart';
import '../widgets/students_form.dart';
import '../widgets/university_avatar.dart';

enum _ImageOrigin { camera, gallery }

class UniversityDetailScreen extends ConsumerWidget {
  const UniversityDetailScreen({super.key, required this.university});

  final University university;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final customData = ref.watch(
      universityCustomDataProvider.select((all) => all[university.id]),
    );
    final theme = Theme.of(context);
    final location = [
      if (university.stateProvince != null) university.stateProvince!,
      university.country,
    ].join(', ');

    return Scaffold(
      appBar: AppBar(title: const Text('Detalle')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  UniversityAvatar(
                    university: university,
                    imagePath: customData?.imagePath,
                    size: 96,
                  ),
                  Positioned(
                    right: -4,
                    bottom: -4,
                    child: IconButton.filled(
                      tooltip: 'Cambiar imagen',
                      onPressed: () => _pickImage(context, ref),
                      icon: const Icon(Icons.camera_alt, size: 20),
                      style: IconButton.styleFrom(
                        backgroundColor: theme.colorScheme.tertiary,
                        foregroundColor: theme.colorScheme.onTertiary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Text(
              university.name,
              textAlign: TextAlign.center,
              style: theme.textTheme.titleLarge,
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.location_on_outlined,
                  size: 16,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                const SizedBox(width: 4),
                Flexible(
                  child: Text(
                    location,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            _Section(
              label: 'Número de estudiantes',
              child: StudentsForm(
                savedValue: customData?.studentCount,
                onSaved: (count) => ref
                    .read(universityCustomDataProvider.notifier)
                    .setStudentCount(university.id, count),
              ),
            ),
            if (university.domains.isNotEmpty)
              _Section(
                label: 'Dominios',
                child: Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    for (final domain in university.domains)
                      Chip(label: Text(domain)),
                  ],
                ),
              ),
            if (university.webPages.isNotEmpty)
              _Section(
                label: 'Sitios web',
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    for (final url in university.webPages)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Row(
                          children: [
                            Icon(
                              Icons.public,
                              size: 18,
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                            const SizedBox(width: 8),
                            Expanded(child: SelectableText(url)),
                          ],
                        ),
                      ),
                  ],
                ),
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

    final picker = ref.read(imagePickerServiceProvider);
    final notifier = ref.read(universityCustomDataProvider.notifier);

    try {
      final path = origin == _ImageOrigin.camera
          ? await picker.pickFromCamera()
          : await picker.pickFromGallery();
      if (path == null) return;
      notifier.setImage(university.id, path);
    } on Exception {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No se pudo obtener la imagen')),
      );
    }
  }
}

class _Section extends StatelessWidget {
  const _Section({required this.label, required this.child});

  final String label;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: theme.textTheme.labelMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 12),
              child,
            ],
          ),
        ),
      ),
    );
  }
}
