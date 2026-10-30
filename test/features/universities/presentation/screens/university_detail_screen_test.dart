import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tyba_universities/features/universities/domain/entities/university.dart';
import 'package:tyba_universities/features/universities/presentation/providers/image_picker_service_provider.dart';
import 'package:tyba_universities/features/universities/presentation/providers/university_custom_data_provider.dart';
import 'package:tyba_universities/features/universities/presentation/screens/university_detail_screen.dart';

import '../../../../fakes/fake_image_picker_service.dart';

const _university = University(
  id: 7,
  name: 'Marywood University',
  country: 'United States',
  stateProvince: null,
  domains: ['marywood.edu'],
  webPages: ['http://www.marywood.edu'],
);

Future<ProviderContainer> _pumpDetail(
  WidgetTester tester, {
  University university = _university,
  FakeImagePickerService? picker,
}) async {
  final container = ProviderContainer.test(
    overrides: [
      imagePickerServiceProvider.overrideWithValue(
        picker ?? FakeImagePickerService(),
      ),
    ],
  );
  await tester.pumpWidget(
    UncontrolledProviderScope(
      container: container,
      child: MaterialApp(home: UniversityDetailScreen(university: university)),
    ),
  );
  return container;
}

Future<void> _pickFromGallery(WidgetTester tester) async {
  await tester.tap(find.byTooltip('Cambiar imagen'));
  await tester.pumpAndSettle();
  await tester.tap(find.text('Galería'));
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('shows name and country, and hides a null state-province', (
    tester,
  ) async {
    await _pumpDetail(tester);

    expect(find.text('Marywood University'), findsOneWidget);
    expect(find.text('United States'), findsOneWidget);
  });

  testWidgets('shows the state-province when present', (tester) async {
    const university = University(
      id: 1,
      name: 'Penn State',
      country: 'United States',
      stateProvince: 'Pennsylvania',
      domains: [],
      webPages: [],
    );
    await _pumpDetail(tester, university: university);

    expect(find.text('Pennsylvania, United States'), findsOneWidget);
  });

  testWidgets('shows domains as chips and web pages', (tester) async {
    await _pumpDetail(tester);

    expect(find.widgetWithText(Chip, 'marywood.edu'), findsOneWidget);
    expect(find.text('http://www.marywood.edu'), findsOneWidget);
  });

  group('students form', () {
    testWidgets('shows the error for an invalid value', (tester) async {
      await _pumpDetail(tester);

      await tester.ensureVisible(find.byType(TextField));
      await tester.enterText(find.byType(TextField), '0');
      await tester.pump();

      expect(find.text('Debe ser mayor que cero'), findsOneWidget);
      expect(find.byIcon(Icons.error_outline), findsOneWidget);
      expect(find.text('Aún no registrado'), findsNothing);
    });

    testWidgets('fixing an invalid value hides the error', (tester) async {
      await _pumpDetail(tester);

      await tester.ensureVisible(find.byType(TextField));
      await tester.enterText(find.byType(TextField), '0');
      await tester.pump();
      await tester.enterText(find.byType(TextField), '1500');
      await tester.pump();

      expect(find.text('Debe ser mayor que cero'), findsNothing);
      expect(find.byIcon(Icons.error_outline), findsNothing);
      expect(find.text('Aún no registrado'), findsOneWidget);
    });

    testWidgets('saving an empty field shows the error', (tester) async {
      await _pumpDetail(tester);

      await tester.ensureVisible(find.text('Guardar'));
      await tester.tap(find.text('Guardar'));
      await tester.pumpAndSettle();

      expect(find.text('Ingresa el número de estudiantes'), findsOneWidget);
      expect(find.byType(AlertDialog), findsNothing);
    });

    testWidgets('saves a valid value into the state', (tester) async {
      final container = await _pumpDetail(tester);

      await tester.ensureVisible(find.text('Guardar'));
      await tester.enterText(find.byType(TextField), '1500');
      await tester.tap(find.text('Guardar'));
      await tester.pumpAndSettle();

      expect(
        container.read(universityCustomDataProvider)[7]?.studentCount,
        1500,
      );
      expect(find.byType(AlertDialog), findsOneWidget);
      expect(
        find.descendant(
          of: find.byType(AlertDialog),
          matching: find.byIcon(Icons.check_circle),
        ),
        findsOneWidget,
      );
      expect(
        find.text('Los cambios se guardaron correctamente.'),
        findsOneWidget,
      );

      await tester.tap(find.text('Aceptar'));
      await tester.pumpAndSettle();

      expect(find.byType(AlertDialog), findsNothing);
    });

    testWidgets('the helper text shows the last saved value', (tester) async {
      await _pumpDetail(tester);

      expect(find.text('Aún no registrado'), findsOneWidget);
      expect(find.byIcon(Icons.warning_amber_rounded), findsOneWidget);
      expect(find.byIcon(Icons.check_circle), findsNothing);

      await tester.ensureVisible(find.text('Guardar'));
      await tester.enterText(find.byType(TextField), '1500');
      await tester.tap(find.text('Guardar'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Aceptar'));
      await tester.pumpAndSettle();

      expect(find.text('Aún no registrado'), findsNothing);
      expect(find.text('Último valor guardado: 1.500'), findsOneWidget);
      expect(find.byIcon(Icons.warning_amber_rounded), findsNothing);
      expect(find.byIcon(Icons.check_circle), findsOneWidget);
    });

    testWidgets('an invalid value does not show the success dialog', (
      tester,
    ) async {
      await _pumpDetail(tester);

      await tester.ensureVisible(find.text('Guardar'));
      await tester.enterText(find.byType(TextField), '0');
      await tester.tap(find.text('Guardar'));
      await tester.pumpAndSettle();

      expect(find.byType(AlertDialog), findsNothing);
    });
  });

  group('image', () {
    testWidgets('picking from the gallery stores the path', (tester) async {
      final container = await _pumpDetail(
        tester,
        picker: FakeImagePickerService(path: '/images/campus.jpg'),
      );
      expect(find.byType(Image), findsNothing);

      await _pickFromGallery(tester);

      expect(
        container.read(universityCustomDataProvider)[7]?.imagePath,
        '/images/campus.jpg',
      );
      expect(find.byType(Image), findsOneWidget);
    });

    testWidgets('cancelling the picker changes nothing', (tester) async {
      final container = await _pumpDetail(
        tester,
        picker: FakeImagePickerService(path: null),
      );

      await _pickFromGallery(tester);

      expect(container.read(universityCustomDataProvider), isEmpty);
      expect(find.byType(SnackBar), findsNothing);
    });

    testWidgets('a picker error shows a SnackBar', (tester) async {
      final container = await _pumpDetail(
        tester,
        picker: FakeImagePickerService(
          error: Exception('camera_access_denied'),
        ),
      );

      await _pickFromGallery(tester);

      expect(find.text('No se pudo obtener la imagen'), findsOneWidget);
      expect(container.read(universityCustomDataProvider), isEmpty);
    });
  });
}
