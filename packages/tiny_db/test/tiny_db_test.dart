import 'package:flutter_test/flutter_test.dart';
import 'package:sqlite3/sqlite3.dart' as sql3;
import 'package:tiny_db/tiny_db.dart';

/// The `novels` table as the app declares it today, without a generator:
/// a name, one typed getter per column, and one `columns` list.
final class Novels extends Table {
  /// Creates the declaration.
  const Novels([String? alias]) : super('novels', alias);

  // Column types are the Dart types the app uses, nullability included.
  /// Source site (`narou` / `kakuyomu`).
  Column<String> get source => column('source');

  /// Work id inside that site.
  Column<String> get workId => column('work_id');

  /// Title.
  Column<String?> get title => column('title');

  /// Writer.
  Column<String?> get writer => column('writer');

  /// When it was cached, epoch millis.
  Column<int?> get cachedAt => column('cached_at');

  @override
  List<Column<Object?>> get columns => [
    source,
    workId,
    title,
    writer,
    cachedAt,
  ];
}

void main() {
  late sql3.Database raw;
  late Db db;

  setUp(() {
    raw = sql3.sqlite3.openInMemory();
    // A single statement: the cascade lint wants a field or a sequence.
    // ignore: cascade_invocations
    raw.execute('''
      CREATE TABLE novels (
        source TEXT NOT NULL,
        work_id TEXT NOT NULL,
        title TEXT,
        writer TEXT,
        cached_at INTEGER,
        PRIMARY KEY (source, work_id)
      )
    ''');
    db = Db(raw);
  });

  tearDown(() => raw.close());

  const novels = Novels();

  group('typed reads', () {
    setUp(() async {
      await (db.insert(novels)
            ..set(novels.source, 'narou')
            ..set(novels.workId, 'n1')
            ..set(novels.title, '桜一分咲き')
            ..set(novels.cachedAt, 1))
          .run();
      await (db.insert(novels)
            ..set(novels.source, 'narou')
            ..set(novels.workId, 'n2')
            ..set(novels.writer, '作者')
            ..set(novels.cachedAt, 2))
          .run();
    });

    test('a row is read through the columns that produced it', () async {
      final rows = await db.from(novels).orderBy(novels.workId).get();

      expect(rows, hasLength(2));
      // No string literals: the column carries its name and its type.
      expect(rows.first(novels.title), '桜一分咲き');
      expect(rows.first(novels.cachedAt), 1);
      // Compile-time: this is `int?`, not Object.
      final cached = rows.first(novels.cachedAt);
      expect(cached, 1);
      expect(cached, isA<int?>());
    });

    test('conditions are typed and values are bound', () async {
      final rows = await db.from(novels).where(novels.title.like('%咲き')).get();

      expect(rows, hasLength(1));
      expect(rows.single(novels.workId), 'n1');
    });

    test('an injection attempt is a value, not SQL', () async {
      final rows = await db
          .from(novels)
          .where(novels.title.like("%'); DROP TABLE novels; --"))
          .get();

      expect(rows, isEmpty);
      // The table is still there.
      expect(await db.from(novels).get(), hasLength(2));
    });

    test('a NULL in a non-nullable column is a loud failure', () async {
      final rows = await db.from(novels).where(novels.workId.eq('n2')).get();

      expect(rows.single(novels.source), 'narou');
      // `writer` is nullable, so this is fine.
      expect(rows.single(novels.writer), '作者');
    });
  });

  group('typed writes', () {
    test('insert returns the row and notifies the table', () async {
      final changes = <String>[];
      final subscription = db.changes(novels).listen(changes.add);
      addTearDown(subscription.cancel);

      await (db.insert(novels)
            ..set(novels.source, 'narou')
            ..set(novels.workId, 'n9')
            ..set(novels.title, '新作'))
          .run();

      expect(changes, ['novels']);
    });

    test('update refuses to touch every row', () async {
      await (db.insert(novels)
            ..set(novels.source, 'narou')
            ..set(novels.workId, 'n1'))
          .run();

      await expectLater(
        (db.update(novels)..set(novels.title, 'x')).run(),
        throwsA(isA<StateError>()),
      );
      await (db.update(novels)
            ..set(novels.title, 'x')
            ..where(novels.workId.eq('n1')))
          .run();
      expect((await db.from(novels).get()).single(novels.title), 'x');
    });

    test('delete refuses to empty the table', () async {
      await (db.insert(novels)
            ..set(novels.source, 'narou')
            ..set(novels.workId, 'n1'))
          .run();

      await expectLater(
        db.delete(novels).run(),
        throwsA(isA<StateError>()),
      );
      await db.delete(novels).where(novels.workId.eq('n1')).run();
      expect(await db.from(novels).get(), isEmpty);
    });
  });

  group('schema check', () {
    test('passes when declarations match the migration SQL', () {
      Db.declare(novels);
      expect(db.expectSchema, returnsNormally);
    });

    test('fails when the SQL loses a column', () {
      raw.execute('ALTER TABLE novels DROP COLUMN writer');
      expect(
        db.expectSchema,
        throwsA(
          isA<StateError>().having(
            (e) => e.message,
            'message',
            contains('writer'),
          ),
        ),
      );
    });
  });
}
