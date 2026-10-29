import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tyba_universities/core/errors/app_exception.dart';
import 'package:tyba_universities/features/universities/data/providers.dart';
import 'package:tyba_universities/features/universities/presentation/providers/universities_provider.dart';

import '../../../../fakes/fake_universities_repository.dart';

ProviderContainer _containerWith(FakeUniversitiesRepository repository) {
  return ProviderContainer.test(
    overrides: [universitiesRepositoryProvider.overrideWithValue(repository)],
  );
}

void main() {
  group('UniversitiesNotifier', () {
    late ProviderContainer container;

    UniversitiesState currentState() =>
        container.read(universitiesProvider).value!;

    void loadMore() => container.read(universitiesProvider.notifier).loadMore();

    setUp(() async {
      container = _containerWith(FakeUniversitiesRepository(count: 45));
      await container.read(universitiesProvider.future);
    });

    test('initial load exposes the first page', () {
      expect(currentState().visible, hasLength(20));
      expect(currentState().hasMore, isTrue);
    });

    test('loadMore shows the next page', () {
      loadMore();

      expect(currentState().visible, hasLength(40));
    });

    test('the last loadMore shows the remaining items', () {
      loadMore();
      loadMore();

      expect(currentState().visible, hasLength(45));
      expect(currentState().hasMore, isFalse);
    });

    test('loadMore does nothing when there are no more items', () {
      loadMore();
      loadMore();
      final before = currentState();

      loadMore();

      expect(currentState(), same(before));
    });
  });

  test('exposes an error when the repository throws', () async {
    final container = _containerWith(
      FakeUniversitiesRepository(error: const AppException('Falla')),
    );

    await expectLater(
      container.read(universitiesProvider.future),
      throwsA(isA<AppException>()),
    );
    expect(container.read(universitiesProvider).hasError, isTrue);
  });
}
