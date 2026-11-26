import 'dart:async';

import 'package:flutter/material.dart';
import 'package:novelty/app_services.dart';
import 'package:novelty/models/episode.dart';
import 'package:novelty/models/novel_info.dart';
import 'package:novelty/router/app_router.dart';
import 'package:novelty/sites/novel_source.dart';
import 'package:novelty/utils/async_subscription.dart';
import 'package:novelty/utils/settings_provider.dart';
import 'package:novelty/widgets/gesture_shield.dart';
import 'package:novelty/widgets/novel_content.dart';

/// The reader: one episode per page, paged horizontally or vertically.
class NovelPage extends StatefulWidget {
  /// Creates the page.
  const NovelPage({
    required this.source,
    required this.workId,
    super.key,
    this.episode,
    this.revised,
  });

  /// The source site.
  final NovelSource source;

  /// Id of the work in that site (an N-code for narou).
  final String workId;

  /// Episode to open.
  final int? episode;

  /// Revision timestamp, used for the cache check when given.
  final String? revised;

  /// Builds the AppBar title.
  ///
  /// - short story: the novel title only.
  /// - serialised: "Episode X subtitle", or "Episode X" without one.
  @visibleForTesting
  static String buildTitle(
    NovelInfo novelInfo,
    int currentEpisodeNum,
    Episode? currentEpisode,
  ) {
    // Short stories show the title only.
    if (novelInfo.novelType == 2) {
      return novelInfo.title ?? '';
    }

    // Serialised.
    final subtitle = currentEpisode?.subtitle;

    // With a subtitle: "Episode X <subtitle>"; without one: "Episode X".
    if (subtitle != null && subtitle.isNotEmpty) {
      return '第$currentEpisodeNum話 $subtitle';
    } else {
      return '第$currentEpisodeNum話';
    }
  }

  @override
  State<NovelPage> createState() => _NovelPageState();
}

class _NovelPageState extends State<NovelPage> {
  late int _currentEpisode = widget.episode ?? 1;
  var _hasAddedInitialHistory = false;
  var _isAppBarVisible = false;
  var _bound = false;

  PageController? _pageController;
  int _pageControllerItemCount = 0;

  late final AsyncSubscription<NovelInfo> _novelInfo;
  AsyncSubscription<List<Episode>>? _episodeList;
  int _episodeListPage = 0;

