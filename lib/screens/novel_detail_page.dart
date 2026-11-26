import 'dart:async';

import 'package:flutter/material.dart';
import 'package:novelty/app_services.dart';
import 'package:novelty/models/download_progress.dart';
import 'package:novelty/models/download_result.dart';
import 'package:novelty/models/episode.dart';
import 'package:novelty/models/novel_info.dart';
import 'package:novelty/router/app_router.dart';
import 'package:novelty/router/destinations.dart';
import 'package:novelty/sites/novel_source.dart';
import 'package:novelty/utils/async_subscription.dart';
import 'package:novelty/utils/clipboard_helper.dart';
import 'package:novelty/utils/work_url.dart';
import 'package:novelty/widgets/remove_from_library_dialog.dart';
import 'package:tiny_state/tiny_state.dart';

/// 小説の詳細ページ
class NovelDetailPage extends StatefulWidget {
  /// コンストラクタ
  const NovelDetailPage({
    required this.source,
    required this.workId,
    super.key,
  });

  /// 提供サイト（プロバイダ）。
  final NovelSource source;

  /// サイト共通の作品ID（なろうはNコード）。
  final String workId;

  @override
  State<NovelDetailPage> createState() => _NovelDetailPageState();
}

class _NovelDetailPageState extends State<NovelDetailPage> {
  int _currentPage = 1;

  final ScrollController _scrollController = ScrollController();
  bool _showTitle = false;

  var _bound = false;
  late final AsyncSubscription<NovelInfo> _novelInfo;
  late final AsyncSubscription<bool> _isInLibrary;
  late final AsyncSubscription<DownloadProgress?> _downloadProgress;
  late final AsyncSubscription<int?> _lastReadEpisode;

