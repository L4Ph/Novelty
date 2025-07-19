import 'package:mockito/mockito.dart';
import 'package:novelty/database/database.dart';

class MockAppDatabase extends Mock implements AppDatabase {}

class MockNovelDao extends Mock implements NovelDao {}

class MockNovel extends Mock implements Novel {
  @override
  int? get fav => 1;

  @override
  String get ncode => 'n1234test';
}
