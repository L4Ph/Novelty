import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:novelty/database/database.dart';
import 'package:novelty/models/novel_info.dart';
import 'package:novelty/repositories/novel_repository.dart';
import 'package:novelty/services/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

@GenerateMocks([ApiService, AppDatabase])
import 'novel_repository_library_update_test.mocks.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('NovelRepository ライブラリ小説更新テスト', () {
    late MockApiService mockApiService;
    late MockAppDatabase mockDatabase;
    late ProviderContainer container;
    late NovelRepository repository;

    setUp(() {
      mockApiService = MockApiService();
      mockDatabase = MockAppDatabase();
      
      // SharedPreferencesのモックを初期化
      SharedPreferences.setMockInitialValues({});
      
      container = ProviderContainer(
        overrides: [
          apiServiceProvider.overrideWithValue(mockApiService),
          appDatabaseProvider.overrideWithValue(mockDatabase),
        ],
      );
      
      repository = container.read(novelRepositoryProvider);
    });

    tearDown(() {
      container.dispose();
    });

    test('updateLibraryNovels が存在し、空のリストを返すこと', () async {
      // モックの設定を追加
      when(mockDatabase.getLibraryNovels()).thenAnswer((_) async => []);

      // 最小限の実装：空のリストを返す
      final result = await repository.updateLibraryNovels();
      expect(result, equals([]));
      expect(result, isA<List<String>>());
    });

    test('ライブラリに小説がない場合は空のリストを返すこと', () async {
      when(mockDatabase.getLibraryNovels()).thenAnswer((_) async => []);

      final result = await repository.updateLibraryNovels();
      expect(result, equals([]));
    });

    test('小説情報に変更がある場合、そのncodeのリストを返すこと', () async {
      // まずは失敗するテストを作成
      final libraryNovels = [
        LibraryNovel(
          ncode: 'n1234ab',
          title: '古いタイトル',
          writer: 'テスト作者1',
          story: 'あらすじ1',
          novelType: 1,
          end: 0,
          generalAllNo: 10,
          novelUpdatedAt: '2024-01-01T00:00:00.000',
          addedAt: DateTime.now().millisecondsSinceEpoch,
        ),
      ];

      // APIから更新された小説情報が返ってくる場合（変更あり）
      final apiNovelsInfo = <String, NovelInfo>{
        'n1234ab': NovelInfo(
          ncode: 'n1234ab',
          title: '新しいタイトル', // タイトルが変更されている
          writer: 'テスト作者1',
          story: 'あらすじ1',
          novelType: 1,
          end: 0,
          generalAllNo: 10,
          generalLastup: '2024-02-01T00:00:00.000Z', // 更新日時が新しい
        ),
      };

      when(mockDatabase.getLibraryNovels()).thenAnswer((_) async => libraryNovels);
      when(mockApiService.fetchMultipleNovelsInfo(any)).thenAnswer((_) async => apiNovelsInfo);

      final result = await repository.updateLibraryNovels();
      // 変更があるのでncodeが返されることを期待
      expect(result, equals(['n1234ab']));
    });

    test('変更がない場合は空のリストを返すこと', () async {
      final libraryNovels = [
        LibraryNovel(
          ncode: 'n1234ab',
          title: 'テスト小説',
          writer: 'テスト作者1',
          story: 'あらすじ1',
          novelType: 1,
          end: 0,
          generalAllNo: 10,
          novelUpdatedAt: '2024-01-01T00:00:00.000',
          addedAt: DateTime.now().millisecondsSinceEpoch,
        ),
      ];

      // APIから同じ情報が返ってくる場合（変更なし）
      final apiNovelsInfo = <String, NovelInfo>{
        'n1234ab': NovelInfo(
          ncode: 'n1234ab',
          title: 'テスト小説', // 同じタイトル
          writer: 'テスト作者1',
          story: 'あらすじ1',
          novelType: 1,
          end: 0,
          generalAllNo: 10,
          generalLastup: '2024-01-01T00:00:00.000Z', // 同じ更新日時
        ),
      };

      when(mockDatabase.getLibraryNovels()).thenAnswer((_) async => libraryNovels);
      when(mockApiService.fetchMultipleNovelsInfo(any)).thenAnswer((_) async => apiNovelsInfo);

      final result = await repository.updateLibraryNovels();
      // 変更がないので空のリストが返されることを期待
      expect(result, equals([]));
    });
  });
}