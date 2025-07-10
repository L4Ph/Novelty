import 'package:flutter/material.dart';

class RubyTextWidget extends StatelessWidget {
  const RubyTextWidget({
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
      fontSize: style.fontSize != null ? style.fontSize! * 0.6 : null,
    );

    // TextPainterを使って、ルビと本文の実際の幅を計算する
    final basePainter = TextPainter(
      text: TextSpan(text: base, style: style),
      textDirection: TextDirection.ltr,
    )..layout();

    final rubyPainter = TextPainter(
      text: TextSpan(text: ruby, style: rubyStyle),
      textDirection: TextDirection.ltr,
    )..layout();

    // ルビと本文のうち、幅が広い方に合わせる
    final width = basePainter.width > rubyPainter.width
        ? basePainter.width
        : rubyPainter.width;
    final height = basePainter.height + rubyPainter.height;

    return SizedBox(
      width: width,
      height: height,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            top: rubyPainter.height,
            child: Text(base, style: style),
          ),
          Positioned(
            top: 0,
            child: Text(ruby, style: rubyStyle),
          ),
        ],
      ),
    );
  }
}
