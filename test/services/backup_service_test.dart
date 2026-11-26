import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:novelty/database/database.dart';
import 'package:novelty/services/backup_service.dart';
import 'package:novelty/services/file_picker.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:sqlite3/sqlite3.dart';

import 'backup_service_test.mocks.dart';

/// Serves a fixed directory so the service never touches the real filesystem.
class _FakePathProvider extends Fake
    with MockPlatformInterfaceMixin
    implements PathProviderPlatform {
  _FakePathProvider(this.root);

  final String root;

  @override
  Future<String?> getApplicationDocumentsPath() async => root;

  @override
  Future<String?> getTemporaryPath() async => root;

  @override
  Future<String?> getApplicationSupportPath() async => root;
}

/// Hands the service a file the test prepared instead of opening a picker.
class _FakePicker extends FilePicker {
  _FakePicker({this.toPick, this.saveResult})
    : super(supported: true, channel: const MethodChannel('unused'));

  final String? toPick;
  final String? saveResult;

  String? savedSourcePath;
  String? savedSuggestedName;

  /// Whether the source still existed while the platform was "copying" it.
  bool sourceExistedDuringSave = false;

  @override
  Future<String?> pickFile({
    required String cacheDirectory,
    List<String> extensions = const <String>[],
    String? dialogTitle,
  }) async => toPick;

  @override
  Future<String?> saveFile({
    required String sourcePath,
    required String suggestedName,
    String? dialogTitle,
  }) async {
    savedSourcePath = sourcePath;
    savedSuggestedName = suggestedName;
    // Mirrors the platform: the document picker reads the source only after the
    // user has chosen a destination, which is long after saveFile starts.
    await Future<void>.delayed(const Duration(milliseconds: 10));
    sourceExistedDuringSave = File(sourcePath).existsSync();
    return saveResult;
  }
}

@GenerateMocks([AppDatabase])
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late Directory root;
  late MockAppDatabase db;

  setUp(() {
    root = Directory.systemTemp.createTempSync('backup_test');
    PathProviderPlatform.instance = _FakePathProvider(root.path);
    db = MockAppDatabase();
  });

  tearDown(() {
    if (root.existsSync()) {
      root.deleteSync(recursive: true);
    }
  });

  /// Writes a SQLite file at [path], optionally without the app's tables.
  String writeDatabase(
    String name, {
    int userVersion = 19,
    bool withTables = true,
  }) {
    final path = '${root.path}/$name';
    final database = sqlite3.open(path);
    if (withTables) {
      for (final table in <String>[
        'novels',
        'episode_list_entries',
        'episode_contents',
        'library_entries',
        'reading_history',
      ]) {
        database.execute('CREATE TABLE $table (id INTEGER PRIMARY KEY)');
      }
    } else {
      database.execute('CREATE TABLE unrelated (id INTEGER PRIMARY KEY)');
    }
    database
      ..userVersion = userVersion
      ..close();
    return path;
  }

  /// Makes the mocked VACUUM INTO behave like the real one by writing a file.
  void stubVacuumInto() {
    when(db.customStatement(any)).thenAnswer((invocation) async {
      final sql = invocation.positionalArguments.first as String;
      final match = RegExp("VACUUM INTO '(.+)'").firstMatch(sql);
      if (match != null) {
        File(match.group(1)!.replaceAll("''", "'")).writeAsStringSync('backup');
      }
    });
  }

  group('BackupService', () {
    test('currentSchemaVersion mirrors the database', () {
      expect(
        BackupService.currentSchemaVersion,
        AppDatabase.currentSchemaVersion,
      );
    });

    group('stageImport', () {
      test('reports a cancellation', () async {
        final service = BackupService(db, picker: _FakePicker());

        final staged = await service.stageImport();

        expect(staged.cancelled, isTrue);
        expect(staged.pendingFilePath, isNull);
      });

      test('rejects a file that is not SQLite', () async {
        final path = '${root.path}/not_a_database.db';
        File(path).writeAsStringSync('x' * 200);
        final service = BackupService(db, picker: _FakePicker(toPick: path));

        await expectLater(
          service.stageImport(),
          throwsA(
            isA<FormatException>().having(
              (e) => e.message,
              'message',
              contains('SQLite'),
            ),
          ),
        );
        expect(
          File('${root.path}/novelty.db.import_pending').existsSync(),
          isFalse,
        );
      });

      test('rejects a SQLite file that is not a Novelty backup', () async {
        final path = writeDatabase('foreign.db', withTables: false);
        final service = BackupService(db, picker: _FakePicker(toPick: path));

        await expectLater(
          service.stageImport(),
          throwsA(isA<FormatException>()),
        );
      });

      test('rejects a backup from a newer schema', () async {
        final path = writeDatabase('newer.db', userVersion: 999);
        final service = BackupService(db, picker: _FakePicker(toPick: path));

        await expectLater(
          service.stageImport(),
          throwsA(
            isA<FormatException>().having(
              (e) => e.message,
              'message',
              contains('新しいバージョン'),
            ),
          ),
        );
      });

      test('accepts a valid backup and stages it', () async {
        final path = writeDatabase('backup.db');
        final service = BackupService(db, picker: _FakePicker(toPick: path));

        final staged = await service.stageImport();

        expect(staged.cancelled, isFalse);
        expect(
          staged.pendingFilePath,
          '${root.path}/novelty.db.import_pending',
        );
        expect(File(staged.pendingFilePath!).existsSync(), isTrue);
        // The picked copy is the caller's to clean up.
        expect(File(path).existsSync(), isFalse);
      });
    });

    group('exportDatabaseToFile', () {
      test('writes a consistent copy and hands it to the picker', () async {
        stubVacuumInto();
        final picker = _FakePicker(saveResult: 'backup_saved.db');
        final service = BackupService(db, picker: picker);

        final saved = await service.exportDatabaseToFile();

        expect(saved, equals('backup_saved.db'));
        expect(picker.savedSourcePath, isNotNull);
        // Regression: returning the Future without awaiting it ran the
        // `finally` (which deletes the temp file) before the picker copied it.
        expect(picker.sourceExistedDuringSave, isTrue);
        expect(
          picker.savedSuggestedName,
          matches(
            RegExp(
              r'^novelty_backup_\d{8}_\d{6}_v'
              '${AppDatabase.currentSchemaVersion}'
              r'\.db$',
            ),
          ),
        );
        // The temporary copy is removed once the picker has it.
        expect(File(picker.savedSourcePath!).existsSync(), isFalse);
      });
    });
  });
}
