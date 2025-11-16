import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:novelty/models/novel_content_element.dart';
import 'package:novelty/repositories/novel_repository.dart';
import 'package:novelty/utils/settings_provider.dart';
import 'package:novelty/widgets/novel_content_view.dart';
import 'package:novelty/widgets/tategaki.dart';

/// 小説のコンテンツを表示するウィジェット。
class NovelContent extends HookConsumerWidget {
  /// コンストラクタ。
  const NovelContent({
    required this.ncode,
    required this.episode,
    super.key,
  });

  /// 小説のncode
  final String ncode;

  /// 小説のエピソード番号
  final int episode;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    final contentAsync = ref.watch(
      novelContentProvider(ncode: ncode, episode: episode),
    );

    return SafeArea(
      top: false, // AppBarがあるので上は不要
      child: NovelContentBody(
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
    required this.settings,
    required this.content,
    super.key,
  });

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
            );

            if (settingsData.isVertical) {
              return Directionality(
                textDirection: TextDirection.rtl,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.all(16),
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      return RepaintBoundary(
                        child: Tategaki(
                          contentData,
                          style: textStyle,
                          maxHeight: constraints.maxHeight,
                        ),
                      );
                    },
                  ),
                ),
              );
            }

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: RepaintBoundary(
                child: DefaultTextStyle(
                  style: textStyle,
                  child: NovelContentView(elements: contentData),
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