  /// Loaded table-of-contents pages, keyed by page number (1-based).
  final _episodePages = <int, Async<List<Episode>>>{};
  final _episodeSubscriptions = <int, StreamSubscription<List<Episode>>>{};

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_bound) return;
    _bound = true;

    final services = context.services;
    _novelInfo = AsyncSubscription(
      services.repository.watchNovelInfo(widget.source, widget.workId),
      onChanged: _rebuild,
      onError: (error) => _showSnackBar('ノベル情報の更新に失敗しました: $error'),
    );
    _isInLibrary = AsyncSubscription(
      services.db.watchIsInLibrary(widget.source, widget.workId),
      onChanged: _rebuild,
    );
    _downloadProgress = AsyncSubscription(
      services.repository.watchDownloadProgress(
        widget.source,
        widget.workId,
      ),
      onChanged: _rebuild,
    );
    _lastReadEpisode = AsyncSubscription(
      services.repository.watchLastReadEpisode(widget.source, widget.workId),
      onChanged: _rebuild,
    );
    _bindEpisodePage(1);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    unawaited(_novelInfo.cancel());
    unawaited(_isInLibrary.cancel());
    unawaited(_downloadProgress.cancel());
    unawaited(_lastReadEpisode.cancel());
    for (final subscription in _episodeSubscriptions.values) {
      unawaited(subscription.cancel());
    }
    super.dispose();
  }

  void _rebuild() {
    if (mounted) setState(() {});
  }

  void _showSnackBar(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  /// Subscribes to one page of the table of contents, once.
  void _bindEpisodePage(int page) {
    if (_episodeSubscriptions.containsKey(page)) return;
    _episodePages[page] = const AsyncLoading();
    _episodeSubscriptions[page] = context.services.repository
        .watchEpisodeList(widget.source, widget.workId, page)
        .listen(
          (episodes) => _setEpisodePage(page, AsyncData(episodes)),
          onError: (Object error, StackTrace stackTrace) {
            _setEpisodePage(page, AsyncError(error, stackTrace));
            _showSnackBar('ページ $page の更新に失敗しました: $error');
          },
        );
  }

  void _setEpisodePage(int page, Async<List<Episode>> next) {
    _episodePages[page] = next;
    _rebuild();
  }

  void _onScroll() {
    // しきい値は調整可能。
    // 40.0はおおよそ大きなタイトルが消え始める位置。
    final show = _scrollController.offset > 40.0;
    if (show != _showTitle) {
      setState(() {
        _showTitle = show;
      });
    }
  }

  Future<void> _copyNovelInfo(String? title, String url) async {
    final messenger = ScaffoldMessenger.of(context);
    await copyTextToClipboard('${title ?? ''}\n$url');
    messenger.showSnackBar(
      const SnackBar(content: Text('コピーしました')),
    );
  }

  /// ライブラリ登録ボタンの処理。
  ///
  /// 登録解除の場合は、ダウンロード済みの話も削除するか確認する。
  Future<void> _handleLibraryToggle(
    NovelInfo novelInfo,
    bool isInLibrary,
  ) async {
    if (!isInLibrary) {
      await context.services.repository.addNovelInfoToLibrary(novelInfo);
      return;
    }

    final action = await showRemoveFromLibraryDialog(
      context,
      novelTitle: novelInfo.title ?? 'タイトルなし',
    );
    if (!mounted ||
        action == null ||
        action == RemoveFromLibraryAction.cancel) {
      return;
    }

    final messenger = ScaffoldMessenger.of(context);
    try {
      await context.services.repository.removeFromLibrary(
        widget.source,
        widget.workId,
        deleteDownloads: action == RemoveFromLibraryAction.deleteDownloads,
      );

      if (!messenger.mounted) return;
      messenger.showSnackBar(
        const SnackBar(content: Text('ライブラリから削除しました')),
      );
    } on Object catch (e) {
      if (!messenger.mounted) return;
      messenger.showSnackBar(
        SnackBar(content: Text('ライブラリから削除できませんでした: $e')),
      );
    }
  }

  void _loadMoreEpisodes() {
    final novelInfo = _novelInfo.state.valueOrNull;
    final totalEpisodes = novelInfo?.generalAllNo;
    if (totalEpisodes != null) {
      final currentTotal = (_currentPage - 1) * 100; // approximation
      if (currentTotal >= totalEpisodes) {
        return;
      }
    }

    _bindEpisodePage(_currentPage + 1);
    setState(() {
      _currentPage++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // 1. Novel info.
    final novelInfoAsync = _novelInfo.state;

    // 2. エピソードリストのリアクティブな集約
    final allEpisodes = <Episode>[];
    var isListLoading = false;
    var listHasError = false;

    for (var i = 1; i <= _currentPage; i++) {
      final pageState = _episodePages[i] ?? const AsyncLoading<List<Episode>>();
      switch (pageState) {
        case AsyncData(:final value):
          allEpisodes.addAll(value);
        case AsyncLoading():
          isListLoading = true;
        case AsyncError():
          listHasError = true;
      }
    }

    // Graceful Degradation: キャッシュがあれば表示優先
    final novelInfo = novelInfoAsync.valueOrNull;

    if (novelInfo != null) {
      return _buildContent(
        context,
        novelInfo,
        allEpisodes,
        isLoading: isListLoading,
        hasError: listHasError,
      );
    }

    if (novelInfoAsync.isLoading) {
      return Scaffold(
        appBar: AppBar(),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Error')),
      body: Center(
        child: Text(
          'Failed to load novel info: ${novelInfoAsync.errorOrNull}',
        ),
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    NovelInfo novelInfo,
    List<Episode> episodes, {
    required bool isLoading,
    required bool hasError,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    final isOfflineMode = context.services.settings.isOfflineMode;
    final isShortStory = novelInfo.generalAllNo == 1;
    final downloadProgressAsync = _downloadProgress.state;
    final isInLibrary = _isInLibrary.state.valueOrNull ?? false;

    final progressBar = downloadProgressAsync.when(
      data: (progress) {
        if (progress != null && progress.isDownloading) {
          return LinearProgressIndicator(
            value: progress.progress,
            minHeight: 2,
          );
        }
        return const SizedBox.shrink();
      },
      loading: () => const SizedBox.shrink(),
      error: (e, s) => const SizedBox.shrink(),
    );

    final lastReadEpisode = _lastReadEpisode.state.valueOrNull;

    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          // 短編: 常にエピソード1へ移動
          if (isShortStory) {
            appRouter.pushOverlay(
              NovelEpisodeDest(
                source: widget.source,
                workId: widget.workId,
                episode: 1,
              ),
            );
            return;
          }

          // 連載: 最後に読んだエピソードまたはエピソード1へ移動
          final targetEpisode = lastReadEpisode ?? 1;
          appRouter.pushOverlay(
            NovelEpisodeDest(
              source: widget.source,
              workId: widget.workId,
              episode: targetEpisode,
            ),
          );
        },
        icon: const Icon(Icons.menu_book),
        label: Text(
          isShortStory
              ? '読む'
              : (lastReadEpisode != null ? '第$lastReadEpisode話から読む' : '第1話を読む'),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          final repository = context.services.repository;
          await repository.refreshNovelInfo(widget.source, widget.workId);
          for (var i = 1; i <= _currentPage; i++) {
            await repository.refreshEpisodeList(
              widget.source,
              widget.workId,
              i,
            );
          }
        },
        child: CustomScrollView(
          controller: _scrollController,
          slivers: [
            SliverAppBar(
              floating: true,
              pinned: true,
              backgroundColor: colorScheme.surface,
              surfaceTintColor: colorScheme.surface,
              title: AnimatedOpacity(
                opacity: _showTitle ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 200),
                child: Text(
                  novelInfo.title ?? '',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(2),
                child: progressBar,
              ),
              actions: [
                IconButton(
                  tooltip: 'コピー',
                  icon: const Icon(Icons.copy),
                  onPressed: () {
                    // サイトに応じた作品URLを組み立てる（なろう/カクヨム）
                    final url = buildWorkUrl(
                      novelInfo.source,
                      ncode: novelInfo.ncode,
                      workId: novelInfo.workId,
                    );
                    unawaited(
                      _copyNovelInfo(novelInfo.title, url),
                    );
                  },
                ),
                PopupMenuButton<String>(
                  onSelected: (value) {
                    if (value == 'download') {
                      if (isOfflineMode) {
                        showOfflineDisabledSnackBar(context);
                        return;
                      }
                      unawaited(_handleDownload(context, novelInfo));
                    }
                  },
                  itemBuilder: (context) {
                    return [
                      PopupMenuItem(
                        value: 'download',
                        child: Row(
                          children: [
                            Icon(
                              Icons.download,
                              color: isOfflineMode
                                  ? colorScheme.onSurface.withValues(
                                      alpha: 0.38,
                                    )
                                  : null,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '一括ダウンロード',
                              style: isOfflineMode
                                  ? TextStyle(
                                      color: colorScheme.onSurface.withValues(
                                        alpha: 0.38,
                                      ),
                                    )
                                  : null,
                            ),
                          ],
                        ),
                      ),
                    ];
                  },
                ),
              ],
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 8,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),
                    // 非公開バナー
                    if (novelInfo.isPrivate)
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: colorScheme.errorContainer,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.warning_amber_rounded,
                              color: colorScheme.onErrorContainer,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'この作品は非公開・削除されているため、'
                                '新しいデータを取得できません。'
                                'キャッシュから表示しています。',
                                style: TextStyle(
                                  color: colorScheme.onErrorContainer,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    if (novelInfo.isPrivate) const SizedBox(height: 16),
                    // Title
                    Text(
                      novelInfo.title ?? '',
                      style: Theme.of(context).textTheme.headlineMedium
                          ?.copyWith(
                            fontWeight: FontWeight.bold,
                            height: 1.3,
                          ),
                    ),
                    const SizedBox(height: 8),
                    // ソースバッジ（プロバイダ名を常に表示）
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: Theme.of(
                            context,
                          ).colorScheme.surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          novelInfo.source.label,
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(
                                  context,
                                ).colorScheme.onSurfaceVariant,
                              ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    // Writer
                    InkWell(
                      onTap: switch (novelInfo.userId) {
                        final userId? => () => appRouter.pushOverlay(
                          AuthorNovelsDest(userId: userId),
                        ),
                        null => null,
                      },
                      child: Text(
                        novelInfo.writer ?? '',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: novelInfo.userId != null
                              ? colorScheme.primary
                              : colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                    // Library Button
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: isInLibrary
                          ? FilledButton.tonalIcon(
                              onPressed: () {
                                unawaited(
                                  _handleLibraryToggle(novelInfo, true),
                                );
                              },
                              icon: const Icon(Icons.favorite),
                              label: const Text('ライブラリ登録済み'),
                              style: FilledButton.styleFrom(
                                backgroundColor: colorScheme.secondaryContainer,
                                foregroundColor:
                                    colorScheme.onSecondaryContainer,
                              ),
                            )
                          : FilledButton.icon(
                              onPressed: () {
                                unawaited(
                                  _handleLibraryToggle(novelInfo, false),
                                );
                              },
                              icon: const Icon(Icons.favorite_border),
                              label: const Text('ライブラリに追加'),
                            ),
                    ),
                    const SizedBox(height: 32),
                    // Keywords (Tags)
                    if (novelInfo.keyword case final keyword?) ...[
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: keyword
                              .split(' ')
                              .where((k) => k.isNotEmpty)
                              .map((keyword) {
                                return Padding(
                                  padding: const EdgeInsets.only(right: 8),
                                  child: Chip(
                                    label: Text(keyword),
                                    visualDensity: VisualDensity.compact,
                                    side: BorderSide.none,
                                    backgroundColor:
                                        colorScheme.surfaceContainerHigh,
                                    padding: EdgeInsets.zero,
                                    labelStyle: Theme.of(
                                      context,
                                    ).textTheme.bodySmall,
                                  ),
                                );
                              })
                              .toList(),
                        ),
                      ),
                      const SizedBox(height: 24),
                    ],
                    // Story
                    _StorySection(
                      story: novelInfo.story ?? '',
                      isShortStory: isShortStory,
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
            if (isShortStory)
              const SliverFillRemaining(
                hasScrollBody: false,
                child: SizedBox(height: 100),
              )
            else
              _EpisodeListSliver(
                source: widget.source,
                workId: widget.workId,
                totalEpisodes: novelInfo.generalAllNo ?? 0,
                episodes: episodes,
                isLoading: isLoading,
                hasMore: switch (novelInfo.generalAllNo) {
                  final total? => !isShortStory && episodes.length < total,
                  null => false,
                },
                onLoadMoreRequested: _loadMoreEpisodes,
              ),
            // Add extra padding at the bottom for FAB
            const SliverToBoxAdapter(child: SizedBox(height: 100)),
          ],
        ),
      ),
    );
  }
}

class _StorySection extends StatefulWidget {
  const _StorySection({
    required this.story,
    this.isShortStory = false,
  });

  final String story;
  final bool isShortStory;

  @override
  _StorySectionState createState() => _StorySectionState();
}

class _StorySectionState extends State<_StorySection> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    if (widget.story.isEmpty) {
      return const SizedBox.shrink();
    }

    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (!widget.isShortStory) ...[
          Text(
            'あらすじ',
            style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
        ],
        AnimatedCrossFade(
          duration: const Duration(milliseconds: 300),
          firstChild: Text(
            widget.story,
            maxLines: 5,
            overflow: TextOverflow.ellipsis,
            style: textTheme.bodyMedium?.copyWith(height: 1.6),
          ),
          secondChild: Text(
            widget.story,
            style: textTheme.bodyMedium?.copyWith(height: 1.6),
          ),
          crossFadeState: isExpanded || widget.isShortStory
              ? CrossFadeState.showSecond
              : CrossFadeState.showFirst,
        ),
        if (!widget.isShortStory)
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              style: TextButton.styleFrom(
                visualDensity: VisualDensity.compact,
              ),
              child: Text(isExpanded ? '閉じる' : 'もっと読む'),
              onPressed: () => setState(() => isExpanded = !isExpanded),
            ),
          ),
      ],
    );
  }
}

