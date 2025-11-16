import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:novelty/models/ranking_response.dart';
import 'package:novelty/repositories/novel_repository.dart';

/// ライブラリ追加コールバックの型定義
typedef AddToLibraryCallback = Future<void> Function(RankingResponse item);

/// ライブラリ追加処理を実行する関数
///
/// NovelListとEnrichedNovelListで共通のロジックを提供する。
Future<void> handleAddToLibrary({
  required RankingResponse item,
  required BuildContext context,
  required WidgetRef ref,
  required ValueNotifier<Map<String, bool>> isProcessingMap,
  required ValueNotifier<String?> errorMessage,
}) async {
  final ncode = item.ncode;
  if (isProcessingMap.value[ncode] ?? false) {
    return; // 処理中の場合は何もしない
  }

  // エラーメッセージをクリア
  errorMessage.value = null;
  if (!context.mounted) return;
  ScaffoldMessenger.of(context).hideCurrentSnackBar();

  try {
    // 処理開始をマーク
    isProcessingMap.value = {...isProcessingMap.value, ncode: true};

    final repository = ref.read(novelRepositoryProvider);
    final added = await repository.addNovelToLibrary(item.ncode);

    if (!added) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('すでにライブラリに登録されています')),
        );
      }
      return;
    }

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('ライブラリに追加しました')),
      );
    }
  } on Exception catch (e) {
    errorMessage.value = 'エラー: $e';
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('エラー: $e')),
      );
    }
  } finally {
    // 処理完了をマーク
    isProcessingMap.value = {...isProcessingMap.value, ncode: false};
  }
}
