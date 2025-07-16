import 'package:flutter/material.dart';

// WidgetSpanの中で、Stackを使ってルビをベーステキストの上に重ねる
class RubySpan extends StatelessWidget {
  const RubySpan({
    super.key,
    required this.base,
    required this.ruby,
    required this.style,
  });

  final String base;
  final String ruby;
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
