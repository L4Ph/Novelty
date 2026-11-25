import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:novelty/database/database.dart' as db;
import 'package:novelty/models/novel_info.dart';
import 'package:novelty/repositories/novel_repository.dart';
import 'package:novelty/services/api_service.dart';
import 'package:novelty/sites/novel_source.dart';
import 'package:novelty/utils/async_subscription.dart';
import 'package:tiny_state/tiny_state.dart';

@GenerateMocks([db.AppDatabase, ApiService, NovelRepository])
import 'novel_info_offline_test.mocks.dart';

void main() {
  group('NovelInfo stream (Repository Mock)', () {
    late MockNovelRepository mockRepository;

    setUp(() => mockRepository = MockNovelRepository());

    test('watches the repository stream and exposes its data', () async {
      const testNovelInfo = NovelInfo(
        ncode: 'N1234AB',
        title: 'Repository Title',
        novelType: 1,
      );

      final controller = StreamController<NovelInfo>.broadcast();
      controller.onListen = () => controller.add(testNovelInfo);
      when(
        mockRepository.watchNovelInfo(NovelSource.narou, any),
      ).thenAnswer((_) => controller.stream);

      final binding = AsyncSubscription<NovelInfo>(
        mockRepository.watchNovelInfo(NovelSource.narou, 'N1234AB'),
      );
      addTearDown(binding.cancel);
      addTearDown(controller.close);

      await Future<void>.delayed(const Duration(milliseconds: 100));

      expect(binding.state.valueOrNull?.title, 'Repository Title');
      verify(
        mockRepository.watchNovelInfo(NovelSource.narou, any),
      ).called(1);
    });

    test('propagates repository errors', () async {
      final controller = StreamController<NovelInfo>.broadcast();
      controller.onListen = () {
        scheduleMicrotask(() => controller.addError(Exception('Repo Error')));
      };
      when(
        mockRepository.watchNovelInfo(NovelSource.narou, any),
      ).thenAnswer((_) => controller.stream);

      final binding = AsyncSubscription<NovelInfo>(
        mockRepository.watchNovelInfo(NovelSource.narou, 'N1234AB'),
      );
      addTearDown(binding.cancel);
      addTearDown(controller.close);

      await Future<void>.delayed(const Duration(milliseconds: 100));

      expect(binding.state, isA<AsyncError<NovelInfo>>());
    });
  });
}
