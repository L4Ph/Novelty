import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:novelty/database/database.dart';
import 'package:novelty/services/backup_service.dart';

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
  });
}
