import 'package:flutter/material.dart';

/// DBを停止して行う保守操作(インポート/エクスポート)の実行中に、
/// アプリ全体を覆って表示するブロッキング画面。
///
/// 長時間かかる処理中にユーザーが誤って操作を続けないよう、
/// 実行中の操作名を明示する。
class DatabaseMaintenanceScreen extends StatelessWidget {
  /// コンストラクタ
  const DatabaseMaintenanceScreen({required this.operationLabel, super.key});

  /// ユーザー向けの操作説明(例: 「データベースをインポートしています…」)
  final String operationLabel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircularProgressIndicator(),
              const SizedBox(height: 24),
              Text(
                operationLabel,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              const Text(
                '時間がかかる場合がありますが、画面を閉じずにお待ちください。',
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
