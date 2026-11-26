import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:narou_parser/narou_parser.dart';
import 'package:novelty/app_services.dart';
import 'package:novelty/sites/novel_source.dart';
import 'package:novelty/utils/font_family.dart';
import 'package:novelty/utils/settings_provider.dart';
import 'package:novelty/utils/tategaki_converter.dart';
import 'package:novelty/widgets/novel_content_view.dart';
import 'package:tategaki/tategaki.dart';
import 'package:tiny_state/tiny_state.dart';

/// Displays the body of one episode.
///
/// The episode is the load key: `PageView` reuses this widget's state when the
/// reader pages forward, and [KeyedLoader] drops the previous body when the key
/// changes.
class NovelContent extends StatelessWidget {
  /// Creates the widget.
  const NovelContent({
    required this.source,
    required this.workId,
    required this.episode,
    this.revised,
    this.isAppBarVisible = false,
    super.key,
  });

  /// The source site.
  final NovelSource source;

  /// Id of the work in that site (an N-code for narou).
  final String workId;

  /// Episode to display.
  final int episode;

  /// Revision timestamp, used for the cache check when given.
  final String? revised;

  /// Whether the AppBar is visible.
  ///
  /// When `true` the AppBar owns the top safe area, so the body does not pad
  /// for it; when `false` the body does.
  final bool isAppBarVisible;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      // The AppBar already covers the top when it is visible.
      top: !isAppBarVisible,
      child: KeyedLoader<List<NovelContentElement>>(
        loadKey: (source, workId, episode, revised),
        load: (_) => context.services.repository.getEpisode(
          source,
          workId,
          episode,
          revised: revised,
        ),
        builder: (context, content) => NovelContentBody(
          source: source,
          workId: workId,
          episode: episode,
          settings: context.services.settings.state,
          content: content,
        ),
      ),
    );
  }
}

/// 設定とコンテンツの状態に応じて表示を切り替える内部ウィジェット。
@visibleForTesting
class NovelContentBody extends StatefulWidget {
  /// コンストラクタ
  const NovelContentBody({
    required this.source,
    required this.workId,
    required this.episode,
    required this.settings,
    required this.content,
    super.key,
  });

  /// 提供サイト（プロバイダ）。
  final NovelSource source;

  /// サイト共通の作品ID（なろうはNコード）。
  final String workId;

  /// 小説のエピソード番号
  final int episode;

  /// 設定の状態
  final Async<AppSettings> settings;

  /// コンテンツの状態
  final Async<List<NovelContentElement>> content;

  @override
  State<NovelContentBody> createState() => _NovelContentBodyState();
}

class _NovelContentBodyState extends State<NovelContentBody> {
  List<TategakiElement>? _tategakiElements;
  List<NovelContentElement>? _tategakiFor;
  bool? _tategakiRubyEnabled;

  @override
  void initState() {
    super.initState();
    _applyImmersiveMode();
  }

