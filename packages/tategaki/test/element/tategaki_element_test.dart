import 'package:flutter_test/flutter_test.dart';
import 'package:tategaki/tategaki.dart';

void main() {
  group('TategakiElement', () {
    group('TategakiChar', () {
      test('1文字を保持できる', () {
        const element = TategakiChar('あ');
        expect(element.char, 'あ');
      });

      test('TategakiElement.charで生成できる', () {
        const element = TategakiElement.char('い');
        expect(element, isA<TategakiChar>());
        expect((element as TategakiChar).char, 'い');
      });
    });

    group('TategakiTcy', () {
      test('縦中横テキストを保持できる', () {
        const element = TategakiTcy('12');
        expect(element.text, '12');
      });

      test('TategakiElement.tcyで生成できる', () {
        const element = TategakiElement.tcy('34');
        expect(element, isA<TategakiTcy>());
        expect((element as TategakiTcy).text, '34');
      });
    });

    group('TategakiNewLine', () {
      test('TategakiElement.newLineで生成できる', () {
        const element = TategakiElement.newLine();
        expect(element, isA<TategakiNewLine>());
      });
    });

    group('TategakiRuby', () {
      test('ベースとルビを保持できる', () {
        const element = TategakiRuby(base: '猫', ruby: 'ねこ');
        expect(element.base, '猫');
        expect(element.ruby, 'ねこ');
      });

      test('TategakiElement.rubyで生成できる', () {
        const element = TategakiElement.ruby(base: '犬', ruby: 'いぬ');
        expect(element, isA<TategakiRuby>());
        expect((element as TategakiRuby).base, '犬');
        expect(element.ruby, 'いぬ');
      });
    });
  });
}
