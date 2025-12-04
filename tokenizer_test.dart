void main() {
  print(tokenize('異世界転生'));
  print(tokenize('魔法'));
  print(tokenize('猫'));
  print(tokenize('Hello World'));
  print(tokenize('A'));
}

String tokenize(String text) {
  if (text.isEmpty) return '';

  // Remove whitespace and normalize
  final cleanText = text.replaceAll(RegExp(r'\s+'), '');
  if (cleanText.isEmpty) return '';

  final tokens = <String>[];

  // 1文字の場合はそのまま
  if (cleanText.length == 1) {
    return cleanText;
  }

  // Bi-gram generation
  for (var i = 0; i < cleanText.length - 1; i++) {
    tokens.add(cleanText.substring(i, i + 2));
  }

  return tokens.join(' ');
}
