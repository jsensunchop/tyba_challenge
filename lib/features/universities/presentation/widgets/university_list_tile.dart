import 'package:flutter/material.dart';

import '../../domain/entities/university.dart';
import 'university_image.dart';

class UniversityListTile extends StatelessWidget {
  const UniversityListTile({
    super.key,
    required this.university,
    required this.imagePath,
    required this.onTap,
  });

  final University university;
  final String? imagePath;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final details = [
      if (university.stateProvince != null) university.stateProvince!,
      if (university.domains.isNotEmpty) university.domains.first,
    ];

    return ListTile(
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: SizedBox.square(
          dimension: 48,
          child: UniversityImage(path: imagePath, iconSize: 24),
        ),
      ),
      title: Text(university.name),
      subtitle: details.isEmpty ? null : Text(details.join('\n')),
      onTap: onTap,
    );
  }
}