class _EpisodeListSliver extends StatelessWidget {
  const _EpisodeListSliver({
    required this.source,
    required this.workId,
    required this.totalEpisodes,
    required this.episodes,
    required this.isLoading,
    required this.hasMore,
    required this.onLoadMoreRequested,
    // initialLoadDoneは不要（親がローディング状態を管理）
  });

  final NovelSource source;
  final String workId;
  final int totalEpisodes;
  final List<Episode> episodes;
  final bool isLoading;
  final bool hasMore;
  final VoidCallback onLoadMoreRequested;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    // エピソードがなくローディング中の場合はスピナーを表示。
    // （親が処理する可能性もあるが、ここにフォールバックを保持）
    if (episodes.isEmpty && isLoading) {
      return const SliverToBoxAdapter(
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: CircularProgressIndicator(),
          ),
        ),
      );
    }

    if (episodes.isEmpty) {
      return const SliverToBoxAdapter(
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Text('エピソードがありません'),
          ),
        ),
      );
    }

    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          if (index == 0) {
            return Padding(
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 16),
              child: Text(
                '全$totalEpisodes話',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface,
                ),
              ),
            );
          }

          final episodeIndex = index - 1;
          if (episodeIndex >= episodes.length) {
            // リストの末尾に到達
            if (hasMore) {
              // さらにページがあり、次のページを現在ローディング中でなければ
              // 追加読み込みをトリガーする。
              // 注: ここのisLoadingは集約値。より具体的にすることもできるが、
              // スクロール中のスパムを避けるため現状のままとする。
              if (!isLoading) {
                unawaited(Future.microtask(onLoadMoreRequested));
              }
              return const Padding(
                padding: EdgeInsets.all(16),
                child: Center(child: CircularProgressIndicator()),
              );
            }
            return const SizedBox.shrink();
          }

          final episode = episodes[episodeIndex];
          return _EpisodeListTile(
            episode: episode,
            source: source,
            workId: workId,
          );
        },
        childCount: episodes.length + 2, // ヘッダー + アイテム + フッター
      ),
    );
  }
}

