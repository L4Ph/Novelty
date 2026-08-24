import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:narou_parser/narou_parser.dart';
import 'package:novelty/repositories/novel_repository.dart';
import 'package:novelty/sites/novel_source.dart';
import 'package:novelty/utils/font_family.dart';
import 'package:novelty/utils/settings_provider.dart';
import 'package:novelty/utils/tategaki_converter.dart';
import 'package:novelty/widgets/novel_content_view.dart';
import 'package:tategaki/tategaki.dart';

/// 小説のコンテンツを表示するウィジェット。
class NovelContent extends HookConsumerWidget {
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
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    final contentAsync = ref.watch(
      novelContentProvider(
        source: source,
        workId: workId,
        episode: episode,
        revised: revised,
      ),
    );

    return SafeArea(
      top: !isAppBarVisible, // AppBarが表示されている場合は上は不要
      child: NovelContentBody(
        source: source,
        workId: workId,
        episode: episode,
        settings: settings,
        content: contentAsync,
      ),
    );
  }
}

/// 設定とコンテンツの状態に応じて表示を切り替える内部ウィジェット。
@visibleForTesting
class NovelContentBody extends HookWidget {
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
  final AsyncValue<AppSettings> settings;

  /// コンテンツの状態
  final AsyncValue<List<NovelContentElement>> content;

  @override
  Widget build(BuildContext context) {
    // テーマのbrightnessとテキストカラーの計算をメモ化
    final textColor = useMemoized(() {
      final brightness = Theme.of(context).brightness;
      return brightness == Brightness.dark ? Colors.white : Colors.black;
    }, [Theme.of(context).brightness]);

    // エピソード表示中は常にimmersiveStickyモードを設定
    useEffect(() {
      Future<void> setUiMode() async {
        try {
          // 縦書き・横書き問わず常にimmersiveStickyを使用
          await SystemChrome.setEnabledSystemUIMode(
            SystemUiMode.immersiveSticky,
          );
        } on PlatformException catch (e, s) {
          // プラットフォームチャネルのエラーをログに出力
          debugPrint('Failed to set SystemUIMode: $e\n$s');
        }
      }

      // エピソード表示中は常にUIモードを設定
      unawaited(setUiMode());

      // クリーンアップ: ウィジェット破棄時はedgeToEdgeに戻す
      return () {
        unawaited(
          SystemChrome.setEnabledSystemUIMode(
            SystemUiMode.edgeToEdge,
          ).catchError((Object e, StackTrace s) {
            debugPrint('Failed to reset SystemUIMode on dispose: $e\n$s');
          }),
        );
      };
    }, [settings]);

    return settings.when(
      data: (settingsData) {
        return content.when(
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
              // NovelContentElementをTategakiElementに変換
              final tategakiElements = TategakiConverter.convert(
                contentData,
                isRubyEnabled: settingsData.isRubyEnabled,
              );

              if (settingsData.isPageFlip) {
                return LayoutBuilder(
                  builder: (context, constraints) {
                    return DefaultTextStyle(
                      style: textStyle,
                      child: TategakiTextPaged(
                        key: PageStorageKey<String>(
                          'novel_paged_${workId}_$episode',
                        ),
                        tategakiElements,
                        width: constraints.maxWidth,
                        height: constraints.maxHeight,
                        padding: verticalModePadding,
                      ),
                    );
                  },
                );
              }

              return Directionality(
                textDirection: TextDirection.rtl,
                child: SingleChildScrollView(
                  key: PageStorageKey<String>(
                    'novel_vertical_${workId}_$episode',
                  ),
                  scrollDirection: Axis.horizontal,
                  padding: verticalModePadding,
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      return RepaintBoundary(
                        child: DefaultTextStyle(
                          style: textStyle,
                          child: TategakiText(
                            tategakiElements,
                            height: constraints.maxHeight,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              );
            }

            return SingleChildScrollView(
              key: PageStorageKey<String>(
                'novel_horizontal_${workId}_$episode',
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
