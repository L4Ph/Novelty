// 値の等価性を検証するには const 正準化を避けて実行時にインスタンスを
// 生成する必要があるため、このファイルでは const 推奨 lint を無効化する。
// ignore_for_file: prefer_const_constructors

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

    group('値の等価性', () {
      test('同じ内容の要素は別インスタンスでも等しい', () {
        final pairs = <(TategakiElement, TategakiElement)>[
          (TategakiChar('あ'), TategakiChar('あ')),
          (TategakiTcy('12'), TategakiTcy('12')),
          (TategakiRotated('2024'), TategakiRotated('2024')),
          (TategakiNewLine(), TategakiNewLine()),
          (
            TategakiRuby(base: '猫', ruby: 'ねこ'),
            TategakiRuby(base: '猫', ruby: 'ねこ'),
          ),
          (
            TategakiRuby(
              base: '猫',
              ruby: 'ねこ',
              align: TategakiRubyAlign.jis,
            ),
            TategakiRuby(
              base: '猫',
              ruby: 'ねこ',
              align: TategakiRubyAlign.jis,
            ),
          ),
          (
            TategakiKenten(base: '重要', mark: '・'),
            TategakiKenten(base: '重要', mark: '・'),
          ),
        ];

        for (final (a, b) in pairs) {
          // 実行時生成なので const 正準化（identical）にはならない
          expect(identical(a, b), isFalse, reason: '$a は別インスタンス');
          expect(a, b);
          expect(a.hashCode, b.hashCode);
        }
      });

      test('内容が異なる要素は等しくない', () {
        expect(TategakiChar('あ'), isNot(TategakiChar('い')));
        expect(TategakiTcy('12'), isNot(TategakiTcy('34')));
        expect(TategakiRotated('2024'), isNot(TategakiRotated('2025')));
        expect(
          TategakiRuby(base: '猫', ruby: 'ねこ'),
          isNot(TategakiRuby(base: '犬', ruby: 'いぬ')),
        );
        expect(
          TategakiRuby(base: '猫', ruby: 'ねこ'),
          isNot(
            TategakiRuby(
              base: '猫',
              ruby: 'ねこ',
              align: TategakiRubyAlign.center,
            ),
          ),
        );
        expect(
          TategakiKenten(base: '重要', mark: '・'),
          isNot(TategakiKenten(base: '重要', mark: '﹅')),
        );
      });

      test('種類が異なる要素は等しくない', () {
        expect(TategakiChar('1'), isNot(TategakiTcy('1')));
        expect(TategakiTcy('1'), isNot(TategakiRotated('1')));
        expect(
          TategakiRuby(base: '1', ruby: '1'),
          isNot(TategakiChar('1')),
        );
      });
    });
  });
}
