import 'dart:io';

import 'package:flutter/material.dart';

class UniversityImage extends StatelessWidget {
  const UniversityImage({super.key, required this.path, this.iconSize = 48});

  final String? path;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    final path = this.path;
    if (path == null) return _placeholder(context);

    return Image.file(
      File(path),
      fit: BoxFit.cover,
      errorBuilder: (context, _, _) => _placeholder(context),
    );
  }

  Widget _placeholder(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return ColoredBox(
      color: colors.surfaceContainerHighest,
      child: Center(
        child: Icon(
          Icons.school_outlined,
          size: iconSize,
          color: colors.onSurfaceVariant,
        ),
      ),
    );
  }
}
