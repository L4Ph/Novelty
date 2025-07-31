import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:novelty/database/database.dart';
import 'package:novelty/providers/history_provider.dart';

@GenerateMocks([AppDatabase])
import 'history_provider_test.mocks.dart';

void main() {
  group('historyProvider', () {
    late MockAppDatabase mockDatabase;
    late ProviderContainer container;

    setUp(() {
      mockDatabase = MockAppDatabase();
      container = ProviderContainer(
        overrides: [
          appDatabaseProvider.overrideWithValue(mockDatabase),
        ],
      );
    });

    tearDown(() {
      container.dispose();
    });

    test('should return history data when database call succeeds', () async {
      final testHistoryData = [
        HistoryData(
          ncode: 'N1234AB',
          title: 'テスト小説',
          writer: 'テスト作者',
          lastEpisode: 5,
          viewedAt: DateTime.now().millisecondsSinceEpoch,
          updatedAt: DateTime.now().millisecondsSinceEpoch,
        ),
        HistoryData(
          ncode: 'N5678CD',
          title: 'テスト小説2',
          writer: 'テスト作者2',
          lastEpisode: 10,
          viewedAt: DateTime.now().millisecondsSinceEpoch - 86400000,
          updatedAt: DateTime.now().millisecondsSinceEpoch - 86400000,
        ),
      ];

      when(mockDatabase.watchHistory()).thenAnswer((_) => Stream.value(testHistoryData));

      // StreamProviderをlistenして結果を取得
      AsyncValue<List<HistoryData>>? result;
      container.listen<AsyncValue<List<HistoryData>>>(
        historyProvider,
        (previous, next) {
          result = next;
        },
      );

      // ProviderContainerを一度読み込むことでlistenをトリガー
      container.read(historyProvider);

      // 少し待ってStreamが評価される時間を作る
      await Future.delayed(const Duration(milliseconds: 10));

      expect(result, isA<AsyncData<List<HistoryData>>>());
      final data = result!.asData!.value;
      expect(data, equals(testHistoryData));
      expect(data.length, equals(2));
      expect(data[0].ncode, equals('N1234AB'));
      expect(data[0].title, equals('テスト小説'));
      expect(data[1].ncode, equals('N5678CD'));
      verify(mockDatabase.watchHistory()).called(1);
    }, timeout: const Timeout(Duration(seconds: 5)));

    test('should return empty list when no history exists', () async {
      when(mockDatabase.watchHistory()).thenAnswer((_) => Stream.value(<HistoryData>[]));

      AsyncValue<List<HistoryData>>? result;
      container.listen<AsyncValue<List<HistoryData>>>(
        historyProvider,
        (previous, next) {
          result = next;
        },
      );

      container.read(historyProvider);
      await Future.delayed(const Duration(milliseconds: 10));

      expect(result, isA<AsyncData<List<HistoryData>>>());
      final data = result!.asData!.value;
      expect(data, isEmpty);
      verify(mockDatabase.watchHistory()).called(1);
    }, timeout: const Timeout(Duration(seconds: 5)));

    test('should handle database errors', () async {
      when(mockDatabase.watchHistory()).thenAnswer((_) => Stream.error(Exception('Database error')));

      AsyncValue<List<HistoryData>>? result;
      container.listen<AsyncValue<List<HistoryData>>>(
        historyProvider,
        (previous, next) {
          result = next;
        },
      );

      container.read(historyProvider);
      await Future.delayed(const Duration(milliseconds: 10));

      expect(result, isA<AsyncError<List<HistoryData>>>());
      expect(result!.asError!.error, isA<Exception>());
      verify(mockDatabase.watchHistory()).called(1);
    }, timeout: const Timeout(Duration(seconds: 5)));

    test('should continuously emit data when stream changes', () async {
      final initialData = [
        HistoryData(
          ncode: 'N1234AB',
          title: 'テスト小説',
          writer: 'テスト作者',
          lastEpisode: 5,
          viewedAt: DateTime.now().millisecondsSinceEpoch,
          updatedAt: DateTime.now().millisecondsSinceEpoch,
        ),
      ];

      final updatedData = [
        HistoryData(
          ncode: 'N1234AB',
          title: 'テスト小説',
          writer: 'テスト作者',
          lastEpisode: 6,
          viewedAt: DateTime.now().millisecondsSinceEpoch,
          updatedAt: DateTime.now().millisecondsSinceEpoch,
        ),
        HistoryData(
          ncode: 'N5678CD',
          title: '新しい小説',
          writer: '新しい作者',
          lastEpisode: 1,
          viewedAt: DateTime.now().millisecondsSinceEpoch - 3600000,
          updatedAt: DateTime.now().millisecondsSinceEpoch - 3600000,
        ),
      ];

      when(mockDatabase.watchHistory()).thenAnswer((_) => Stream.fromIterable([initialData, updatedData]));

      final results = <AsyncValue<List<HistoryData>>>[];
      container.listen<AsyncValue<List<HistoryData>>>(
        historyProvider,
        (previous, next) {
          results.add(next);
        },
      );

      container.read(historyProvider);
      await Future.delayed(const Duration(milliseconds: 100));

      expect(results.length, greaterThanOrEqualTo(2));
      expect(results[0], isA<AsyncData<List<HistoryData>>>());
      expect(results[0].asData!.value.length, equals(1));
      expect(results[0].asData!.value[0].lastEpisode, equals(5));
      
      if (results.length > 1) {
        expect(results[1], isA<AsyncData<List<HistoryData>>>());
        expect(results[1].asData!.value.length, equals(2));
        expect(results[1].asData!.value[0].lastEpisode, equals(6));
      }

      verify(mockDatabase.watchHistory()).called(1);
    }, timeout: const Timeout(Duration(seconds: 5)));
  });
}
