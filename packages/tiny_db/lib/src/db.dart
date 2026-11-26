import 'dart:async';

import 'package:sqlite3/sqlite3.dart' as sql3;

import 'package:tiny_db/src/column.dart';

/// A table declaration: a name plus typed column getters.
///
/// Declarations are ordinary Dart — no generator — but [columns] lists every
/// column once, which lets [Db.expectSchema] fail a test when a declaration and
/// the migration SQL disagree.
abstract base class Table {
  /// Creates a table, optionally under an [alias] for joins.
  const Table(this.name, [String? alias]) : alias = alias ?? name;

  /// The SQL table name.
  final String name;

  /// The name used to qualify columns, which is [name] unless joined.
  final String alias;

  /// Every column, for schema checks and `SELECT`.
  List<Column<Object?>> get columns;

  /// Declares a column of this table.
  Column<T> column<T>(String name) => Column<T>(alias, name);
}

/// One row of a result, read through the columns that produced it.
final class Row {
  /// Wraps a sqlite3 row.
  const Row(this._row);

  final sql3.Row _row;

  /// Reads [column] as its declared type.
  ///
  /// Throws when the value is NULL and the column is not nullable, so a
  /// schema mismatch surfaces here instead of as a null deep in the UI.
  T call<T>(Column<T> column) {
    final value = _row[column.name];
    if (value is T) return value;
    if (value == null) {
      if (null is T) return null as T;
      throw StateError(
        'Column ${column.sql} is NULL but declared as non-nullable $T',
      );
    }
    throw StateError(
      'Column ${column.sql} holds ${value.runtimeType}, declared as $T',
    );
  }

  /// The raw value, for the rare case that needs it.
  Object? raw(String name) => _row[name];
}

/// Builds and runs statements against a sqlite3 database.
final class Db {
  /// Wraps an open database.
  Db(this._db);

  final sql3.Database _db;
  final _changes = StreamController<String>.broadcast(sync: true);

  /// Runs [body] in a transaction.
  T transaction<T>(T Function() body) {
    _db.execute('BEGIN');
    try {
      final result = body();
      _db.execute('COMMIT');
      return result;
    } on Object {
      _db.execute('ROLLBACK');
      rethrow;
    }
  }

  /// Rows of [table], newest first by default is left to the caller.
  Select from(Table table) => Select(this, table);

  /// `INSERT` builder. Values are typed by the column they are set on.
  Insert insert(Table table) => Insert(this, table);

  /// `UPDATE` builder.
  Update update(Table table) => Update(this, table);

  /// `DELETE` builder.
  Delete delete(Table table) => Delete(this, table);

  /// Emits the table name whenever [table] is written through this [Db].
  Stream<String> changes(Table table) =>
      _changes.stream.where((name) => name == table.name);

  /// Runs a statement and writes the rows.
  ///
  /// [notify] is the table written, when it is a single one.
  List<Row> run(String sql, List<Object?> args, {String? notify}) {
    final statement = _db.prepare(sql);
    try {
      // `select` also runs INSERT/UPDATE/DELETE (they simply return no rows),
      // so one call covers both without executing twice.
      final rows = statement.select(args);
      if (notify != null) _changes.add(notify);
      return rows.map(Row.new).toList();
    } finally {
      statement.close();
    }
  }

  /// Checks the declarations against the live schema.
  ///
  /// Call it from a test: every declared column must exist with the declared
  /// SQL type, and every table column must be declared. Without a generator
  /// this is what turns a renamed column into a red test instead of a runtime
  /// `NULL`.
  void expectSchema() {
    _declared.forEach(_check);
  }

  static final _declared = <Table>[];

  /// Registers [table] for [Db.expectSchema].
  static void declare(Table table) => _declared.add(table);

  void _check(Table table) {
    final rows = _db.select('PRAGMA table_info("${table.name}")');
    if (rows.isEmpty) {
      throw StateError('Table ${table.name} does not exist');
    }
    final actual = {
      for (final row in rows) row['name'] as String: row['type'] as String,
    };
    final declared = {for (final column in table.columns) column.name};
    for (final column in table.columns) {
      if (!actual.containsKey(column.name)) {
        throw StateError(
          'Declared column ${table.name}.${column.name} does not exist',
        );
      }
    }
    final undeclared = actual.keys.toSet().difference(declared);
    if (undeclared.isNotEmpty) {
      throw StateError(
        'Table ${table.name} has undeclared columns: $undeclared',
      );
    }
  }
}

