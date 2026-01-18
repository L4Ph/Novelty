import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:novelty/database/database.dart' as db;
import 'package:novelty/models/novel_info.dart';
import 'package:novelty/repositories/novel_repository.dart';
import 'package:novelty/services/api_service.dart';
import 'package:novelty/utils/settings_provider.dart';

@GenerateMocks([db.AppDatabase, ApiService, NovelRepository])
import 'novel_info_offline_test.mocks.dart';

class MockSettings extends Settings {
  @override
  Future<AppSettings> build() async => const AppSettings(
    fontSize: 16,
    isVertical: false,
    themeMode: ThemeMode.system,
    lineHeight: 1.5,
    fontFamily: 'NotoSansJP',
    isIncognito: false,
    isPageFlip: false,
  );
}

void main() {
  group('NovelInfo Provider (Repository Mock)', () {
    late MockNovelRepository mockRepository;
    late MockAppDatabase mockDatabase;
    late MockApiService mockApiService;
    late ProviderContainer container;

    setUp(() {
      mockRepository = MockNovelRepository();
      mockDatabase = MockAppDatabase();
      mockApiService = MockApiService();
      container = ProviderContainer(
        overrides: [
          novelRepositoryProvider.overrideWithValue(mockRepository),
          db.appDatabaseProvider.overrideWithValue(mockDatabase),
          apiServiceProvider.overrideWithValue(mockApiService),
          settingsProvider.overrideWith(MockSettings.new),
        ],
      );
    });

    tearDown(() {
      container.dispose();
    });

    test(
      'novelInfoWithCacheProvider should return data from repository stream',
      () async {
        const testNcode = 'N1234AB';
        const testNovelInfo = NovelInfo(
          ncode: testNcode,
          title: 'Repository Title',
          novelType: 1,
        );

        // Use broadcast controller to support multiple listeners if needed
        final controller = StreamController<NovelInfo>.broadcast();
        controller.onListen = () => controller.add(testNovelInfo);

        // Use any to match normalized ncode
        when(mockRepository.watchNovelInfo(any)).thenAnswer(
          (_) => controller.stream,
        );

        final states = <AsyncValue<NovelInfo>>[];
        final sub = container.listen(
          novelInfoWithCacheProvider(testNcode),
          (_, next) => states.add(next),
        );

        // Wait for microtasks
        await Future<void>.delayed(const Duration(milliseconds: 100));

        expect(
          states.map((s) => s.asData?.value.title).where((t) => t != null),
          contains('Repository Title'),
        );
        sub.close();
      },
    );

    test(
      'novelInfoWithCacheProvider should propagate repository errors',
      () async {
        const testNcode = 'N1234AB';

        final controller = StreamController<NovelInfo>.broadcast();
        controller.onListen = () {
          scheduleMicrotask(() => controller.addError(Exception('Repo Error')));
        };

        // Use any to match normalized ncode
        when(mockRepository.watchNovelInfo(any)).thenAnswer(
          (_) => controller.stream,
        );

        final states = <AsyncValue<NovelInfo>>[];
        final sub = container.listen(
          novelInfoWithCacheProvider(testNcode),
          (_, next) => states.add(next),
        );

        // Wait for microtasks
        await Future<void>.delayed(const Duration(milliseconds: 100));

        expect(
          states.any((s) => s.hasError),
          isTrue,
        );
        sub.close();
      },
    );
  });
}
