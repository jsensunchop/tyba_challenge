import 'package:flutter/material.dart';

import '../../domain/entities/university.dart';
import 'students_badge.dart';
import 'university_avatar.dart';

class UniversityGridCard extends StatelessWidget {
  const UniversityGridCard({
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

    return Card(
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              UniversityAvatar(
                university: university,
                imagePath: imagePath,
                size: 64,
              ),
              const SizedBox(height: 12),
              // Flexible so large text scales shrink the name instead of
              // overflowing the fixed-height grid cell.
              Flexible(
                child: Text(
                  university.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.titleSmall,
                ),
              ),
              if (university.domains.isNotEmpty) ...[
                const SizedBox(height: 4),
                Text(
                  university.domains.first,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
              if (count != null) ...[
                const SizedBox(height: 8),
                StudentsBadge(count: count),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