/// オフラインモード中の操作無効化メッセージを表示
void showOfflineDisabledSnackBar(BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(
      content: Text('オフラインモード中はエピソードのダウンロード・削除ができません'),
    ),
  );
}

Future<void> _handleDownload(
  BuildContext context,
  NovelInfo novelInfo,
) async {
  final workId = novelInfo.resolvedWorkId;
  if (workId == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('ダウンロードに失敗しました: 作品IDがありません')),
    );
    return;
  }

  final result = await context.services.repository.downloadNovelInfo(
    novelInfo,
  );

  if (!context.mounted) return;

  switch (result) {
    case DownloadResultSuccess(:final needsLibraryAddition):
      if (!needsLibraryAddition) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('ライブラリに追加しますか?'),
          action: SnackBarAction(
            label: '追加',
            onPressed: () {
              unawaited(
                context.services.repository.addNovelInfoToLibrary(novelInfo),
              );
            },
          ),
        ),
      );
    case DownloadResultCancelled():
      break;
    case DownloadResultError(:final message):
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('ダウンロードに失敗しました: $message')),
      );
    default:
      throw StateError('Unhandled DownloadResult: $result');
  }
}

class _EpisodeListTile extends StatelessWidget {
  const _EpisodeListTile({
    required this.episode,
    required this.source,
    required this.workId,
  });

