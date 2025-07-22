import 'dart:convert';
import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:novelty/database/database.dart';
import 'package:novelty/services/backup_service.dart';
import 'package:path/path.dart' as p;

import 'backup_service_test.mocks.dart';

@GenerateMocks([AppDatabase])
void main() {
  group('BackupService', () {
    late MockAppDatabase mockDatabase;
    late BackupService backupService;

    setUp(() {
      mockDatabase = MockAppDatabase();
      backupService = BackupService(mockDatabase);
    });

    group('ライブラリデータのエクスポート', () {
      test('ライブラリ登録済み小説をJSONでエクスポートできる', () async {
        // 実際のテストでは具体的な実装を確認するため、
        // シンプルなケースで動作確認を行う
        final result = await backupService.exportLibraryData();

        // 基本的な構造を確認
        expect(result, isA<Map<String, dynamic>>());
        expect(result['version'], equals('1.0'));
        expect(result['exportedAt'], isA<String>());
        expect(result['data'], isA<List<dynamic>>());
      });
    });

    group('履歴データのエクスポート', () {
      test('履歴データをJSONでエクスポートできる', () async {
        // 基本的な構造を確認
        final result = await backupService.exportHistoryData();

        expect(result, isA<Map<String, dynamic>>());
        expect(result['version'], equals('1.0'));
        expect(result['exportedAt'], isA<String>());
        expect(result['data'], isA<List<dynamic>>());
      });
    });

    group('データのインポート', () {
      test('有効なライブラリデータをインポートできる', () async {
        final jsonData = {
          'version': '1.0',
          'exportedAt': '2022-01-01T00:00:00.000Z',
          'data': <Map<String, dynamic>>[
            {
              'ncode': 'n1234ab',
              'title': 'テスト小説1',
              'writer': 'テスト作者1',
              'fav': 1,
            },
          ],
        };

        // エラーが発生しないことを確認
        await expectLater(
          backupService.importLibraryData(jsonData),
          completes,
        );
      });

      test('有効な履歴データをインポートできる', () async {
        final jsonData = {
          'version': '1.0',
          'exportedAt': '2022-01-01T00:00:00.000Z',
          'data': <Map<String, dynamic>>[
            {
              'ncode': 'n1234ab',
              'title': 'テスト小説1',
              'writer': 'テスト作者1',
              'lastEpisode': 5,
              'viewedAt': 1640995200,
            },
          ],
        };

        await expectLater(
          backupService.importHistoryData(jsonData),
          completes,
        );
      });

      test('無効なバージョンの場合は例外を投げる', () async {
        final jsonData = {
          'version': '2.0',
          'data': <dynamic>[],
        };

        expect(
          () => backupService.importLibraryData(jsonData),
          throwsA(isA<Exception>()),
        );
      });
    });

    group('ダウンロードデータの復元', () {
      late Directory tempDir;
      late String testDownloadPath;

      setUp(() async {
        tempDir = await Directory.systemTemp.createTemp('novelty_test');
        testDownloadPath = tempDir.path;
      });

      tearDown(() async {
        if (await tempDir.exists()) {
          await tempDir.delete(recursive: true);
        }
      });

      test('ダウンロードフォルダから小説情報を正しく復元できる', () async {
        // テスト用のダウンロードフォルダ構造を作成
        const ncode1 = 'n1234ab';
        const ncode2 = 'n5678cd';
        
        // 小説1のフォルダとinfo.jsonを作成
        final novel1Dir = Directory(p.join(testDownloadPath, ncode1));
        await novel1Dir.create(recursive: true);
        final novel1InfoFile = File(p.join(novel1Dir.path, 'info.json'));
        final novel1Info = {
          'title': 'テスト小説1',
          'ncode': ncode1,
          'writer': 'テスト作者1',
          'story': 'これはテスト小説です',
          'novel_type': 1,
          'end': 1,
          'general_all_no': 10,
        };
        await novel1InfoFile.writeAsString(jsonEncode(novel1Info));

        // 小説2のフォルダとinfo.jsonを作成
        final novel2Dir = Directory(p.join(testDownloadPath, ncode2));
        await novel2Dir.create(recursive: true);
        final novel2InfoFile = File(p.join(novel2Dir.path, 'info.json'));
        final novel2Info = {
          'title': 'テスト小説2',
          'ncode': ncode2,
          'writer': 'テスト作者2',
          'story': 'これも另一個テスト小説です',
          'novel_type': 2,
          'end': 0,
          'general_all_no': 1,
        };
        await novel2InfoFile.writeAsString(jsonEncode(novel2Info));

        // モックの設定
        when(mockDatabase.insertNovel(any)).thenAnswer((_) async => 1);
        when(mockDatabase.addToLibrary(any)).thenAnswer((_) async => 1);

        // 復元処理の実行
        final result = await backupService.restoreFromDownloadDirectory(testDownloadPath);

        // 結果の確認
        expect(result, equals(2)); // 2つの小説が復元された

        // insertNovelが2回呼ばれたことを確認
        verify(mockDatabase.insertNovel(any)).called(2);
        
        // addToLibraryが2回呼ばれたことを確認  
        verify(mockDatabase.addToLibrary(any)).called(2);
      });

      test('info.jsonファイルが存在しないフォルダは無視される', () async {
        // info.jsonのないフォルダを作成
        final emptyDir = Directory(p.join(testDownloadPath, 'empty_folder'));
        await emptyDir.create(recursive: true);
        
        // 通常のファイルを作成（フォルダではない）
        final normalFile = File(p.join(testDownloadPath, 'normal_file.txt'));
        await normalFile.writeAsString('normal content');

        // 復元処理の実行
        final result = await backupService.restoreFromDownloadDirectory(testDownloadPath);

        // 結果の確認
        expect(result, equals(0)); // 復元された小説は0個

        // データベース操作が呼ばれていないことを確認
        verifyNever(mockDatabase.insertNovel(any));
        verifyNever(mockDatabase.addToLibrary(any));
      });

      test('無効なJSONファイルがある場合はそのファイルをスキップする', () async {
        const ncode1 = 'n1234ab';
        const ncode2 = 'n5678cd';
        
        // 有効な小説フォルダを作成
        final novel1Dir = Directory(p.join(testDownloadPath, ncode1));
        await novel1Dir.create(recursive: true);
        final novel1InfoFile = File(p.join(novel1Dir.path, 'info.json'));
        final novel1Info = {
          'title': 'テスト小説1',
          'ncode': ncode1,
          'writer': 'テスト作者1',
        };
        await novel1InfoFile.writeAsString(jsonEncode(novel1Info));

        // 無効なJSONファイルを持つフォルダを作成
        final novel2Dir = Directory(p.join(testDownloadPath, ncode2));
        await novel2Dir.create(recursive: true);
        final novel2InfoFile = File(p.join(novel2Dir.path, 'info.json'));
        await novel2InfoFile.writeAsString('invalid json content');

        // モックの設定
        when(mockDatabase.insertNovel(any)).thenAnswer((_) async => 1);
        when(mockDatabase.addToLibrary(any)).thenAnswer((_) async => 1);

        // 復元処理の実行
        final result = await backupService.restoreFromDownloadDirectory(testDownloadPath);

        // 結果の確認：有効な1つの小説のみが復元される
        expect(result, equals(1));

        // insertNovelが1回だけ呼ばれたことを確認
        verify(mockDatabase.insertNovel(any)).called(1);
        verify(mockDatabase.addToLibrary(any)).called(1);
      });

      test('存在しないディレクトリの場合は0を返す', () async {
        const nonExistentPath = '/non/existent/path';
        
        // 復元処理の実行
        final result = await backupService.restoreFromDownloadDirectory(nonExistentPath);

        // 結果の確認
        expect(result, equals(0));

        // データベース操作が呼ばれていないことを確認
        verifyNever(mockDatabase.insertNovel(any));
        verifyNever(mockDatabase.addToLibrary(any));
      });

      test('確認ダイアログ用のダウンロードパス検証ができる', () async {
        // 有効なダウンロードフォルダを作成
        const ncode = 'n1234ab';
        final novelDir = Directory(p.join(testDownloadPath, ncode));
        await novelDir.create(recursive: true);
        final infoFile = File(p.join(novelDir.path, 'info.json'));
        await infoFile.writeAsString(jsonEncode({'title': 'test', 'ncode': ncode}));

        // ダウンロードパスの検証
        final result = await backupService.validateDownloadPath(testDownloadPath);
        
        expect(result.isValid, isTrue);
        expect(result.foundNovelsCount, equals(1));
        expect(result.sampleNcodes, contains(ncode));
      });

      test('ダウンロードデータが存在しない場合の検証結果', () async {
        // 空のディレクトリでの検証
        final result = await backupService.validateDownloadPath(testDownloadPath);
        
        expect(result.isValid, isFalse);
        expect(result.foundNovelsCount, equals(0));
        expect(result.sampleNcodes, isEmpty);
      });
    });
  });
}
