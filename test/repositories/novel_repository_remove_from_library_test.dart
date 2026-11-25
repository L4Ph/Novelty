import 'package:drift/drift.dart' show Value;
import 'package:flutter_test/flutter_test.dart';
import 'package:narou_parser/narou_parser.dart';
import 'package:novelty/database/database.dart';
import 'package:novelty/models/novel_info.dart';
import 'package:novelty/repositories/novel_repository.dart';
import 'package:novelty/repositories/preferences_repository.dart';
import 'package:novelty/services/api_service.dart';
import 'package:novelty/sites/novel_source.dart';
import 'package:novelty/utils/settings_provider.dart';
import 'package:tiny_state/tiny_state.dart';

import '../support/test_services.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('NovelRepository.removeFromLibrary', () {
    late AppDatabase database;
    late NovelRepository repository;

    const workId = 'n1234ab';
    const otherWorkId = 'n5678cd';
    const kakuyomuWorkId = 'work-1';

    setUp(() async {
      database = AppDatabase.memory();
      repository = NovelRepository(
        apiService: ApiService(),
        settings: SettingsController(
          PreferencesRepository(),
          initialState: const AsyncData(testSettings),
        ),
        db: database,
      );

      await database.insertNovel(
        const NovelInfo(ncode: workId, title: 'テスト作品').toDbCompanion(),
      );
      await database.addToLibrary(NovelSource.narou, workId);
      await database.updateEpisodeContent(
        source: NovelSource.narou,
        workId: workId,
        episodeId: 1,
        content: [const NovelContentElement.plainText('ダウンロード済みの本文')],
        fetchedAt: 1234567890,
        subtitle: '第1話',
      );
      await database.addToHistory(
        const ReadingHistoryCompanion(
          source: Value(NovelSource.narou),
          workId: Value(workId),
          lastEpisodeId: Value(1),
        ),
      );

      // 削除対象外の作品（別作品・別サイト）の本文が巻き添えにならないこと
      await database.insertNovel(
        const NovelInfo(ncode: otherWorkId, title: '別作品').toDbCompanion(),
      );
      await database.updateEpisodeContent(
        source: NovelSource.narou,
        workId: otherWorkId,
        episodeId: 1,
        content: [const NovelContentElement.plainText('別作品の本文')],
        fetchedAt: 1234567890,
      );
      await database.insertNovel(
        const NovelInfo(
          source: NovelSource.kakuyomu,
          workId: kakuyomuWorkId,
          title: 'カクヨム作品',
        ).toDbCompanion(),
      );
      await database.updateEpisodeContent(
        source: NovelSource.kakuyomu,
        workId: kakuyomuWorkId,
        episodeId: 1,
        content: [const NovelContentElement.plainText('カクヨム作品の本文')],
        fetchedAt: 1234567890,
      );
    });

    tearDown(() async {
      repository.dispose();
      await database.close();
    });

    test('ダウンロード済みの話を残したままライブラリから外せる', () async {
      await repository.removeFromLibrary(NovelSource.narou, workId);

      expect(await database.isInLibrary(NovelSource.narou, workId), isFalse);

      final episode = await database.getEpisodeData(
        NovelSource.narou,
        workId,
        1,
      );
      expect(episode, isNotNull);
      expect(episode!.content, isNotNull);
    });

    test('ダウンロード済みの話も削除してライブラリから外せる', () async {
      await repository.removeFromLibrary(
        NovelSource.narou,
        workId,
        deleteDownloads: true,
      );

      expect(await database.isInLibrary(NovelSource.narou, workId), isFalse);

      // 本文は削除されるが、目次（サブタイトル）は残る
      final episode = await database.getEpisodeData(
        NovelSource.narou,
        workId,
        1,
      );
      expect(episode, isNotNull);
      expect(episode!.content, isNull);
      expect(episode.subtitle, '第1話');

      // 作品情報と閲覧履歴は残る
      expect(await database.getNovel(NovelSource.narou, workId), isNotNull);
      final history = await database.select(database.readingHistory).get();
      expect(history.where((row) => row.workId == workId), hasLength(1));

      // 削除対象外の作品の本文は残る
      final otherNovelEpisode = await database.getEpisodeData(
        NovelSource.narou,
        otherWorkId,
        1,
      );
      expect(otherNovelEpisode!.content, isNotNull);
      final otherSiteEpisode = await database.getEpisodeData(
        NovelSource.kakuyomu,
        kakuyomuWorkId,
        1,
      );
      expect(otherSiteEpisode!.content, isNotNull);
    });
  });
}
