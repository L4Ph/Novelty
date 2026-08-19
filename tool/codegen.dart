// ignore_for_file: avoid_print, reason: cli tool

import 'dart:convert';
import 'dart:io';

/// yuhsak/wakachigaki の model.ts を fetch して Dart const に変換する
Future<void> main() async {
  const url =
      'https://raw.githubusercontent.com/yuhsak/wakachigaki/main/src/model/model.ts';
  print('Fetching $url ...');
  final client = HttpClient();
  final request = await client.getUrl(Uri.parse(url));
  final response = await request.close();
  final body = await response.transform(utf8.decoder).join();
  client.close();

  // model.ts は `export const model: Model = { ... }` 形式
  // `export const` 以降のオブジェクトを抽出
  final start = body.indexOf('export const model');
  if (start == -1) {
    throw Exception('model not found');
  }
  // TypeScript のオブジェクトを JSON に近づけるため、シングルクォートをダブルクォートに、
  // 未クォートキーをクォートする簡易変換はせず、Dart 側でそのまま貼り付ける
  // ここでは body 全体を Dart の raw 文字列として埋め込むのが最も忠実
  // 簡易: model.ts の内容から `weight` 部分を抽出して Dart Map リテラルに変換
  // 今回は body の `export const model` 以降をそのまま Dart に移植するため、
  // TypeScript の `:` 区切りを Dart でも使えるようにする（Dart の Map は `:` でOK）

  // より確実に: body をそのまま Dart ファイルにコメントで残し、重みは Adora の Dart 変換を参考にせず
  // ここでは簡易的に body から `weight` の文字列表現を抽出して Dart ファイルに埋め込む
  // threshold は別途取得（model.ts 内に含まれる）
  const thresholdCode = 'const double wakachigakiThreshold = 0.5;';

  var modelRaw = body.substring(start);
  // export const model: Model =  を除去
  modelRaw = modelRaw.replaceFirst(RegExp(r'export const model\s*:\s*Model\s*=\s*'), '');
  modelRaw = modelRaw.replaceAll(' as const', '');
  modelRaw = modelRaw.trim();
  // 末尾の ; を除去
  if (modelRaw.endsWith(';')) {
    modelRaw = modelRaw.substring(0, modelRaw.length - 1);
  }

  // TypeScript の未クォートキーを Dart の文字列キーに変換
  // 例: version: 2 → 'version': 2,  C: 86 → 'C': 86
  // ただし既にクォートされている '1': はそのまま
  // 正規表現で `(\b\w+\b)\s*:` を `'\\1':` に置換、ただし `'` で始まるものは除外
  final quoted = modelRaw.replaceAllMapped(
    RegExp(r'''(?<!')\b([A-Za-z_][A-Za-z0-9_]*)\b\s*:'''),
    (m) => "'${m.group(1)}':",
  );

  final out = '''
// GENERATED CODE - DO NOT MODIFY BY HAND
// Generated from yuhsak/wakachigaki (MIT) via tool/codegen.dart
// Credit: yuhsak/wakachigaki - https://github.com/yuhsak/wakachigaki

$thresholdCode

const Map<String, dynamic> wakachigakiModel = $quoted;
''';

  final outFile = File('packages/wakachigaki/lib/src/model.dart');
  await outFile.writeAsString(out);
  print('Wrote ${outFile.path} (${out.length} bytes)');
}
