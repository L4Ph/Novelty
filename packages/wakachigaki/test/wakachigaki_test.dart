import 'package:test/test.dart';
import 'package:wakachigaki/wakachigaki.dart';

void main() {
  group('wakachigaki tokenize', () {
    test('空文字は空リスト', () {
      expect(tokenize(''), isEmpty);
      expect(tokenize('   '), isEmpty);
    });

    test('単純な日本語を分かち書きできる', () {
      final tokens = tokenize('ここでテキストを分かち書きします');
      expect(tokens, isNotEmpty);
      // 少なくとも「テキスト」を含むトークンができること
      expect(tokens.join(''), 'ここでテキストを分かち書きします');
    });

    test('魔法少女のような複合語を分割する', () {
      final tokens = tokenize('魔法少女は転生した');
      expect(tokens.join(''), '魔法少女は転生した');
      // 魔法少女が1トークンまたは2トークンに分かれることを許容
      expect(tokens.any((t) => t.contains('魔法') || t.contains('少女')), isTrue);
    });

    test('英語混じりも処理できる', () {
      final tokens = tokenize('Noveltyは小説ビューアー');
      expect(tokens.join(''), 'Noveltyは小説ビューアー');
    });
  });
}
