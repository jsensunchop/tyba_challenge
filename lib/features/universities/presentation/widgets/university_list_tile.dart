import 'package:flutter/material.dart';

import '../../domain/entities/university.dart';

class UniversityListTile extends StatelessWidget {
  const UniversityListTile({
    super.key,
    required this.university,
    required this.onTap,
  });

  final University university;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final details = [
      if (university.stateProvince != null) university.stateProvince!,
      if (university.domains.isNotEmpty) university.domains.first,
    ];

    return ListTile(
      title: Text(university.name),
      subtitle: details.isEmpty ? null : Text(details.join('\n')),
      onTap: onTap,
    );
  }
}
