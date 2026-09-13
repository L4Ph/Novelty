import 'package:flutter/material.dart';

/// 傍点（圏点）付きテキストを横書きで表示するウィジェット。
///
/// 横書きでは各文字の上に点を配置する（JLREQ §3.3.9）。縦書きの傍点は
/// `TategakiElement.kenten` 側で描画する。
class KentenSpan extends StatelessWidget {
  /// コンストラクタ。
  const KentenSpan({
    required this.base,
    required this.mark,
    required this.style,
    super.key,
  });

  /// 対象文字。
  final String base;

  /// 点の文字。
  final String mark;

  /// テキストスタイル。
  final TextStyle style;

  @override
  Widget build(BuildContext context) {
    final markStyle = style.copyWith(
      fontSize: style.fontSize != null ? style.fontSize! * 0.6 : null,
      height: 1,
    );
    final chars = [
      for (final rune in base.runes) String.fromCharCode(rune),
    ];

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (final char in chars)
          Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.center,
            children: [
              RichText(text: TextSpan(text: char, style: style)),
              Positioned(
                top: -(markStyle.fontSize ?? 10) * 0.6,
                child: RichText(
                  text: TextSpan(text: mark, style: markStyle),
                ),
              ),
            ],
          ),
      ],
    );
  }
}
