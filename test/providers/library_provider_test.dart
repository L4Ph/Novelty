import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:novelty/database/database.dart';
import 'package:novelty/sites/novel_source.dart';

@GenerateMocks([AppDatabase])
import 'library_provider_test.mocks.dart';

void main() {
  late MockAppDatabase mockDatabase;

  setUp(() => mockDatabase = MockAppDatabase());

  group('watchLibraryNovels', () {
    final testNovels = [
      Novel(
        source: NovelSource.narou,
        workId: 'n1234ab',
        title: 'テスト小説1',
        writer: 'テスト作者1',
        story: 'あらすじ1',
        novelType: 1,
        end: 0,
        generalAllNo: 10,
        cachedAt: DateTime.now().millisecondsSinceEpoch,
        isPrivate: false,
      ),
    ];

    test('returns the library stream of the given database', () async {
      when(
        mockDatabase.watchLibraryNovels(),
      ).thenAnswer((_) => Stream.fromIterable([testNovels]));

      expect(await watchLibraryNovels(mockDatabase).first, equals(testNovels));
      verify(mockDatabase.watchLibraryNovels()).called(1);
    });

    test('propagates database errors', () async {
      when(
        mockDatabase.watchLibraryNovels(),
      ).thenAnswer((_) => Stream.error(Exception('Database error')));

      await expectLater(
        watchLibraryNovels(mockDatabase).first,
        throwsA(isA<Exception>()),
      );
    });
  });
}
