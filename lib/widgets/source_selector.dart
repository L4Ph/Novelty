import 'package:flutter/material.dart';
import 'package:novelty/sites/novel_source.dart';

/// 小説提供サイトを選択するための共通ドロップダウンウィジェット。
///
/// 探索画面・ライブラリ画面・検索モーダルで共通利用する。
/// プロバイダ(サイト)が今後増えても、ドロップダウン形式のため
/// 画面幅を圧迫せず拡張できる。
class SourceSelector extends StatelessWidget {
  /// コンストラクタ。
  const SourceSelector({
    required this.sources,
    required this.selected,
    required this.onChanged,
    this.allLabel,
    super.key,
  });

  /// 選択肢として表示するサイト一覧。
  final List<NovelSource> sources;

  /// 現在選択中のサイト。
  ///
  /// [allLabel] 指定時は `null` を「すべて」の選択として扱える。
  final NovelSource? selected;

  /// 選択変更時のコールバック。
  ///
  /// 「すべて」が選択された場合は `null` が渡される。
  final ValueChanged<NovelSource?> onChanged;

  /// 「すべて」選択肢のラベル。
  ///
  /// 指定した場合のみ、先頭に「すべて」(値は `null`)の選択肢が追加される。
  final String? allLabel;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<NovelSource?>(
      key: const Key('source_selector'),
      initialValue: selected,
      isExpanded: true,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 8,
        ),
      ),
      items: [
        if (allLabel != null)
          DropdownMenuItem(
            child: Text(allLabel!),
          ),
        for (final source in sources)
          DropdownMenuItem(
            value: source,
            child: Text(source.label),
          ),
      ],
      onChanged: onChanged,
    );
  }
}
