import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tyba_universities/features/universities/domain/entities/university.dart';
import 'package:tyba_universities/features/universities/presentation/widgets/university_avatar.dart';

const _university = University(
  id: 3,
  name: 'Marywood University',
  country: 'United States',
  stateProvince: null,
  domains: ['marywood.edu'],
  webPages: [],
);

Future<void> _pumpAvatar(WidgetTester tester, {String? imagePath}) {
  return tester.pumpWidget(
    MaterialApp(
      home: Scaffold(
        body: UniversityAvatar(
          university: _university,
          imagePath: imagePath,
          size: 40,
        ),
      ),
    ),
  );
}

void main() {
  testWidgets('shows the initials when there is no image', (tester) async {
    await _pumpAvatar(tester);

    expect(find.text('MU'), findsOneWidget);
    expect(find.byType(Image), findsNothing);
  });

  testWidgets('shows the image when a path is set', (tester) async {
    await _pumpAvatar(tester, imagePath: '/images/campus.jpg');

    expect(find.byType(Image), findsOneWidget);
  });

  testWidgets('uses a hero tag based on the university id', (tester) async {
    await _pumpAvatar(tester);

    final hero = tester.widget<Hero>(find.byType(Hero));
    expect(hero.tag, 'university-avatar-3');
  });
}