  @override
  void didUpdateWidget(NovelContentBody oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!identical(oldWidget.settings, widget.settings)) {
      _applyImmersiveMode();
    }
  }

  /// Keeps the UI in immersive sticky mode while an episode is open.
  void _applyImmersiveMode() {
    unawaited(() async {
      try {
        // Always immersive sticky, vertical or horizontal.
        await SystemChrome.setEnabledSystemUIMode(
          SystemUiMode.immersiveSticky,
        );
      } on PlatformException catch (e, s) {
        // Log platform-channel failures instead of crashing the reader.
        debugPrint('Failed to set SystemUIMode: $e\n$s');
      }
    }());
  }

  @override
  void dispose() {
    // Restore edge-to-edge when the reader goes away.
    unawaited(
      SystemChrome.setEnabledSystemUIMode(
        SystemUiMode.edgeToEdge,
      ).catchError((Object e, StackTrace s) {
        debugPrint('Failed to reset SystemUIMode on dispose: $e\n$s');
        return;
      }),
    );
    super.dispose();
  }

  /// Caches the vertical-writing conversion.
  ///
  /// Returning the same list instance for unchanged content and ruby settings
  /// keeps the layout cache inside TategakiText / TategakiTextPaged warm.
  List<TategakiElement>? _tategaki(
    List<NovelContentElement>? content,
    bool isRubyEnabled,
  ) {
    if (identical(_tategakiFor, content) &&
        _tategakiRubyEnabled == isRubyEnabled) {
      return _tategakiElements;
    }
    _tategakiFor = content;
    _tategakiRubyEnabled = isRubyEnabled;
    return _tategakiElements = content == null
        ? null
        : TategakiConverter.convert(content, isRubyEnabled: isRubyEnabled);
  }

  @override
  Widget build(BuildContext context) {
    final contentData = widget.content.valueOrNull;
    final settingsData = widget.settings.valueOrNull;
    final textColor = Theme.of(context).brightness == Brightness.dark
        ? Colors.white
        : Colors.black;
    final tategakiElements = _tategaki(
      contentData,
      settingsData?.isRubyEnabled ?? true,
    );

    return widget.settings.when(
      data: (settingsData) {
        return widget.content.when(
          data: (contentData) {
            // 小説本文は固定のバンドルフォント(源暎こぶり明朝)を使用する
            final textStyle = TextStyle(
              fontSize: settingsData.fontSize,
              color: textColor,
              fontFamily: novelBodyFontFamily,
              height: settingsData.lineHeight,
            );

            // システムジェスチャーエリアを考慮したパディング計算
            // SafeAreaが既にpaddingを適用し、その上にsystemGestureInsetsを追加
            // デスクトップ環境ではsystemGestureInsetsが0なので、最低16pxを確保
            final systemGestureInsets = MediaQuery.of(
              context,
            ).systemGestureInsets;

            // 縦書きモード用（横スクロール）: 左右端のバックジェスチャー領域を確保
            final verticalModePadding = EdgeInsets.only(
              left: math.max(16, systemGestureInsets.left),
              right: math.max(16, systemGestureInsets.right),
              top: 16,
              bottom: 16,
            );

            // 横書きモード用（縦スクロール）: 下端のホームジェスチャー領域を確保
            final horizontalModePadding = EdgeInsets.only(
              left: 16,
              right: 16,
              top: 16,
              bottom: math.max(16, systemGestureInsets.bottom),
            );

            if (settingsData.isVertical) {
              final elements = tategakiElements!;

              if (settingsData.isPageFlip) {
                return LayoutBuilder(
                  builder: (context, constraints) {
                    return DefaultTextStyle(
                      style: textStyle,
                      child: TategakiTextPaged(
                        key: PageStorageKey<String>(
                          'novel_paged_${widget.workId}_${widget.episode}',
                        ),
                        elements,
                        width: constraints.maxWidth,
                        height: constraints.maxHeight,
                        padding: verticalModePadding,
                      ),
                    );
                  },
                );
              }

              // スクロールモード: TategakiText が列単位の遅延レンダリングを行う
              // （ListView.builder による無限リスト）。スクロール位置は
              // PageStorageKey を介して TategakiText 内部の ListView に渡る。
              return Directionality(
                textDirection: TextDirection.rtl,
                child: Padding(
                  padding: verticalModePadding,
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      return DefaultTextStyle(
                        style: textStyle,
                        child: TategakiText(
                          elements,
                          key: PageStorageKey<String>(
                            'novel_vertical_${widget.workId}_${widget.episode}',
                          ),
                          height: constraints.maxHeight,
                        ),
                      );
                    },
                  ),
                ),
              );
            }

            return SingleChildScrollView(
              key: PageStorageKey<String>(
                'novel_horizontal_${widget.workId}_${widget.episode}',
              ),
              padding: horizontalModePadding,
              child: RepaintBoundary(
                child: DefaultTextStyle(
                  style: textStyle,
                  child: NovelContentView(
                    elements: contentData,
                    isRubyEnabled: settingsData.isRubyEnabled,
                  ),
                ),
              ),
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, stack) => Center(child: Text('Error: $err')),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) => Center(child: Text('Error: $err')),
    );
  }
}
