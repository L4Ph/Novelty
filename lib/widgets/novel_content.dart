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

/// 小説のコンテンツを表示するウィジェット。
class NovelContent extends StatefulWidget {
  /// コンストラクタ。
  const NovelContent({
    required this.source,
    required this.workId,
    required this.episode,
    this.revised,
    this.isAppBarVisible = false,
    super.key,
  });

  /// 提供サイト（プロバイダ）。
  final NovelSource source;

  /// サイト共通の作品ID（なろうはNコード）。
  final String workId;

  /// 小説のエピソード番号
  final int episode;

  /// 改稿日時
  final String? revised;

  /// AppBarが表示されているかどうか。
  ///
  /// `true` の場合、上部のセーフエリアはAppBarが確保するため
  /// 本文側では上部のパディングを不要にする。
  /// `false` の場合、本文側で上部のセーフエリアを確保する。
  final bool isAppBarVisible;

  @override
  State<NovelContent> createState() => _NovelContentState();
}

class _NovelContentState extends State<NovelContent> {
  Async<List<NovelContentElement>> _content = const AsyncLoading();
  var _loaded = false;

  /// 取得の世代。古い取得の結果が新しい表示を上書きしないようにする。
  var _request = 0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_loaded) return;
    _loaded = true;
    unawaited(_load());
  }

  @override
  void didUpdateWidget(NovelContent oldWidget) {
    super.didUpdateWidget(oldWidget);
    // PageView reuses this State when the reader pages forward, so a new
    // episode or revision has to drop the cached body.
    if (oldWidget.episode != widget.episode ||
        oldWidget.revised != widget.revised ||
        oldWidget.workId != widget.workId ||
        oldWidget.source != widget.source) {
      _content = const AsyncLoading();
      unawaited(_load());
    }
  }

  Future<void> _load() async {
    final request = ++_request;
    try {
      final content = await context.services.repository.getEpisode(
        widget.source,
        widget.workId,
        widget.episode,
        revised: widget.revised,
      );
      if (!mounted || request != _request) return;
      setState(() => _content = AsyncData(content));
    } on Object catch (error, stackTrace) {
      if (!mounted || request != _request) return;
      setState(() => _content = AsyncError(error, stackTrace));
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: !widget.isAppBarVisible, // AppBarが表示されている場合は上は不要
      child: NovelContentBody(
        source: widget.source,
        workId: widget.workId,
        episode: widget.episode,
        settings: context.services.settings.state,
        content: _content,
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

  /// エピソード表示中は常にimmersiveStickyモードにする。
  void _applyImmersiveMode() {
    unawaited(() async {
      try {
        // 縦書き・横書き問わず常にimmersiveStickyを使用
        await SystemChrome.setEnabledSystemUIMode(
          SystemUiMode.immersiveSticky,
        );
      } on PlatformException catch (e, s) {
        // プラットフォームチャネルのエラーをログに出力
        debugPrint('Failed to set SystemUIMode: $e\n$s');
      }
    }());
  }

  @override
  void dispose() {
    // クリーンアップ: ウィジェット破棄時はedgeToEdgeに戻す
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

  /// 縦書き要素への変換をキャッシュする。
  ///
  /// 同一のコンテンツ・ルビ設定なら同じリストインスタンスを返すことで、
  /// TategakiText / TategakiTextPaged 側のレイアウトキャッシュが有効になる。
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
