import 'package:flutter/material.dart';

/// ライブラリから外すときに選べる操作。
enum RemoveFromLibraryAction {
  /// 何もせずダイアログを閉じる。
  cancel,

  /// ダウンロード済みの話を残したままライブラリから外す。
  keepDownloads,

  /// ダウンロード済みの話も削除してライブラリから外す。
  deleteDownloads,
}

/// ライブラリから外す確認ダイアログを表示する。
///
/// ダウンロード済みの話を残すか、削除するかを選ばせる。
/// ダイアログの外側をタップして閉じた場合は null を返す。
Future<RemoveFromLibraryAction?> showRemoveFromLibraryDialog(
  BuildContext context, {
  required String novelTitle,
}) {
  return showDialog<RemoveFromLibraryAction>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('ライブラリから削除'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('"$novelTitle"をライブラリから削除しますか？'),
          const SizedBox(height: 16),
          const Text('ダウンロード済みの話も削除しますか？'),
          const SizedBox(height: 8),
          Text(
            'ダウンロードした本文は元に戻せません。',
            style: TextStyle(color: Theme.of(context).colorScheme.error),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () =>
              Navigator.of(context).pop(RemoveFromLibraryAction.cancel),
          child: const Text('キャンセル'),
        ),
        FilledButton(
          onPressed: () =>
              Navigator.of(context).pop(RemoveFromLibraryAction.keepDownloads),
          child: const Text('ライブラリからのみ外す'),
        ),
        TextButton(
          onPressed: () => Navigator.of(
            context,
          ).pop(RemoveFromLibraryAction.deleteDownloads),
          style: TextButton.styleFrom(
            foregroundColor: Theme.of(context).colorScheme.error,
          ),
          child: const Text('ダウンロードも削除'),
        ),
      ],
    ),
  );
}
