import 'dart:io';

import 'package:flutter/material.dart';

import '../../domain/entities/university.dart';
import '../utils/formatters.dart';

const _palette = [
  (background: Color(0xFFE1F5EE), foreground: Color(0xFF085041)),
  (background: Color(0xFFEEEDFE), foreground: Color(0xFF3C3489)),
  (background: Color(0xFFFAECE7), foreground: Color(0xFF712B13)),
  (background: Color(0xFFE6F1FB), foreground: Color(0xFF0C447C)),
];

class UniversityAvatar extends StatelessWidget {
  const UniversityAvatar({
    super.key,
    required this.university,
    required this.imagePath,
    required this.size,
  });

  final University university;
  final String? imagePath;
  final double size;

  @override
  Widget build(BuildContext context) {
    final path = imagePath;

    return Hero(
      tag: 'university-avatar-${university.id}',
      child: Material(
        type: MaterialType.transparency,
        child: ClipOval(
          child: SizedBox.square(
            dimension: size,
            child: path == null
                ? _initials()
                : Image.file(
                    File(path),
                    fit: BoxFit.cover,
                    errorBuilder: (context, _, _) => _initials(),
                  ),
          ),
        ),
      ),
    );
  }

  Widget _initials() {
    final colors = _palette[university.id % _palette.length];
    return ColoredBox(
      color: colors.background,
      child: Center(
        child: Text(
          initialsFor(university.name),
          style: TextStyle(
            color: colors.foreground,
            fontSize: size * 0.38,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