  Map<int, String?>? _episodeMap;
  NovelInfo? _episodeMapFor;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_bound) return;
    _bound = true;
    _novelInfo = AsyncSubscription(
      context.services.repository.watchNovelInfo(widget.source, widget.workId),
      onChanged: _rebuild,
    );
    _syncEpisodeList();
  }

  @override
  void dispose() {
    _pageController?.dispose();
    unawaited(_novelInfo.cancel());
    final episodeList = _episodeList;
    if (episodeList != null) unawaited(episodeList.cancel());
    super.dispose();
  }

  void _rebuild() {
    if (mounted) setState(() {});
  }

  /// Subscribes only to the table-of-contents page the visible episode is on.
  void _syncEpisodeList() {
    final page = ((_currentEpisode - 1) ~/ 100) + 1;
    if (page == _episodeListPage) return;
    _episodeListPage = page;
    final previous = _episodeList;
    if (previous != null) unawaited(previous.cancel());
    _episodeList = AsyncSubscription(
      context.services.repository.watchEpisodeList(
        widget.source,
        widget.workId,
        page,
      ),
      onChanged: _rebuild,
    );
  }

  Map<int, String?> _episodeRevisions(NovelInfo novelInfo) {
    if (identical(_episodeMapFor, novelInfo) && _episodeMap != null) {
      return _episodeMap!;
    }
    final episodes = novelInfo.episodes;
    final map = episodes == null
        ? <int, String?>{}
        : {for (final e in episodes) ?e.index: e.revised};
    _episodeMapFor = novelInfo;
    _episodeMap = map;
    return map;
  }

  /// Adds the first history entry, once the novel info has loaded.
  void _addInitialHistory(NovelInfo novelInfo) {
    if (_hasAddedInitialHistory) return;
    _hasAddedInitialHistory = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _updateHistory(novelInfo, _currentEpisode);
    });
  }

  void _updateHistory(NovelInfo novelInfo, int episode) {
    unawaited(
      context.services.repository.addToHistory(
        source: widget.source,
        workId: widget.workId,
        title: novelInfo.title ?? '',
        writer: novelInfo.writer ?? '',
        lastEpisode: episode,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final settingsAsync = context.services.settings.state;

    return _novelInfo.state.when(
      data: (novelInfo) {
        _addInitialHistory(novelInfo);
        return settingsAsync.when(
          data: (settings) => _buildReader(context, novelInfo, settings),
          loading: () => _scaffoldWith(
            const Center(child: CircularProgressIndicator()),
          ),
          error: (error, stackTrace) =>
              _scaffoldWith(Center(child: Text('Error: $error'))),
        );
      },
      loading: () =>
          _scaffoldWith(const Center(child: CircularProgressIndicator())),
      error: (error, stackTrace) => Scaffold(
        appBar: AppBar(),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('エラーが発生しました: $error'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('戻る'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _scaffoldWith(Widget body) => Scaffold(appBar: AppBar(), body: body);

  Widget _buildReader(
    BuildContext context,
    NovelInfo novelInfo,
    AppSettings settings,
  ) {
    final totalEpisodes = novelInfo.generalAllNo ?? 1;
    final itemCount = _getItemCount(_currentEpisode, totalEpisodes);
    final episodeMap = _episodeRevisions(novelInfo);
    final currentEpisodeData = _episodeList?.state.valueOrNull?.firstWhere(
      (e) => e.index == _currentEpisode,
      orElse: () => const Episode(),
    );

    final pageController = _pageController ??= PageController(
      initialPage: _getInitialPage(_currentEpisode),
    );
    if (itemCount != _pageControllerItemCount) {
      _pageControllerItemCount = itemCount;
      // Reset the page position when itemCount changes.
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!pageController.hasClients) return;
        final targetPage = _getInitialPage(_currentEpisode);
        if (pageController.page?.round() != targetPage) {
          pageController.jumpToPage(targetPage);
        }
      });
    }

    // The reader pages horizontally, so the iOS back gesture would
    // fight the page swipe. Refusing the pop turns the gesture off;
    // the back button above calls appRouter.pop directly.
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) {
          appRouter.pop();
        }
      },
      child: Scaffold(
        appBar: _isAppBarVisible
            ? AppBar(
                leading: BackButton(onPressed: appRouter.pop),
                title: Text(
                  NovelPage.buildTitle(
                    novelInfo,
                    _currentEpisode,
                    currentEpisodeData,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              )
            : null,
        body: GestureDetector(
          behavior: HitTestBehavior.translucent,
          // Tap the body to show or hide the AppBar.
          onTap: () => setState(() => _isAppBarVisible = !_isAppBarVisible),
          child: Stack(
            children: [
              PageView.builder(
                scrollDirection: settings.isVertical
                    ? Axis.vertical
                    : Axis.horizontal,
                controller: pageController,
                itemCount: itemCount,
                onPageChanged: (index) => _handlePageChanged(
                  index,
                  totalEpisodes,
                  pageController,
                  novelInfo,
                ),
                itemBuilder: (context, index) {
                  final episodeNum = _getEpisodeNumber(
                    index,
                    _currentEpisode,
                    totalEpisodes,
                  );

                  // Prefer the revision passed to this page for the requested
                  // episode; otherwise use the one from NovelInfo.
                  final revisedDate =
                      (episodeNum == widget.episode && widget.revised != null)
                      ? widget.revised
                      : episodeMap[episodeNum];

                  return RepaintBoundary(
                    child: NovelContent(
                      source: widget.source,
                      workId: widget.workId,
                      episode: episodeNum,
                      revised: revisedDate,
                      isAppBarVisible: _isAppBarVisible,
                    ),
                  );
                },
              ),
              // Block the home gesture in vertical mode.
              if (settings.isVertical) const GestureShield(),
            ],
          ),
        ),
      ),
    );
  }

  /// How many pages the PageView holds.
  ///
  /// - single-episode novel: 1 page.
  /// - first episode of several: 2 pages (current + next).
  /// - last episode: 2 pages (previous + current).
  /// - anything in between: 3 pages (previous + current + next).
  static int _getItemCount(int currentEpisode, int totalEpisodes) {
    if (totalEpisodes == 1) return 1;
    if (currentEpisode == 1) return 2;
    if (currentEpisode == totalEpisodes) return 2;
    return 3;
  }

  /// The PageController's initial page index.
  ///
  /// - first episode: 0 (the first page).
  /// - otherwise: 1 (the middle page).
  static int _getInitialPage(int currentEpisode) {
    return currentEpisode == 1 ? 0 : 1;
  }

  /// Episode number for a PageView index.
  static int _getEpisodeNumber(
    int index,
    int currentEpisode,
    int totalEpisodes,
  ) {
    if (totalEpisodes == 1) return 1;

    if (currentEpisode == 1) {
      // First episode: [1, 2].
      return index + 1;
    }

    if (currentEpisode == totalEpisodes) {
      // Last episode: [n-1, n].
      return totalEpisodes - 1 + index;
    }

    // Middle: [current-1, current, current+1].
    return currentEpisode - 1 + index;
  }

  /// Handles a page change.
  void _handlePageChanged(
    int index,
    int totalEpisodes,
    PageController pageController,
    NovelInfo novelInfo,
  ) {
    final current = _currentEpisode;

    if (current == 1) {
      // First episode, moving to the second.
      if (index == 1 && totalEpisodes > 1) {
        setState(() => _currentEpisode = 2);
        _updateHistory(novelInfo, 2);
        _syncEpisodeList();
      }
    } else if (current == totalEpisodes) {
      // Last episode, moving to the previous.
      if (index == 0 && totalEpisodes > 1) {
        setState(() => _currentEpisode = totalEpisodes - 1);
        _updateHistory(novelInfo, totalEpisodes - 1);
        _syncEpisodeList();
      }
    } else {
      // Middle episodes.
      if (index == 0) {
        // Previous episode.
        setState(() => _currentEpisode--);
        _updateHistory(novelInfo, _currentEpisode);
        _syncEpisodeList();
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (pageController.hasClients) {
            pageController.jumpToPage(1);
          }
        });
      } else if (index == 2) {
        // Next episode.
        setState(() => _currentEpisode++);
        _updateHistory(novelInfo, _currentEpisode);
        _syncEpisodeList();
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (pageController.hasClients) {
            pageController.jumpToPage(1);
          }
        });
      }
    }
  }
}
