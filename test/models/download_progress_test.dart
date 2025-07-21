import 'package:flutter_test/flutter_test.dart';
import 'package:novelty/models/download_progress.dart';

void main() {
  group('DownloadProgress', () {
    test('進捗の割合計算が正しいこと', () {
      // 0/10の場合
      const progress1 = DownloadProgress(
        currentEpisode: 0,
        totalEpisodes: 10,
        isDownloading: true,
      );
      expect(progress1.progress, equals(0.0));

      // 5/10の場合
      const progress2 = DownloadProgress(
        currentEpisode: 5,
        totalEpisodes: 10,
        isDownloading: true,
      );
      expect(progress2.progress, equals(0.5));

      // 10/10の場合
      const progress3 = DownloadProgress(
        currentEpisode: 10,
        totalEpisodes: 10,
        isDownloading: false,
      );
      expect(progress3.progress, equals(1.0));
    });

    test('totalEpisodesが0の場合は0を返すこと', () {
      const progress = DownloadProgress(
        currentEpisode: 0,
        totalEpisodes: 0,
        isDownloading: false,
      );
      expect(progress.progress, equals(0.0));
    });

    test('ダウンロード完了状態が正しく判定されること', () {
      // ダウンロード中の場合
      const downloading = DownloadProgress(
        currentEpisode: 5,
        totalEpisodes: 10,
        isDownloading: true,
      );
      expect(downloading.isCompleted, isFalse);

      // ダウンロード完了の場合
      const completed = DownloadProgress(
        currentEpisode: 10,
        totalEpisodes: 10,
        isDownloading: false,
      );
      expect(completed.isCompleted, isTrue);

      // 全エピソードダウンロード済みだがまだダウンロード中の場合
      const stillDownloading = DownloadProgress(
        currentEpisode: 10,
        totalEpisodes: 10,
        isDownloading: true,
      );
      expect(stillDownloading.isCompleted, isFalse);
    });

    test('エラー状態が正しく判定されること', () {
      // エラーなしの場合
      const noError = DownloadProgress(
        currentEpisode: 0,
        totalEpisodes: 10,
        isDownloading: true,
      );
      expect(noError.hasError, isFalse);

      // エラーありの場合
      const withError = DownloadProgress(
        currentEpisode: 0,
        totalEpisodes: 10,
        isDownloading: false,
        errorMessage: 'Download failed',
      );
      expect(withError.hasError, isTrue);
    });

    test('短編小説のダウンロード進捗が正しいこと', () {
      // 短編小説の進捗
      const shortStoryProgress = DownloadProgress(
        currentEpisode: 1,
        totalEpisodes: 1,
        isDownloading: false,
      );
      expect(shortStoryProgress.progress, equals(1.0));
      expect(shortStoryProgress.isCompleted, isTrue);
    });
  });
}
