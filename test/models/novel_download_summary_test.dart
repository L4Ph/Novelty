import 'package:flutter_test/flutter_test.dart';
import 'package:novelty/models/novel_download_summary.dart';

void main() {
  group('NovelDownloadSummary', () {
    test('コンストラクタでフィールドが正しく初期化される', () {
      const summary = NovelDownloadSummary(
        ncode: 'n1234',
        successCount: 5,
        failureCount: 1,
        totalEpisodes: 10,
      );

      expect(summary.ncode, equals('n1234'));
      expect(summary.successCount, equals(5));
      expect(summary.failureCount, equals(1));
      expect(summary.totalEpisodes, equals(10));
    });

    test('copyWithでフィールドを変更できる', () {
      const summary = NovelDownloadSummary(
        ncode: 'n1234',
        successCount: 5,
        failureCount: 1,
        totalEpisodes: 10,
      );

      final updated = summary.copyWith(
        successCount: 8,
        failureCount: 0,
      );

      expect(updated.ncode, equals('n1234'));
      expect(updated.successCount, equals(8));
      expect(updated.failureCount, equals(0));
      expect(updated.totalEpisodes, equals(10));
    });

    test('isCompleteゲッターが正しく動作する', () {
      // 完了状態
      const summary1 = NovelDownloadSummary(
        ncode: 'n1234',
        successCount: 10,
        failureCount: 0,
        totalEpisodes: 10,
      );
      expect(summary1.isComplete, isTrue);

      // 未完了（一部成功）
      const summary2 = NovelDownloadSummary(
        ncode: 'n1234',
        successCount: 5,
        failureCount: 0,
        totalEpisodes: 10,
      );
      expect(summary2.isComplete, isFalse);

      // totalEpisodesが0の場合
      const summary3 = NovelDownloadSummary(
        ncode: 'n1234',
        successCount: 0,
        failureCount: 0,
        totalEpisodes: 0,
      );
      expect(summary3.isComplete, isFalse);
    });

    test('isDownloadingゲッターが正しく動作する', () {
      // ダウンロード中（一部成功）
      const summary1 = NovelDownloadSummary(
        ncode: 'n1234',
        successCount: 5,
        failureCount: 0,
        totalEpisodes: 10,
      );
      expect(summary1.isDownloading, isTrue);

      // ダウンロード中（一部失敗）
      const summary2 = NovelDownloadSummary(
        ncode: 'n1234',
        successCount: 0,
        failureCount: 3,
        totalEpisodes: 10,
      );
      expect(summary2.isDownloading, isTrue);

      // 完了（ダウンロード中ではない）
      const summary3 = NovelDownloadSummary(
        ncode: 'n1234',
        successCount: 10,
        failureCount: 0,
        totalEpisodes: 10,
      );
      expect(summary3.isDownloading, isFalse);

      // 未ダウンロード
      const summary4 = NovelDownloadSummary(
        ncode: 'n1234',
        successCount: 0,
        failureCount: 0,
        totalEpisodes: 10,
      );
      expect(summary4.isDownloading, isFalse);
    });

    test('downloadStatusゲッターが正しく動作する', () {
      // 未ダウンロード (0)
      const summary0 = NovelDownloadSummary(
        ncode: 'n1234',
        successCount: 0,
        failureCount: 0,
        totalEpisodes: 10,
      );
      expect(summary0.downloadStatus, equals(0));

      // ダウンロード中 (1)
      const summary1 = NovelDownloadSummary(
        ncode: 'n1234',
        successCount: 5,
        failureCount: 0,
        totalEpisodes: 10,
      );
      expect(summary1.downloadStatus, equals(1));

      // 完了 (2)
      const summary2 = NovelDownloadSummary(
        ncode: 'n1234',
        successCount: 10,
        failureCount: 0,
        totalEpisodes: 10,
      );
      expect(summary2.downloadStatus, equals(2));

      // 一部失敗 (3)
      const summary3 = NovelDownloadSummary(
        ncode: 'n1234',
        successCount: 8,
        failureCount: 2,
        totalEpisodes: 10,
      );
      expect(summary3.downloadStatus, equals(3));
    });

    test('downloadedEpisodesゲッターがsuccessCountを返す', () {
      const summary = NovelDownloadSummary(
        ncode: 'n1234',
        successCount: 7,
        failureCount: 1,
        totalEpisodes: 10,
      );
      expect(summary.downloadedEpisodes, equals(7));
    });

    test('同じ値を持つインスタンスは等価', () {
      const summary1 = NovelDownloadSummary(
        ncode: 'n1234',
        successCount: 5,
        failureCount: 1,
        totalEpisodes: 10,
      );
      const summary2 = NovelDownloadSummary(
        ncode: 'n1234',
        successCount: 5,
        failureCount: 1,
        totalEpisodes: 10,
      );

      expect(summary1, equals(summary2));
      expect(summary1.hashCode, equals(summary2.hashCode));
    });

    test('異なる値を持つインスタンスは非等価', () {
      const summary1 = NovelDownloadSummary(
        ncode: 'n1234',
        successCount: 5,
        failureCount: 1,
        totalEpisodes: 10,
      );
      const summary2 = NovelDownloadSummary(
        ncode: 'n1234',
        successCount: 6,
        failureCount: 1,
        totalEpisodes: 10,
      );

      expect(summary1, isNot(equals(summary2)));
    });

    test('toStringが正しい形式を返す', () {
      const summary = NovelDownloadSummary(
        ncode: 'n1234',
        successCount: 5,
        failureCount: 1,
        totalEpisodes: 10,
      );

      expect(
        summary.toString(),
        'NovelDownloadSummary(ncode: n1234, successCount: 5, failureCount: 1, totalEpisodes: 10)',
      );
    });
  });
}
