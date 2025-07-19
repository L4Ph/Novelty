import 'package:drift/drift.dart' as drift;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:novelty/database/database.dart';

void main() {
  late AppDatabase database;

  setUp(() {
    database = AppDatabase.forTesting(NativeDatabase.memory());
  });

  tearDown(() async {
    await database.close();
  });

  test('search novels by title', () async {
    // Add novels to the library
    await database.novelDao.insertNovel(
      NovelsCompanion.insert(
        ncode: 'n0001',
        title: drift.Value('Test Novel 1'),
        fav: drift.Value(1),
      ),
    );
    await database.novelDao.insertNovel(
      NovelsCompanion.insert(
        ncode: 'n0002',
        title: drift.Value('Another Test Novel'),
        fav: drift.Value(1),
      ),
    );
    await database.novelDao.insertNovel(
      NovelsCompanion.insert(
        ncode: 'n0003',
        title: drift.Value('Something Else'),
        fav: drift.Value(0), // Not in library
      ),
    );

    // Search for "Test"
    final searchResultStream = database.novelDao.searchFavoriteNovels('Test');
    final searchResult = await searchResultStream.first;

    expect(searchResult.length, 2);
    expect(searchResult.any((novel) => novel.ncode == 'n0001'), isTrue);
    expect(searchResult.any((novel) => novel.ncode == 'n0002'), isTrue);

    // Search for "Another"
    final searchResultStream2 =
        database.novelDao.searchFavoriteNovels('Another');
    final searchResult2 = await searchResultStream2.first;

    expect(searchResult2.length, 1);
    expect(searchResult2.first.ncode, 'n0002');

    // Search for something that doesn't exist
    final searchResultStream3 =
        database.novelDao.searchFavoriteNovels('NonExistent');
    final searchResult3 = await searchResultStream3.first;

    expect(searchResult3.isEmpty, isTrue);

    // Empty query should return all favorite novels
    final searchResultStream4 = database.novelDao.searchFavoriteNovels('');
    final searchResult4 = await searchResultStream4.first;

    expect(searchResult4.length, 2);
  });
}
