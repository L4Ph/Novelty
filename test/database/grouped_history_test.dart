import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:novelty/database/database.dart';
import 'package:novelty/sites/novel_source.dart';

@GenerateMocks([AppDatabase])
import 'grouped_history_test.mocks.dart';

void main() {
  late MockAppDatabase db;
  final fixedTime = DateTime(2024, 1, 15, 12);

  setUp(() => db = MockAppDatabase());

  HistoryData at(String workId, Duration ago) => HistoryData(
    source: NovelSource.narou,
    workId: workId,
    title: workId,
    writer: 'author',
    lastEpisode: 1,
    viewedAt: fixedTime.subtract(ago).millisecondsSinceEpoch,
    updatedAt: fixedTime.subtract(ago).millisecondsSinceEpoch,
  );

  group('watchGroupedHistory', () {
    test('groups by date label, newest first', () async {
      when(db.watchHistory()).thenAnswer(
        (_) => Stream.value(<HistoryData>[
          at('today1', Duration.zero),
          at('today2', const Duration(hours: 2)),
          at('yesterday1', const Duration(days: 1)),
          at('old1', const Duration(days: 10)),
        ]),
      );

      final groups = await watchGroupedHistory(db, fixedTime).first;

      expect(groups, hasLength(3));
      expect(groups[0].dateLabel, '今日');
      expect(
        groups[0].items.map((i) => i.workId),
        equals(<String>['today1', 'today2']),
      );
      expect(groups[1].dateLabel, '1日前');
      expect(groups[1].items.single.workId, equals('yesterday1'));
      expect(groups[2].dateLabel, '2024年1月5日');
      verify(db.watchHistory()).called(1);
    });

    test('returns an empty list when there is no history', () async {
      when(db.watchHistory()).thenAnswer((_) => Stream.value(<HistoryData>[]));

      expect(await watchGroupedHistory(db, fixedTime).first, isEmpty);
    });

    test('propagates a database error', () async {
      when(db.watchHistory()).thenAnswer(
        (_) => Stream<List<HistoryData>>.error(Exception('Database error')),
      );

      await expectLater(
        watchGroupedHistory(db, fixedTime).first,
        throwsA(isA<Exception>()),
      );
    });
  });
}
