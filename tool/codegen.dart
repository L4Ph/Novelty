// ignore_for_file: avoid_print, reason: CLI ツールであるため

import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';

/// yuhsak/wakachigaki の model.ts を fetch して Dart const に変換する
///
/// 上流の `main` は変更され得るため、取得先を完全な commit SHA に固定し、
/// 取得内容の SHA-256 を期待値と照合してから生成する (サプライチェーン対策)。
Future<void> main() async {
  // 固定対象: https://github.com/yuhsak/wakachigaki のこの commit
  const upstreamCommit = '4a434512e24546dabad40639d03153b1ed495b55';
  // この commit の src/model/model.ts の SHA-256
  const expectedSha256 =
      'c043362b6922a5b595a48a5ee3c06acfeaa1a391ff3c44ad805f48291740a6dd';
  const url = 'https://raw.githubusercontent.com/yuhsak/wakachigaki/'
      '$upstreamCommit/src/model/model.ts';
  print('Fetching $url ...');
  final client = HttpClient();
  final request = await client.getUrl(Uri.parse(url));
  final response = await request.close();
  final bodyBytes = await response.fold<List<int>>(
    <int>[],
    (acc, chunk) => acc..addAll(chunk),
  );
  client.close();

  final body = utf8.decode(bodyBytes);

  // SHA-256 検証: 想定内容と一致しない場合は中止する
  final actualSha256 = sha256.convert(bodyBytes).toString();
  if (actualSha256 != expectedSha256) {
    throw StateError(
      'model.ts の SHA-256 が期待値と一致しません。 '
      'expected=$expectedSha256, actual=$actualSha256。 '
      '上流が更新された可能性があります。commit と期待ハッシュを確認してください。',
    );
  }

  // model.ts は `export const model: Model = { ... }` 形式
  final start = body.indexOf('export const model');
  if (start == -1) {
    throw Exception('model not found');
  }

  const thresholdCode = 'const double wakachigakiThreshold = 0.5;';

  var modelRaw = body.substring(start);
  // export const model: Model =  を除去
  modelRaw = modelRaw.replaceFirst(
    RegExp(r'export const model\s*:\s*Model\s*=\s*'),
    '',
  );
  modelRaw = modelRaw.replaceAll(' as const', '');
  modelRaw = modelRaw.trim();
  // 末尾の ; を除去
  if (modelRaw.endsWith(';')) {
    modelRaw = modelRaw.substring(0, modelRaw.length - 1);
  }

  // TypeScript の未クォートキーを Dart の文字列キーに変換
  final quoted = modelRaw.replaceAllMapped(
    RegExp(r'''(?<!')\b([A-Za-z_][A-Za-z0-9_]*)\b\s*:'''),
    (m) => "'${m.group(1)}':",
  );

  final out = '''
// GENERATED CODE - DO NOT MODIFY BY HAND
// Generated from yuhsak/wakachigaki（MIT）via tool/codegen.dart
// Credit: yuhsak/wakachigaki - https://github.com/yuhsak/wakachigaki
// 上流 commit: $upstreamCommit (SHA-256 = $actualSha256)

$thresholdCode

const Map<String, dynamic> wakachigakiModel = $quoted;

/// モデル設定値（生成スクリプトが末尾に追記）
int get wakachigakiNBuckets =>
    (wakachigakiModel['config'] as Map)['nBuckets'] as int;
int get wakachigakiSize => (wakachigakiModel['config'] as Map)['size'] as int;
int get wakachigakiOffset =>
    (wakachigakiModel['config'] as Map)['offset'] as int;
int get wakachigakiScale =>
    (wakachigakiModel['config'] as Map)['scale'] as int;
''';

  final outFile = File('packages/wakachigaki/lib/src/model.dart');
  await outFile.writeAsString(out);
  print('Wrote ${outFile.path} (${out.length} bytes)');
}
