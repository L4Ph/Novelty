import 'package:flutter/material.dart';
import 'package:novelty/sites/novel_source.dart';

/// AppBarタイトル部で利用するコンパクトなサイト切替ドロップダウン。
///
/// 探索画面・ライブラリ画面で共通利用する。
/// 選択中のサイト名と矢印（[Icons.arrow_drop_down]）を表示し、
/// ドロップダウンであることが一目で分かるようにする。
class AppBarSourceDropdown extends StatelessWidget {
  /// コンストラクタ。
  const AppBarSourceDropdown({
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
    return DropdownButtonHideUnderline(
      child: DropdownButton<NovelSource?>(
        key: const Key('app_bar_source_dropdown'),
        value: selected,
        isDense: true,
        icon: const Icon(Icons.arrow_drop_down),
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
      ),
    );
  }
}
