import 'package:flutter/material.dart';

// WidgetSpanの中で、Stackを使ってルビをベーステキストの上に重ねる
/// ルビ付きテキストを表示するウィジェット。
class RubySpan extends StatelessWidget {
  /// コンストラクタ。
  const RubySpan({
    required this.base,
    required this.ruby,
    required this.style,
    super.key,
  });

  /// ベーステキストとルビのテキスト、スタイルを指定する。
  final String base;

  /// ルビのテキスト。
  final String ruby;

  /// テキストスタイル。
  final TextStyle style;

  @override
  Widget build(BuildContext context) {
    final rubyStyle = style.copyWith(
      fontSize: style.fontSize != null ? style.fontSize! * 0.5 : null,
      height: 1,
    );

    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.center,
      children: [
        // ベーステキスト
        RichText(
          text: TextSpan(text: base, style: style),
        ),
        // ルビテキスト
        Positioned(
          top: -(rubyStyle.fontSize ?? 10) * 0.5,
          child: RichText(
            text: TextSpan(text: ruby, style: rubyStyle),
          ),
        ),
      ],
    );
  }
}