/// A `SELECT` under construction.
final class Select {
  /// Creates a select over the given table.
  Select(this._db, this._table);

  final Db _db;
  final Table _table;
  final _where = <Expr>[];
  final _orderBy = <String>[];
  int? _limit;
  int? _offset;

  /// Adds a condition; several are joined with `AND`.
  Select where(Expr condition) => this.._where.add(condition);

  /// `ORDER BY`. Use `column.desc` for descending.
  Select orderBy(Column<Object?> column) =>
      this.._orderBy.add('${column.sql} ASC');

  /// `ORDER BY ... DESC`.
  Select orderByDesc(Column<Object?> column) =>
      this.._orderBy.add('${column.sql} DESC');

  /// `LIMIT`.
  Select limit(int count) => this.._limit = count;

  /// `OFFSET`.
  Select offset(int count) => this.._offset = count;

  String get _sql {
    final buffer = StringBuffer('SELECT * FROM "${_table.name}"');
    if (_where.isNotEmpty) {
      buffer.write(' WHERE ${_where.map((e) => e.sql).join(' AND ')}');
    }
    if (_orderBy.isNotEmpty) buffer.write(' ORDER BY ${_orderBy.join(', ')}');
    if (_limit != null) buffer.write(' LIMIT $_limit');
    if (_offset != null) buffer.write(' OFFSET $_offset');
    return buffer.toString();
  }

  /// Runs the statement.
  Future<List<Row>> get() async => _db.run(_sql, [
    for (final condition in _where) ...condition.args,
  ]);
}

/// An `INSERT` under construction.
final class Insert {
  /// Creates an insert into the given table.
  Insert(this._db, this._table);

  final Db _db;
  final Table _table;
  final _values = <String, Object?>{};

  /// Sets [column] to [value]. The value type is the column's type.
  void set<T>(Column<T> column, T value) => _values[column.name] = value;

  /// Runs the statement and returns the new row id.
  Future<int> run() async {
    final names = _values.keys.toList();
    final sql =
        'INSERT INTO "${_table.name}" '
        '(${names.map((n) => '"$n"').join(', ')}) '
        'VALUES (${names.map((_) => '?').join(', ')})';
    _db.run(sql, _values.values.toList(), notify: _table.name);
    return _db._db.lastInsertRowId;
  }
}

/// An `UPDATE` under construction.
final class Update {
  /// Creates an update of the given table.
  Update(this._db, this._table);

  final Db _db;
  final Table _table;
  final _values = <String, Object?>{};
  final _where = <Expr>[];

  /// Sets [column] to [value].
  void set<T>(Column<T> column, T value) => _values[column.name] = value;

  /// Adds a condition; several are joined with `AND`.
  Update where(Expr condition) => this.._where.add(condition);

  /// Runs the statement. Refuses to touch every row.
  Future<int> run() async {
    if (_where.isEmpty) {
      throw StateError('UPDATE without WHERE would touch every row');
    }
    final sql =
        'UPDATE "${_table.name}" SET '
        '${_values.keys.map((n) => '"$n" = ?').join(', ')} '
        'WHERE ${_where.map((e) => e.sql).join(' AND ')}';
    _db.run(sql, [
      ..._values.values,
      for (final condition in _where) ...condition.args,
    ], notify: _table.name);
    return _db._db.updatedRows;
  }
}

/// A `DELETE` under construction.
final class Delete {
  /// Creates a delete from the given table.
  Delete(this._db, this._table);

  final Db _db;
  final Table _table;
  final _where = <Expr>[];

  /// Adds a condition; several are joined with `AND`.
  Delete where(Expr condition) => this.._where.add(condition);

  /// Runs the statement. Refuses to delete every row.
  Future<int> run() async {
    if (_where.isEmpty) {
      throw StateError('DELETE without WHERE would empty the table');
    }
    final sql =
        'DELETE FROM "${_table.name}" '
        'WHERE ${_where.map((e) => e.sql).join(' AND ')}';
    _db.run(sql, [
      for (final condition in _where) ...condition.args,
    ], notify: _table.name);
    return _db._db.updatedRows;
  }
}
