import 'package:flutter/material.dart';
import 'package:novelty/utils/vertical_rotated.dart';

class Tategaki extends StatelessWidget {
  const Tategaki(
    this.text, {
    super.key,
    this.style,
    this.space = 12,
  });

  final String text;
  final TextStyle? style;
  final double space;

  @override
  Widget build(BuildContext context) {
    final splitText = text.split('\n');
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final s in splitText) _textBox(s.runes),
      ],
    );
  }

  Widget _textBox(Runes runes) {
    return Wrap(
      direction: Axis.vertical,
      children: [
        for (final rune in runes)
          Row(
            children: [
              SizedBox(width: space),
              _character(String.fromCharCode(rune)),
            ],
          ),
      ],
    );
  }

  Widget _character(String char) {
    if (VerticalRotated.map[char] != null) {
      return Text(VerticalRotated.map[char]!, style: style);
    } else {
      return Text(char, style: style);
    }
  }
}
