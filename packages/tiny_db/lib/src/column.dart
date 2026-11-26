/// Column and expression descriptors: the compile-time half of the API.
///
/// A [Column] carries its SQL type so that a value of the wrong Dart type does
/// not compile, and its table so that joins can qualify names. Nothing here
/// knows how to run a statement; `Db` does.
library;

// Column is a value object; the lint wants @immutable from flutter/foundation,
// which this package deliberately does not depend on.
// ignore_for_file: avoid_equals_and_hash_code_on_mutable_classes

/// A column of `T`, declared once per table as a getter.
///
/// `T` is the Dart type the column stores. Nullability is part of it:
/// `Col<String>` cannot be compared to `null`, `Col<String?>` cannot be used
/// where a non-null value is required.
final class Column<T> {
  /// Creates a column of [table] named [name].
  const Column(this.table, this.name);

  /// The table the column belongs to (its alias when joined).
  final String table;

  /// The SQL name.
  final String name;

  /// `"table"."name"`, ready for a select list or a join condition.
  String get sql => '"$table"."$name"';

  /// `=`
  Expr eq(T value) => Expr('$sql = ?', [value]);

  /// `<>`
  Expr neq(T value) => Expr('$sql <> ?', [value]);

  /// `IS NULL`. Only meaningful on a nullable column, hence [Column.nullable].
  Expr get isNull => Expr('$sql IS NULL', const []);

  /// The same column, typed as nullable.
  Column<T?> get nullable => Column<T?>(table, name);

  @override
  bool operator ==(Object other) =>
      other is Column<T> && other.table == table && other.name == name;

  @override
  int get hashCode => Object.hash(table, name);

  @override
  String toString() => sql;
}

/// Comparisons that need an ordering: numbers, strings, dates as epoch millis.
///
/// Declared on `Column<T?>` so a nullable column still compares against a
/// non-null value, which is the only comparison that can ever match.
extension OrderedColumn<T extends Comparable<Object>> on Column<T?> {
  /// `<`
  Expr lt(T value) => Expr('$sql < ?', [value]);

  /// `<=`
  Expr lte(T value) => Expr('$sql <= ?', [value]);

  /// `>`
  Expr gt(T value) => Expr('$sql > ?', [value]);

  /// `>=`
  Expr gte(T value) => Expr('$sql >= ?', [value]);

  /// `BETWEEN`, inclusive on both ends.
  Expr between(T low, T high) => Expr('$sql BETWEEN ? AND ?', [low, high]);
}

/// String-only comparisons.
extension TextColumn on Column<String?> {
  /// `LIKE`. The caller supplies the wildcards, so `%` inside a value is not
  /// special — the value is always bound, never spliced into the statement.
  Expr like(String pattern) => Expr('$sql LIKE ?', [pattern]);

  /// `IN (...)`, with one bound parameter per element.
  Expr inList(Iterable<String> values) =>
      Expr('$sql IN (${_placeholders(values.length)})', values.toList());
}

/// A boolean SQL expression plus its bound values.
final class Expr {
  /// Creates an expression from a SQL fragment and its bindings.
  const Expr(this.sql, this.args);

  /// The SQL fragment, with `?` placeholders.
  final String sql;

  /// Values for the placeholders, in order.
  final List<Object?> args;

  /// `AND`, parenthesised so precedence never depends on the caller.
  Expr operator &(Expr other) =>
      Expr('($sql) AND (${other.sql})', [...args, ...other.args]);

  /// `OR`, parenthesised.
  Expr operator |(Expr other) =>
      Expr('($sql) OR (${other.sql})', [...args, ...other.args]);

  /// `NOT`.
  Expr operator ~() => Expr('NOT ($sql)', args);
}

String _placeholders(int count) => List<String>.filled(count, '?').join(', ');
