import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:narou_parser/narou_parser.dart';
import 'package:novelty/repositories/novel_repository.dart';
import 'package:novelty/utils/settings_provider.dart';
import 'package:novelty/utils/tategaki_converter.dart';
import 'package:novelty/widgets/novel_content_view.dart';
import 'package:tategaki/tategaki.dart';

/// 小説のコンテンツを表示するウィジェット。
class NovelContent extends HookConsumerWidget {
  /// コンストラクタ。
  const NovelContent({
    required this.ncode,
    required this.episode,
    this.revised,
    super.key,
  });

  /// 小説のncode
  final String ncode;

  /// 小説のエピソード番号
  final int episode;

  /// 改稿日時
  final String? revised;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    final contentAsync = ref.watch(
      novelContentProvider(ncode: ncode, episode: episode, revised: revised),
    );

    return SafeArea(
      top: false, // AppBarがあるので上は不要
      child: NovelContentBody(
        ncode: ncode,
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
    required this.ncode,
    required this.episode,
    required this.settings,
    required this.content,
    super.key,
  });

  /// 小説のncode
  final String ncode;

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

    return settings.when(
      data: (settingsData) {
        return content.when(
          data: (contentData) {
            final textStyle = TextStyle(
              fontSize: settingsData.fontSize,
              color: textColor,
              fontFamily: settingsData.fontFamily,
              height: settingsData.lineHeight,
            );

            // システムジェスチャーエリアを考慮したパディング計算
            // SafeAreaが既にpaddingを適用しているので、systemGestureInsetsのみを追加
            final systemGestureInsets = MediaQuery.of(context).systemGestureInsets;

            // 縦書きモード用（横スクロール）: 左右端のバックジェスチャー領域を確保
            final verticalModePadding = EdgeInsets.only(
              left: systemGestureInsets.left,
              right: systemGestureInsets.right,
              top: 0,
              bottom: 0,
            );

            // 横書きモード用（縦スクロール）: 下端のホームジェスチャー領域を確保
            final horizontalModePadding = EdgeInsets.only(
              left: 0,
              right: 0,
              top: 0,
              bottom: systemGestureInsets.bottom,
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
                    return TategakiTextPaged(
                      key: PageStorageKey<String>(
                        'novel_paged_${ncode}_$episode',
                      ),
                      tategakiElements,
                      width: constraints.maxWidth,
                      height: constraints.maxHeight,
                      padding: verticalModePadding,
                    );
                  },
                );
              }

              return Directionality(
                textDirection: TextDirection.rtl,
                child: SingleChildScrollView(
                  key: PageStorageKey<String>(
                    'novel_vertical_${ncode}_$episode',
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
              key: PageStorageKey<String>('novel_horizontal_${ncode}_$episode'),
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
