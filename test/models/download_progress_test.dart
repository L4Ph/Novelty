import 'package:flutter_test/flutter_test.dart';
import 'package:novelty/models/download_progress.dart';
import 'package:novelty/utils/value_wrapper.dart';

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

    group('手書きクラス移行後のテスト', () {
      test('copyWithでフィールドを変更できる', () {
        const progress = DownloadProgress(
          currentEpisode: 5,
          totalEpisodes: 10,
          isDownloading: true,
        );

        final updated = progress.copyWith(
          currentEpisode: 8,
          isDownloading: false,
        );

        expect(updated.currentEpisode, equals(8));
        expect(updated.totalEpisodes, equals(10));
        expect(updated.isDownloading, isFalse);
        expect(updated.errorMessage, isNull);
      });

      test('copyWithでerrorMessageを設定できる', () {
        const progress = DownloadProgress(
          currentEpisode: 5,
          totalEpisodes: 10,
          isDownloading: true,
        );

        // errorMessageを設定
        final withError = progress.copyWith(
          errorMessage: const Value('Network error'),
        );
        expect(withError.errorMessage, equals('Network error'));
      });

      test('copyWithでerrorMessageをnullに設定できる', () {
        const progress = DownloadProgress(
          currentEpisode: 5,
          totalEpisodes: 10,
          isDownloading: false,
          errorMessage: 'Network error',
        );

        final cleared = progress.copyWith(
          errorMessage: const Value<String?>(null),
        );
        expect(cleared.errorMessage, isNull);
        expect(cleared.currentEpisode, equals(5)); // 変更されていない
      });

      test('同じ値を持つインスタンスは等価', () {
        const progress1 = DownloadProgress(
          currentEpisode: 5,
          totalEpisodes: 10,
          isDownloading: true,
          errorMessage: 'error',
        );
        const progress2 = DownloadProgress(
          currentEpisode: 5,
          totalEpisodes: 10,
          isDownloading: true,
          errorMessage: 'error',
        );

        expect(progress1, equals(progress2));
        expect(progress1.hashCode, equals(progress2.hashCode));
      });

      test('異なる値を持つインスタンスは非等価', () {
        const progress1 = DownloadProgress(
          currentEpisode: 5,
          totalEpisodes: 10,
          isDownloading: true,
        );
        const progress2 = DownloadProgress(
          currentEpisode: 6,
          totalEpisodes: 10,
          isDownloading: true,
        );

        expect(progress1, isNot(equals(progress2)));
      });

      test('toStringが正しい形式を返す', () {
        const progress = DownloadProgress(
          currentEpisode: 5,
          totalEpisodes: 10,
          isDownloading: true,
          errorMessage: 'error',
        );

        expect(
          progress.toString(),
          'DownloadProgress(currentEpisode: 5, totalEpisodes: 10, isDownloading: true, errorMessage: error)',
        );
      });
    });
  });
}
