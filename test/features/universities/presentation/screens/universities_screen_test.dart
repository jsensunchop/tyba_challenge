import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tyba_universities/core/errors/app_exception.dart';
import 'package:tyba_universities/features/universities/data/providers.dart';
import 'package:tyba_universities/features/universities/presentation/screens/universities_screen.dart';
import 'package:tyba_universities/features/universities/presentation/screens/university_detail_screen.dart';
import 'package:tyba_universities/features/universities/presentation/widgets/students_badge.dart';

import '../../../../fakes/fake_universities_repository.dart';

Future<void> _pumpScreen(
  WidgetTester tester,
  FakeUniversitiesRepository repository,
) {
  return tester.pumpWidget(
    ProviderScope(
      overrides: [universitiesRepositoryProvider.overrideWithValue(repository)],
      child: const MaterialApp(home: UniversitiesScreen()),
    ),
  );
}

void main() {
  testWidgets('shows a loader and then the universities', (tester) async {
    await _pumpScreen(tester, FakeUniversitiesRepository());

    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    await tester.pumpAndSettle();

    expect(find.byType(CircularProgressIndicator), findsNothing);
    expect(find.text('University 0'), findsOneWidget);
    expect(find.text('Mostrando 20 de 45'), findsOneWidget);
  });

  testWidgets('shows the error and retries on "Reintentar"', (tester) async {
    final repository = FakeUniversitiesRepository(
      error: const AppException('Sin conexión'),
    );
    await _pumpScreen(tester, repository);
    await tester.pumpAndSettle();

    expect(find.text('Sin conexión'), findsOneWidget);

    repository.error = null;
    await tester.tap(find.text('Reintentar'));
    await tester.pumpAndSettle();

    expect(repository.calls, 2);
    expect(find.text('University 0'), findsOneWidget);
  });

  testWidgets('the AppBar button toggles between list and grid', (
    tester,
  ) async {
    await _pumpScreen(tester, FakeUniversitiesRepository());
    await tester.pumpAndSettle();

    expect(find.byType(SliverList), findsOneWidget);
    expect(find.byType(SliverGrid), findsNothing);

    await tester.tap(find.byTooltip('Ver como cuadrícula'));
    await tester.pump();

    expect(find.byType(SliverGrid), findsOneWidget);
    expect(find.byType(SliverList), findsNothing);

    await tester.tap(find.byTooltip('Ver como lista'));
    await tester.pump();

    expect(find.byType(SliverList), findsOneWidget);
    expect(find.byType(SliverGrid), findsNothing);
  });

  testWidgets('tapping an item opens its detail', (tester) async {
    await _pumpScreen(tester, FakeUniversitiesRepository());
    await tester.pumpAndSettle();

    await tester.tap(find.text('University 0'));
    await tester.pumpAndSettle();

    expect(find.byType(UniversityDetailScreen), findsOneWidget);
    expect(find.text('University 0'), findsOneWidget);
  });

  testWidgets('a student count saved in the detail shows as a badge', (
    tester,
  ) async {
    await _pumpScreen(tester, FakeUniversitiesRepository());
    await tester.pumpAndSettle();
    expect(find.byType(StudentsBadge), findsNothing);

    await tester.tap(find.text('University 0'));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('Guardar'));
    await tester.enterText(find.byType(TextField), '1200');
    await tester.tap(find.text('Guardar'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Aceptar'));
    await tester.pumpAndSettle();
    await tester.pageBack();
    await tester.pumpAndSettle();

    expect(find.byType(UniversityDetailScreen), findsNothing);
    expect(find.text('1.200 estudiantes'), findsOneWidget);
    expect(find.byType(StudentsBadge), findsOneWidget);

    await tester.tap(find.byTooltip('Ver como cuadrícula'));
    await tester.pumpAndSettle();

    expect(find.text('1.200 estudiantes'), findsOneWidget);
    expect(find.byType(StudentsBadge), findsOneWidget);
  });

  testWidgets('scrolling to the end loads items beyond the first page', (
    tester,
  ) async {
    await _pumpScreen(tester, FakeUniversitiesRepository(count: 45));
    await tester.pumpAndSettle();

    expect(find.text('University 25'), findsNothing);

    await tester.scrollUntilVisible(
      find.text('No hay más items para mostrar'),
      500,
      scrollable: find.byType(Scrollable),
    );

    expect(find.text('University 44'), findsOneWidget);
  });
}
