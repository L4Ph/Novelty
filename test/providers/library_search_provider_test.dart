import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:novelty/database/database.dart';
import 'package:novelty/providers/library_search_provider.dart';
import 'package:riverpod/riverpod.dart';

import 'library_provider_test.mocks.dart';

void main() {
  group('librarySearchProvider', () {
    late MockAppDatabase mockDb;
    late ProviderContainer container;

    setUp(() {
      mockDb = MockAppDatabase();
      container = ProviderContainer(
        overrides: [
          appDatabaseProvider.overrideWith((ref) => mockDb),
        ],
      );
    });

    tearDown(() {
      container.dispose();
    });

    test('初期状態では空の検索結果を返す', () {
      final provider = container.read(librarySearchProvider);
      expect(provider.hasValue, isTrue);
      expect(provider.value, equals([]));
    });

    test('検索クエリが空の場合、全ての小説を返す', () async {
      final mockNovels = [
        Novel(
          ncode: 'n1234ab',
          title: 'テスト小説',
          writer: 'テスト作者',
          fav: 1,
        ),
      ];
      
      when(mockDb.searchLibraryNovels('')).thenAnswer((_) async => mockNovels);

      final notifier = container.read(librarySearchProvider.notifier);
      await notifier.searchNovels('');

      final result = container.read(librarySearchProvider);
      expect(result.value, equals(mockNovels));
    });

    test('検索クエリに基づいて小説を検索する', () async {
      final mockNovels = [
        Novel(
          ncode: 'n1234ab',
          title: 'テスト小説',
          writer: 'テスト作者',
          fav: 1,
        ),
      ];
      
      when(mockDb.searchLibraryNovels('テスト')).thenAnswer((_) async => mockNovels);

      final notifier = container.read(librarySearchProvider.notifier);
      await notifier.searchNovels('テスト');

      final result = container.read(librarySearchProvider);
      expect(result.value, equals(mockNovels));
    });

    test('検索結果がない場合、空のリストを返す', () async {
      when(mockDb.searchLibraryNovels('存在しない')).thenAnswer((_) async => []);

      final notifier = container.read(librarySearchProvider.notifier);
      await notifier.searchNovels('存在しない');

      final result = container.read(librarySearchProvider);
      expect(result.value, equals([]));
    });

    test('検索でエラーが発生した場合、エラー状態を返す', () async {
      when(mockDb.searchLibraryNovels('エラー'))
          .thenThrow(Exception('データベースエラー'));

      final notifier = container.read(librarySearchProvider.notifier);
      await notifier.searchNovels('エラー');

      final result = container.read(librarySearchProvider);
      expect(result.hasError, isTrue);
      expect(result.error.toString(), contains('データベースエラー'));
    });

    test('検索結果をクリアできる', () async {
      // 最初に検索結果を設定
      final mockNovels = [
        Novel(
          ncode: 'n1234ab',
          title: 'テスト小説',
          writer: 'テスト作者',
          fav: 1,
        ),
      ];
      
      when(mockDb.searchLibraryNovels('テスト')).thenAnswer((_) async => mockNovels);

      final notifier = container.read(librarySearchProvider.notifier);
      await notifier.searchNovels('テスト');

      // 検索結果があることを確認
      expect(container.read(librarySearchProvider).value, equals(mockNovels));

      // 検索結果をクリア
      notifier.clearSearch();

      // 空のリストになることを確認
      expect(container.read(librarySearchProvider).value, equals([]));
    });
  });
}