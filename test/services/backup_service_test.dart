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

    test('BackupServiceが正しくインスタンス化される', () {
      expect(backupService, isA<BackupService>());
    });

    // ファイル選択ダイアログが関わるため、実際のテストはUIテストで行う
    // ここでは基本的なインスタンス化のみテスト
  });
}
