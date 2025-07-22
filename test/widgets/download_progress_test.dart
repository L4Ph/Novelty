import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:novelty/models/download_progress.dart';

/// ダウンロード進捗表示のテスト用ウィジェット
class DownloadProgressTestWidget extends StatelessWidget {
  /// コンストラクタ
  const DownloadProgressTestWidget({
    required this.progress,
    super.key,
  });

  /// ダウンロード進捗
  final DownloadProgress? progress;

  @override
  Widget build(BuildContext context) {
    if (progress != null && progress!.isDownloading) {
      return Column(
        children: [
          SizedBox(
            width: 28,
            height: 28,
            child: CircularProgressIndicator(
              value: progress!.progress,
              strokeWidth: 3,
            ),
          ),
          const SizedBox(height: 4),
          const Text('ダウンロード中'),
        ],
      );
    }

    if (progress != null && progress!.hasError) {
      return const Column(
        children: [
          Icon(Icons.error),
          SizedBox(height: 4),
          Text('エラー'),
        ],
      );
    }

    return const Column(
      children: [
        Icon(Icons.download_for_offline_outlined),
        SizedBox(height: 4),
        Text('ダウンロード'),
      ],
    );
  }
}

void main() {
  group('ダウンロード進捗UI', () {
    testWidgets('ダウンロード中は円形プログレスを表示すること', (WidgetTester tester) async {
      const progress = DownloadProgress(
        currentEpisode: 3,
        totalEpisodes: 10,
        isDownloading: true,
      );

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: DownloadProgressTestWidget(progress: progress),
          ),
        ),
      );

      // CircularProgressIndicatorが表示されていることを確認
      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      // プログレスの値が正しいことを確認
      final progressIndicator = tester.widget<CircularProgressIndicator>(
        find.byType(CircularProgressIndicator),
      );
      expect(progressIndicator.value, equals(0.3));

      // 「ダウンロード中」テキストが表示されていることを確認
      expect(find.text('ダウンロード中'), findsOneWidget);
    });

    testWidgets('エラー時はエラーアイコンを表示すること', (WidgetTester tester) async {
      const progress = DownloadProgress(
        currentEpisode: 0,
        totalEpisodes: 10,
        isDownloading: false,
        errorMessage: 'Download failed',
      );

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: DownloadProgressTestWidget(progress: progress),
          ),
        ),
      );

      // エラーアイコンが表示されていることを確認
      expect(find.byIcon(Icons.error), findsOneWidget);
      expect(find.text('エラー'), findsOneWidget);
    });

    testWidgets('通常状態ではダウンロードアイコンを表示すること', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: DownloadProgressTestWidget(progress: null),
          ),
        ),
      );

      // ダウンロードアイコンが表示されていることを確認
      expect(find.byIcon(Icons.download_for_offline_outlined), findsOneWidget);
      expect(find.text('ダウンロード'), findsOneWidget);
    });

    testWidgets('短編小説のダウンロード完了状態を正しく表示すること', (WidgetTester tester) async {
      const progress = DownloadProgress(
        currentEpisode: 1,
        totalEpisodes: 1,
        isDownloading: false,
      );

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: DownloadProgressTestWidget(progress: progress),
          ),
        ),
      );

      // ダウンロード完了なので通常のアイコンが表示される
      expect(find.byIcon(Icons.download_for_offline_outlined), findsOneWidget);
      expect(find.text('ダウンロード'), findsOneWidget);
    });
  });
}
