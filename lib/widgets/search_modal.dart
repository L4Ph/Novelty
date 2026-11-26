import 'dart:async';

import 'package:flutter/material.dart';
import 'package:novelty/models/novel_search_query.dart';
import 'package:novelty/sites/novel_site_registry.dart';
import 'package:novelty/sites/novel_source.dart';
import 'package:novelty/utils/app_constants.dart';
import 'package:novelty/widgets/sort_selection_sheet.dart';
import 'package:novelty/widgets/source_selector.dart';

/// 検索条件を指定するモーダルウィジェット
class SearchModal extends StatefulWidget {
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
  State<SearchModal> createState() => _SearchModalState();
}

class _SearchModalState extends State<SearchModal> {
  late NovelSearchQuery _query = widget.initialQuery;
  var _showAdvanced = false;
  late final TextEditingController _searchController = TextEditingController(
    text: _query.word,
  );
  late final TextEditingController _notWordController = TextEditingController(
    text: _query.notword,
  );

  @override
  void dispose() {
    _searchController.dispose();
    _notWordController.dispose();
    super.dispose();
  }

  void _setQuery(NovelSearchQuery query) => setState(() => _query = query);

  @override
  Widget build(BuildContext context) {
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
                    selected: _query.source,
                    onChanged: (source) {
                      if (source == null) {
                        return;
                      }
                      final isNarou = source == NovelSource.narou;
                      _setQuery(
                        _query.copyWith(
                          source: source,
                          // Drop narou-specific conditions when the site changes.
                          title: isNarou && _query.title,
                          ex: isNarou && _query.ex,
                          keyword: isNarou && _query.keyword,
                          wname: isNarou && _query.wname,
                          genreId: isNarou ? _query.genreId : null,
                          type: isNarou ? _query.type : null,
                          order: isNarou ? _query.order : 'new',
                          // Drop kakuyomu-specific conditions too.
                          serialStatus: isNarou ? null : _query.serialStatus,
                          totalCharacterCountRange: isNarou
                              ? null
                              : _query.totalCharacterCountRange,
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 24),

                  // キーワード
                  TextField(
                    controller: _searchController,

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
                      _setQuery(_query.copyWith(word: text));
                    },
                    onSubmitted: (_) => widget.onSearch(_query),
                  ),
                  const SizedBox(height: 16),

                  // なろう固有の詳細検索条件（カクヨムでは非表示）
                  if (_query.source == NovelSource.narou) ...[
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
                          selected: _query.title,
                          onSelected: (selected) {
                            _setQuery(_query.copyWith(title: selected));
                          },
                        ),
                        FilterChip(
                          label: const Text('あらすじ'),
                          selected: _query.ex,
                          onSelected: (selected) {
                            _setQuery(_query.copyWith(ex: selected));
                          },
                        ),
                        FilterChip(
                          label: const Text('キーワード'),
                          selected: _query.keyword,
                          onSelected: (selected) {
                            _setQuery(
                              _query.copyWith(
                                keyword: selected,
                              ),
                            );
                          },
                        ),
                        FilterChip(
                          label: const Text('作者名'),
                          selected: _query.wname,
                          onSelected: (selected) {
                            _setQuery(_query.copyWith(wname: selected));
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
                                _query.genreId?.firstOrNull,
                          )
                          ? int.tryParse(_query.genreId?.firstOrNull ?? '')
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
                        _setQuery(
                          _query.copyWith(
                            genreId: value == null ? null : [value.toString()],
                          ),
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
                          selected: _query.type == null,
                          onSelected: (selected) {
                            if (selected) {
                              _setQuery(_query.copyWith(type: null));
                            }
                          },
                        ),
                        ...novelTypes.entries.map((entry) {
                          return ChoiceChip(
                            label: Text(entry.value),
                            selected: _query.type == entry.key,
                            onSelected: (selected) {
                              if (selected) {
                                _setQuery(
                                  _query.copyWith(
                                    type: entry.key,
                                  ),
                                );
                              } else if (_query.type == entry.key) {
                                // 任意: 選択解除で「すべて」に戻る
                                _setQuery(_query.copyWith(type: null));
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
                                currentOrder: _query.order,
                                onOrderSelected: (newOrder) {
                                  _setQuery(
                                    _query.copyWith(
                                      order: newOrder,
                                    ),
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
                                novelOrders[_query.order] ?? _query.order,
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
                      initiallyExpanded: _showAdvanced,
                      onExpansionChanged: (expanded) =>
                          _showAdvanced = expanded,
                      children: [
                        const SizedBox(height: 8),
                        TextField(
                          controller: _notWordController,

                          decoration: InputDecoration(
                            labelText: '除外キーワード',
                            hintText: 'スペース区切りで入力',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            filled: true,
                          ),
                          onChanged: (text) {
                            _setQuery(_query.copyWith(notword: text));
                          },
                        ),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ], // なろう固有の詳細検索条件ここまで
                  // カクヨム固有の検索条件（なろうでは非表示）
                  if (_query.source == NovelSource.kakuyomu) ...[
                    Text(
                      'ジャンル',
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<String?>(
                      key: const Key('kakuyomu_genre'),
                      menuMaxHeight: MediaQuery.of(context).size.height * 0.5,
                      initialValue: _query.genreId?.firstOrNull,
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
                        ...defaultNovelSiteRegistry[NovelSource.kakuyomu]!
                            .genres
                            .map(
                              (g) => DropdownMenuItem(
                                value: g.id,
                                child: Text(g.name),
                              ),
                            ),
                      ],
                      onChanged: (value) {
                        _setQuery(
                          _query.copyWith(
                            genreId: value == null ? null : [value],
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 16),
                    Text(
                      '連載状態',
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<String?>(
                      key: const Key('kakuyomu_serial_status'),
                      initialValue: _query.serialStatus,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                      ),
                      items: const [
                        DropdownMenuItem(
                          child: Text('指定なし'),
                        ),
                        DropdownMenuItem(
                          value: 'running',
                          child: Text('連載中'),
                        ),
                        DropdownMenuItem(
                          value: 'completed',
                          child: Text('完結'),
                        ),
                      ],
                      onChanged: (value) {
                        _setQuery(
                          _query.copyWith(
                            serialStatus: value,
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 16),
                    Text(
                      '文字数',
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<String?>(
                      key: const Key('kakuyomu_char_count_range'),
                      initialValue: _query.totalCharacterCountRange,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                      ),
                      items: const [
                        DropdownMenuItem(
                          child: Text('指定なし'),
                        ),
                        DropdownMenuItem(
                          value: '-20000',
                          child: Text('〜2万字'),
                        ),
                        DropdownMenuItem(
                          value: '20000-100000',
                          child: Text('2万〜10万字'),
                        ),
                        DropdownMenuItem(
                          value: '100000-',
                          child: Text('10万字〜'),
                        ),
                        DropdownMenuItem(
                          value: '500000-',
                          child: Text('50万字〜'),
                        ),
                      ],
                      onChanged: (value) {
                        _setQuery(
                          _query.copyWith(
                            totalCharacterCountRange: value,
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 24),
                  ], // カクヨム固有の検索条件ここまで
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
                  key: const Key('search_button'),
                  onPressed: () => widget.onSearch(_query),
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
