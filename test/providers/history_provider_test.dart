import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:novelty/database/database.dart';
import 'package:novelty/screens/history_page.dart';

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
        ),
        HistoryData(
          ncode: 'N5678CD',
          title: 'テスト小説2',
          writer: 'テスト作者2',
          lastEpisode: 10,
          viewedAt: DateTime.now().millisecondsSinceEpoch - 86400000,
        ),
      ];

      when(mockDatabase.getHistory()).thenAnswer((_) async => testHistoryData);

      final result = await container.read(historyProvider.future);

      expect(result, equals(testHistoryData));
      expect(result.length, equals(2));
      expect(result[0].ncode, equals('N1234AB'));
      expect(result[0].title, equals('テスト小説'));
      expect(result[1].ncode, equals('N5678CD'));
      verify(mockDatabase.getHistory()).called(1);
    });

    test('should return empty list when no history exists', () async {
      when(mockDatabase.getHistory()).thenAnswer((_) async => <HistoryData>[]);

      final result = await container.read(historyProvider.future);

      expect(result, isEmpty);
      verify(mockDatabase.getHistory()).called(1);
    });

    test('should handle database errors', () async {
      when(mockDatabase.getHistory()).thenThrow(Exception('Database error'));

      expect(
        () => container.read(historyProvider.future),
        throwsA(isA<Exception>()),
      );
      verify(mockDatabase.getHistory()).called(1);
    });

    test('should cache results and not call database multiple times', () async {
      final testHistoryData = [
        HistoryData(
          ncode: 'N1234AB',
          title: 'テスト小説',
          writer: 'テスト作者',
          lastEpisode: 5,
          viewedAt: DateTime.now().millisecondsSinceEpoch,
        ),
      ];

      when(mockDatabase.getHistory()).thenAnswer((_) async => testHistoryData);

      final result1 = await container.read(historyProvider.future);
      final result2 = await container.read(historyProvider.future);

      expect(result1, equals(result2));
      verify(mockDatabase.getHistory()).called(1);
    });

    test('should refresh data when provider is refreshed', () async {
      final initialData = [
        HistoryData(
          ncode: 'N1234AB',
          title: 'テスト小説',
          writer: 'テスト作者',
          lastEpisode: 5,
          viewedAt: DateTime.now().millisecondsSinceEpoch,
        ),
      ];

      final refreshedData = [
        HistoryData(
          ncode: 'N1234AB',
          title: 'テスト小説',
          writer: 'テスト作者',
          lastEpisode: 6,
          viewedAt: DateTime.now().millisecondsSinceEpoch,
        ),
        HistoryData(
          ncode: 'N5678CD',
          title: '新しい小説',
          writer: '新しい作者',
          lastEpisode: 1,
          viewedAt: DateTime.now().millisecondsSinceEpoch - 3600000,
        ),
      ];

      when(mockDatabase.getHistory()).thenAnswer((_) async => initialData);

      final initialResult = await container.read(historyProvider.future);
      expect(initialResult.length, equals(1));

      when(mockDatabase.getHistory()).thenAnswer((_) async => refreshedData);

      container.refresh(historyProvider);
      final refreshedResult = await container.read(historyProvider.future);
      expect(refreshedResult.length, equals(2));
      expect(refreshedResult[1].ncode, equals('N5678CD'));

      verify(mockDatabase.getHistory()).called(2);
    });
  });
}
