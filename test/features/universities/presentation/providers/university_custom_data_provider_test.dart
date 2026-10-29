import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tyba_universities/features/universities/presentation/providers/university_custom_data_provider.dart';

void main() {
  group('UniversityCustomDataNotifier', () {
    late ProviderContainer container;

    UniversityCustomDataNotifier notifier() =>
        container.read(universityCustomDataProvider.notifier);

    setUp(() => container = ProviderContainer.test());

    test('starts empty', () {
      expect(container.read(universityCustomDataProvider), isEmpty);
    });

    test('stores the image and the student count by id', () {
      notifier().setImage(1, '/images/a.jpg');
      notifier().setStudentCount(2, 300);

      final state = container.read(universityCustomDataProvider);
      expect(state[1]?.imagePath, '/images/a.jpg');
      expect(state[2]?.studentCount, 300);
    });

    test('updating one id does not affect others', () {
      notifier().setImage(1, '/images/a.jpg');

      notifier().setImage(2, '/images/b.jpg');

      final state = container.read(universityCustomDataProvider);
      expect(state[1]?.imagePath, '/images/a.jpg');
      expect(state[3], isNull);
    });

    test('updating one field keeps the other', () {
      notifier().setImage(1, '/images/a.jpg');
      notifier().setStudentCount(1, 300);

      final data = container.read(universityCustomDataProvider)[1];
      expect(data?.imagePath, '/images/a.jpg');
      expect(data?.studentCount, 300);
    });

    test('replaces the map instead of mutating it', () {
      final before = container.read(universityCustomDataProvider);

      notifier().setStudentCount(1, 300);

      expect(container.read(universityCustomDataProvider), isNot(same(before)));
      expect(before, isEmpty);
    });
  });
}
