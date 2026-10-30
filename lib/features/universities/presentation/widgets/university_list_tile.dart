import 'package:flutter/material.dart';

import '../../domain/entities/university.dart';
import 'students_badge.dart';
import 'university_avatar.dart';

class UniversityListTile extends StatelessWidget {
  const UniversityListTile({
    super.key,
    required this.university,
    required this.imagePath,
    required this.studentCount,
    required this.onTap,
  });

  final University university;
  final String? imagePath;
  final int? studentCount;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final count = studentCount;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Card(
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                UniversityAvatar(
                  university: university,
                  imagePath: imagePath,
                  size: 40,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(university.name, style: theme.textTheme.titleSmall),
                      if (university.domains.isNotEmpty)
                        Text(
                          university.domains.first,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      if (count != null) ...[
                        const SizedBox(height: 6),
                        StudentsBadge(count: count),
                      ],
                    ],
                  ),
                ),
                Icon(
                  Icons.chevron_right,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
