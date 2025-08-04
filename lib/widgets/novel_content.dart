import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_riverpod/misc.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:novelty/models/novel_content_element.dart';
import 'package:novelty/repositories/novel_repository.dart';
import 'package:novelty/utils/settings_provider.dart';
import 'package:novelty/widgets/novel_content_view.dart';
import 'package:novelty/widgets/tategaki.dart';

/// 小説のコンテンツを取得するプロバイダー。
final FutureProviderFamily<
  List<NovelContentElement>,
  ({int episode, String ncode})
>
novelContentProvider = FutureProvider.autoDispose
    .family<List<NovelContentElement>, ({String ncode, int episode})>((
      ref,
      params,
    ) async {
      final repository = ref.read(novelRepositoryProvider);
      return repository.getEpisode(params.ncode, params.episode);
    });

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
      novelContentProvider((ncode: ncode, episode: episode)),
    );

    // テーマのbrightnessとテキストカラーの計算をメモ化
    final textColor = useMemoized(() {
      final brightness = Theme.of(context).brightness;
      return brightness == Brightness.dark ? Colors.white : Colors.black;
    }, [Theme.of(context).brightness]);

    // コンテンツ構築関数をメモ化
    final buildContent = useCallback(
      (AppSettings settings, List<NovelContentElement> content) {
        final textStyle = settings.selectedFontTheme.copyWith(
          fontSize: settings.fontSize,
          color: textColor,
        );

        if (settings.isVertical) {
          return Directionality(
            textDirection: TextDirection.rtl,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.all(16),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return RepaintBoundary(
                    child: Tategaki(
                      content,
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
              child: NovelContentView(elements: content),
            ),
          ),
        );
      },
      [textColor],
    );

    // SafeAreaを適用して、ナビゲーションバーと干渉しないように
    return SafeArea(
      top: false, // AppBarがあるので上は不要
      child: settings.when(
        data: (settings) {
          return contentAsync.when(
            data: (content) => buildContent(settings, content),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (err, stack) => Center(child: Text('Error: $err')),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
    );
  }
}
