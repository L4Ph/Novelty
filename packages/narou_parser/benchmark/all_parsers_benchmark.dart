import 'package:narou_parser/narou_parser.dart';

void main() {
  // 検証するデータサイズのリスト（行数）
  final scenarios = [10000, 50000, 100000, 300000];

  print('=== Narou Parser Ultimate Benchmark ===\n');
  print('Parsers to test:');
  print('1. Stable (DOM Chunked)   - package:html with chunk optimization');
  print('2. Fast   (Hono Regex)    - Single RegExp linear scan');
  print(
    '3. Ultra  (Hand Scanner)  - Raw string scanning (index manipulation)\n',
  );

  for (final lines in scenarios) {
    _runScenario(lines);
  }
}

void _runScenario(int lines) {
  print('----------------------------------------------------------------');
  print('Scenario: $lines lines');

  // HTML生成
  final stopwatchGen = Stopwatch()..start();
  final html = _generateLargeHtml(lines);
  stopwatchGen.stop();
  final sizeMb = (html.length / 1024 / 1024).toStringAsFixed(2);
  print('  HTML Generation: ${stopwatchGen.elapsedMilliseconds}ms');
  print('  Data Size:       ${html.length} chars ($sizeMb MB)\n');

  // 1. Stable (DOM)
  final swStable = Stopwatch()..start();
  final resStable = parseNovelContent(html);
  swStable.stop();
  final timeStable = swStable.elapsedMilliseconds;

  // 2. Fast (Regex)
  final swFast = Stopwatch()..start();
  final resFast = parseNovelContentFast(html);
  swFast.stop();
  final timeFast = swFast.elapsedMilliseconds;

  // 3. Ultra (Scanner)
  final swUltra = Stopwatch()..start();
  final resUltra = parseNovelContentUltra(html);
  swUltra.stop();
  final timeUltra = swUltra.elapsedMilliseconds;

  // 結果出力
  print('  [Performance]');
  print(
    '  Stable: ${timeStable.toString().padLeft(5)} ms (${_calcSpeed(timeStable, lines)} ms/1k)',
  );
  print(
    '  Fast:   ${timeFast.toString().padLeft(5)} ms (${_calcSpeed(timeFast, lines)} ms/1k) - ${hasSpeedup(timeStable, timeFast)}x faster',
  );
  print(
    '  Ultra:  ${timeUltra.toString().padLeft(5)} ms (${_calcSpeed(timeUltra, lines)} ms/1k) - ${hasSpeedup(timeStable, timeUltra)}x faster',
  );

  // 整合性チェック
  print('\n  [Validation]');
  final countMatch =
      resStable.length == resFast.length && resStable.length == resUltra.length;
  print(
    '  Element Counts: Stable=${resStable.length}, Fast=${resFast.length}, Ultra=${resUltra.length}',
  );
  print(
    '  Status:         ${countMatch ? "OK (All match)" : "WARNING (Count mismatch)"}',
  );
  print('----------------------------------------------------------------\n');
}

String _calcSpeed(int ms, int lines) {
  return (ms / (lines / 1000)).toStringAsFixed(2);
}

String hasSpeedup(int base, int target) {
  if (target == 0) return 'inf';
  return (base / target).toStringAsFixed(1);
}

String _generateLargeHtml(int lines) {
  final buffer = StringBuffer();
  for (var i = 0; i < lines; i++) {
    buffer.write('<p>');
    buffer.write('これは$i行目の文章です。');
    if (i % 3 == 0) {
      buffer.write('<ruby><rb>漢字</rb><rt>かんじ</rt></ruby>');
      buffer.write('と<ruby><rb>複合</rb><rt>ふくごう</rt></ruby>');
    } else if (i % 3 == 1) {
      buffer.write('<ruby>単語<rt>たんご</rt></ruby>');
    } else {
      buffer.write('<br>通常のテキストも長めに含めて検証します。');
    }
    buffer.write('</p>');
  }
  return buffer.toString();
}
