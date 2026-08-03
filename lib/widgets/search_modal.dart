import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:novelty/models/novel_search_query.dart';
import 'package:novelty/sites/novel_source.dart';
import 'package:novelty/utils/app_constants.dart';
import 'package:novelty/widgets/sort_selection_sheet.dart';
import 'package:novelty/widgets/source_selector.dart';

/// 検索条件を指定するモーダルウィジェット
class SearchModal extends HookConsumerWidget {
  /// コンストラクタ
  const SearchModal({
    required this.initialQuery,
    required this.onSearch,
    super.key,
  });

  /// 前回の検索条件
  final NovelSearchQuery initialQuery;

  /// 検索実行時のコールバック
  final ValueChanged<NovelSearchQuery> onSearch;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final query = useState(initialQuery);
    final showAdvanced = useState(false);
    final searchController = useTextEditingController(text: query.value.word);
    final notWordController = useTextEditingController(
      text: query.value.notword,
    );

    return DraggableScrollableSheet(
      initialChildSize: 0.9,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      expand: false,
      builder: (context, scrollController) {
        return Column(
          children: [
            // シートのハンドル
            const SizedBox(height: 12),
            Container(
              width: 32,
              height: 4,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.outlineVariant,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 12),

            Expanded(
              child: ListView(
                controller: scrollController,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  Text(
                    '検索条件',
                    style: Theme.of(context).textTheme.headlineSmall,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),

                  // プロバイダ切替
                  SourceSelector(
                    sources: NovelSource.values,
                    selected: query.value.source,
                    onChanged: (source) {
                      if (source == null) {
                        return;
                      }
                      final isNarou = source == NovelSource.narou;
                      query.value = query.value.copyWith(
                        source: source,
                        // サイト切替時はなろう固有の詳細条件をリセットする
                        title: isNarou && query.value.title,
                        ex: isNarou && query.value.ex,
                        keyword: isNarou && query.value.keyword,
                        wname: isNarou && query.value.wname,
                        genreId: isNarou ? query.value.genreId : null,
                        type: isNarou ? query.value.type : null,
                        order: isNarou ? query.value.order : 'new',
                      );
                    },
                  ),
                  const SizedBox(height: 24),

                  // キーワード
                  TextField(
                    controller: searchController,

                    decoration: InputDecoration(
                      labelText: '検索キーワード',
                      hintText: 'タイトル、作者名など',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      filled: true,
                    ),
                    textInputAction: TextInputAction.search,
                    onChanged: (text) {
                      query.value = query.value.copyWith(word: text);
                    },
                    onSubmitted: (_) => onSearch(query.value),
                  ),
                  const SizedBox(height: 16),

                  // なろう固有の詳細検索条件（カクヨムでは非表示）
                  if (query.value.source == NovelSource.narou) ...[
                    // 検索対象（チップ）
                    Text(
                      '検索対象',
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        FilterChip(
                          label: const Text('タイトル'),
                          selected: query.value.title,
                          onSelected: (selected) {
                            query.value = query.value.copyWith(title: selected);
                          },
                        ),
                        FilterChip(
                          label: const Text('あらすじ'),
                          selected: query.value.ex,
                          onSelected: (selected) {
                            query.value = query.value.copyWith(ex: selected);
                          },
                        ),
                        FilterChip(
                          label: const Text('キーワード'),
                          selected: query.value.keyword,
                          onSelected: (selected) {
                            query.value = query.value.copyWith(
                              keyword: selected,
                            );
                          },
                        ),
                        FilterChip(
                          label: const Text('作者名'),
                          selected: query.value.wname,
                          onSelected: (selected) {
                            query.value = query.value.copyWith(wname: selected);
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // ジャンル
                    Text(
                      'ジャンル',
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<int?>(
                      menuMaxHeight: MediaQuery.of(context).size.height * 0.5,
                      initialValue:
                          genreList.any(
                            (g) =>
                                g['id'].toString() ==
                                query.value.genreId?.firstOrNull,
                          )
                          ? int.tryParse(query.value.genreId?.firstOrNull ?? '')
                          : null,
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
                        const DropdownMenuItem(
                          child: Text('指定なし'),
                        ),
                        ...genreList.map(
                          (g) => DropdownMenuItem(
                            value: g['id'] as int,
                            child: Text(g['name'] as String),
                          ),
                        ),
                      ],
                      onChanged: (value) {
                        query.value = query.value.copyWith(
                          genreId: value == null ? null : [value.toString()],
                        );
                      },
                    ),
                    const SizedBox(height: 24),

                    // 種別
                    Text(
                      '種別',
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      children: [
                        ChoiceChip(
                          label: const Text('すべて'),
                          selected: query.value.type == null,
                          onSelected: (selected) {
                            if (selected) {
                              query.value = query.value.copyWith(type: null);
                            }
                          },
                        ),
                        ...novelTypes.entries.map((entry) {
                          return ChoiceChip(
                            label: Text(entry.value),
                            selected: query.value.type == entry.key,
                            onSelected: (selected) {
                              if (selected) {
                                query.value = query.value.copyWith(
                                  type: entry.key,
                                );
                              } else if (query.value.type == entry.key) {
                                // 任意: 選択解除で「すべて」に戻る
                                query.value = query.value.copyWith(type: null);
                              }
                            },
                          );
                        }),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // 並び順
                    Text(
                      '並び順',
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    const SizedBox(height: 8),
                    InputDecorator(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                      ),
                      child: InkWell(
                        onTap: () {
                          unawaited(
                            showModalBottomSheet<void>(
                              context: context,
                              isScrollControlled: true,
                              useSafeArea: true,
                              builder: (context) => SortSelectionSheet(
                                currentOrder: query.value.order,
                                onOrderSelected: (newOrder) {
                                  query.value = query.value.copyWith(
                                    order: newOrder,
                                  );
                                  Navigator.pop(context);
                                },
                              ),
                            ),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                novelOrders[query.value.order] ??
                                    query.value.order,
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                              const Icon(Icons.arrow_drop_down),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // 詳細設定
                    ExpansionTile(
                      title: const Text('詳細設定'),
                      initiallyExpanded: showAdvanced.value,
                      onExpansionChanged: (expanded) =>
                          showAdvanced.value = expanded,
                      children: [
                        const SizedBox(height: 8),
                        TextField(
                          controller: notWordController,

                          decoration: InputDecoration(
                            labelText: '除外キーワード',
                            hintText: 'スペース区切りで入力',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            filled: true,
                          ),
                          onChanged: (text) {
                            query.value = query.value.copyWith(notword: text);
                          },
                        ),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ], // なろう固有の詳細検索条件ここまで
                  // 通常 Scaffold の SafeArea が余白を確保するが、念のため
                  // to have some padding at bottom of scroll
                  const SizedBox(height: 100),
                ],
              ),
            ),

            // 固定検索ボタン
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: FilledButton.icon(
                  onPressed: () => onSearch(query.value),
                  icon: const Icon(Icons.search),
                  label: const Text('検索する'),
                  style: FilledButton.styleFrom(
                    minimumSize: const Size.fromHeight(56),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
