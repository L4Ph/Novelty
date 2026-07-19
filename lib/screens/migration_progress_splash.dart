import 'package:flutter/material.dart';

/// マイグレーション実行中に表示する進捗スプラッシュ画面。
/// 長時間かかる処理中にユーザーが誤ってアプリを終了しないよう、
/// 明示的なメッセージを表示する。
class MigrationProgressSplash extends StatelessWidget {
  /// コンストラクタ
  const MigrationProgressSplash({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 24),
              Text(
                '読書データを最新の状態に更新しています。',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 12),
              Text(
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
