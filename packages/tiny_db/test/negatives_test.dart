// The point of the column descriptors is that the wrong code does not compile.
// These snippets are checked by `dart analyze` in review, not at runtime:
//
//   novels.title.eq(1)            // int where String? is declared
//   novels.noSuchColumn.eq(1)     // typo: no such getter
//   novels.cachedAt.like('x')     // like() only exists on Column<String?>
//   insert.set(novels.cachedAt, 'x')  // String where int? is declared
//
// To confirm, copy one into tiny_db_test.dart and run `dart analyze`.