  final Episode episode;
  final NovelSource source;
  final String workId;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    // 話数は目次順の連番（episode.index）を使用する。
    // URLからの抽出はカクヨムのURL（/works/{workId}/episodes/{episodeId}）で
    // 作品IDを拾ってしまうため行わない。
    final episodeNumber = episode.index;
    final episodeTitle = episode.subtitle ?? 'No Title';

    // デバッグ用: 話数の由来を確認するログ
    debugPrint(
      '[Novelty][EpisodeList] source=${source.name} '
      'index=$episodeNumber url=${episode.url}',
    );

    if (episodeNumber == null) {
      return ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        title: Text(
          episodeTitle,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: episode.update != null
            ? Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  '更新日: ${episode.update}',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              )
            : null,
      );
    }

    final isOfflineMode = context.services.settings.isOfflineMode;
    final isDownloaded = episode.isDownloaded;

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '第$episodeNumber話',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            episodeTitle,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              height: 1.4,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
      subtitle: episode.update != null
          ? Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                '更新日: ${episode.update}',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            )
          : null,
      trailing: isDownloaded
          ? Icon(
              Icons.check_circle,
              color: colorScheme.primary,
            )
          : null,
      onTap: () => appRouter.pushOverlay(
        NovelEpisodeDest(
          source: source,
          workId: workId,
          episode: episodeNumber,
          revised: episode.revised,
        ),
      ),
      onLongPress: isOfflineMode
          ? () => showOfflineDisabledSnackBar(context)
          : () => _showEpisodeMenu(context, episodeNumber, isDownloaded),
    );
  }

  /// エピソードの長押しメニューを表示
  Future<void> _showEpisodeMenu(
    BuildContext context,
    int episodeNumber,
    bool isDownloaded,
  ) async {
    if (!context.mounted) return;

    try {
      await showModalBottomSheet<void>(
        context: context,
        useSafeArea: true,
        builder: (bottomSheetContext) => SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (!isDownloaded)
                ListTile(
                  leading: const Icon(Icons.download),
                  title: const Text('ダウンロード'),
                  onTap: () async {
                    Navigator.pop(bottomSheetContext);
                    try {
                      await handleDownload(context, episodeNumber);
                    } on Object catch (e, stackTrace) {
                      debugPrint('予期しないエラー: $e\n$stackTrace');
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('予期しないエラーが発生しました')),
                        );
                      }
                    }
                  },
                ),
              if (isDownloaded)
                ListTile(
                  leading: Icon(
                    Icons.delete,
                    color: Theme.of(bottomSheetContext).colorScheme.error,
                  ),
                  title: Text(
                    '削除',
                    style: TextStyle(
                      color: Theme.of(bottomSheetContext).colorScheme.error,
                    ),
                  ),
                  onTap: () async {
                    Navigator.pop(bottomSheetContext);
                    try {
                      await handleDelete(context, episodeNumber);
                    } on Object catch (e, stackTrace) {
                      debugPrint('予期しないエラー: $e\n$stackTrace');
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('予期しないエラーが発生しました')),
                        );
                      }
                    }
                  },
                ),
            ],
          ),
        ),
      );
    } on Exception catch (e) {
      debugPrint('メニュー表示エラー: $e');
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('メニューを表示できませんでした')),
        );
      }
    }
  }

  Future<void> handleDelete(
    BuildContext context,
    int episodeNumber,
  ) async {
    final repo = context.services.repository;
    try {
      await repo.deleteDownloadedEpisode(source, workId, episodeNumber);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('削除しました')),
        );
      }
    } on Object catch (e, stackTrace) {
      debugPrint('削除エラー: $e\n$stackTrace');
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('削除に失敗しました')),
        );
      }
    }
  }

  Future<void> handleDownload(
    BuildContext context,
    int episodeNumber,
  ) async {
    final repo = context.services.repository;

    try {
      final success = await repo.downloadSingleEpisode(
        source,
        workId,
        episodeNumber,
        revised: episode.revised,
      );

      if (!context.mounted) return;

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('ダウンロードしました')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('ダウンロードに失敗しました')),
        );
      }
    } on Object catch (e, stackTrace) {
      debugPrint('ダウンロードエラー: $e\n$stackTrace');
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('ダウンロードに失敗しました')),
        );
      }
    }
  }
}
