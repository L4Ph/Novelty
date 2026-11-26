// Examples that must NOT compile. Uncommenting any line breaks the build.
//
//   novels.title.eq(1)          -> int is not String?
//   novels.noSuchColumn.eq(1)   -> no getter
//   novels.cachedAt.like('x')   -> like is on Column<String?>
//
// `dart analyze` is the assertion; nothing runs.
