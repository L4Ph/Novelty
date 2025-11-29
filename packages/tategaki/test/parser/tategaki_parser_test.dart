import 'package:flutter_test/flutter_test.dart';
import 'package:tategaki/tategaki.dart';

void main() {
  group('TategakiParser', () {
    group('基本的な文字', () {
      test('ひらがなを1文字ずつCharに変換する', () {
        final result = TategakiParser.parse('あい');
        expect(result.length, 2);
        expect(result[0], isA<TategakiChar>());
        expect((result[0] as TategakiChar).char, 'あ');
        expect((result[1] as TategakiChar).char, 'い');
      });

      test('漢字を1文字ずつCharに変換する', () {
        final result = TategakiParser.parse('猫犬');
        expect(result.length, 2);
        expect((result[0] as TategakiChar).char, '猫');
        expect((result[1] as TategakiChar).char, '犬');
      });
    });

    group('字形変換', () {
      test('句読点を縦書き用に変換する', () {
        final result = TategakiParser.parse('。、');
        expect((result[0] as TategakiChar).char, '︒');
        expect((result[1] as TategakiChar).char, '︑');
      });

      test('括弧を縦書き用に変換する', () {
        final result = TategakiParser.parse('「」');
        expect((result[0] as TategakiChar).char, '﹁');
        expect((result[1] as TategakiChar).char, '﹂');
      });
    });

    group('改行', () {
      test('改行をNewLineに変換する', () {
        final result = TategakiParser.parse('あ\nい');
        expect(result.length, 3);
        expect(result[0], isA<TategakiChar>());
        expect(result[1], isA<TategakiNewLine>());
        expect(result[2], isA<TategakiChar>());
      });

      test('連続する改行を個別のNewLineに変換する', () {
        final result = TategakiParser.parse('あ\n\nい');
        expect(result.length, 4);
        expect(result[1], isA<TategakiNewLine>());
        expect(result[2], isA<TategakiNewLine>());
      });
    });

    group('縦中横（TCY）', () {
      test('2桁の数字をTcyに変換する', () {
        final result = TategakiParser.parse('12時');
        expect(result.length, 2);
        expect(result[0], isA<TategakiTcy>());
        expect((result[0] as TategakiTcy).text, '12');
        expect((result[1] as TategakiChar).char, '時');
      });

      test('3桁の数字をTcyに変換する', () {
        final result = TategakiParser.parse('123番');
        expect(result.length, 2);
        expect(result[0], isA<TategakiTcy>());
        expect((result[0] as TategakiTcy).text, '123');
      });

      test('4桁以上の数字は1文字ずつCharに変換する', () {
        final result = TategakiParser.parse('2024年');
        expect(result.length, 5);
        expect(result[0], isA<TategakiChar>());
        expect(result[1], isA<TategakiChar>());
        expect(result[2], isA<TategakiChar>());
        expect(result[3], isA<TategakiChar>());
        expect(result[4], isA<TategakiChar>());
      });

      test('1桁の数字はCharに変換する', () {
        final result = TategakiParser.parse('1日');
        expect(result.length, 2);
        expect(result[0], isA<TategakiChar>());
        expect((result[0] as TategakiChar).char, '1');
      });

      test('文中の2桁数字をTcyに変換する', () {
        final result = TategakiParser.parse('第12話');
        expect(result.length, 3);
        expect((result[0] as TategakiChar).char, '第');
        expect(result[1], isA<TategakiTcy>());
        expect((result[1] as TategakiTcy).text, '12');
        expect((result[2] as TategakiChar).char, '話');
      });
    });

    group('空文字列', () {
      test('空文字列は空のリストを返す', () {
        final result = TategakiParser.parse('');
        expect(result, isEmpty);
      });
    });

    group('複合パターン', () {
      test('複合的なテキストを正しくパースする', () {
        final result = TategakiParser.parse('「12時だ」\n次へ');
        expect(result.length, 8);
        expect((result[0] as TategakiChar).char, '﹁'); // 「→﹁
        expect(result[1], isA<TategakiTcy>()); // 12
        expect((result[2] as TategakiChar).char, '時');
        expect((result[3] as TategakiChar).char, 'だ');
        expect((result[4] as TategakiChar).char, '﹂'); // 」→﹂
        expect(result[5], isA<TategakiNewLine>());
        expect((result[6] as TategakiChar).char, '次');
        expect((result[7] as TategakiChar).char, 'へ');
      });
    });
  });
}
