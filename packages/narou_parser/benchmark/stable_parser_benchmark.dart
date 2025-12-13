// ignore_for_file: avoid_print, unreachable_from_main // benchmark logic

import 'package:narou_parser/narou_parser.dart';

/// 通常パーサー (parseNovelContent) の性能測定ベンチマーク
///
/// 実用的なシナリオで性能を測定し、最適化の効果を確認するために使用します。
void main() {
  print('=== 通常パーサー (Stable DOM Parser) ベンチマーク ===\n');

  // 検証するデータサイズのリスト（行数）
  final scenarios = [
    ScenarioConfig(name: '小規模', lines: 1000),
    ScenarioConfig(name: '中規模', lines: 10000),
    ScenarioConfig(name: '大規模', lines: 50000),
    ScenarioConfig(name: '超大規模', lines: 100000),
  ];

  final results = <BenchmarkResult>[];

  for (final scenario in scenarios) {
    print('----------------------------------------');
    print('シナリオ: ${scenario.name} (${scenario.lines}行)');

    // HTML生成
    final stopwatchGen = Stopwatch()..start();
    final html = _generateRealisticHtml(scenario.lines);
    stopwatchGen.stop();

    final sizeKb = (html.length / 1024).toStringAsFixed(2);
    final sizeMb = (html.length / 1024 / 1024).toStringAsFixed(2);
    print('  HTML生成時間: ${stopwatchGen.elapsedMilliseconds}ms');
    print('  データサイズ: ${html.length} chars ($sizeKb KB / $sizeMb MB)');

    // ウォームアップ（初回のJITコンパイルの影響を除外）
    if (scenario.lines == scenarios.first.lines) {
      parseNovelContent(html);
      print('  (ウォームアップ完了)');
    }

    // 実際の計測（複数回実行して平均を取る）
    const iterations = 3;
    final times = <int>[];
    var elementCount = 0;

    for (var i = 0; i < iterations; i++) {
      final sw = Stopwatch()..start();
      final elements = parseNovelContent(html);
      sw.stop();
      times.add(sw.elapsedMilliseconds);
      elementCount = elements.length;
    }

    // 統計情報を計算
    times.sort();
    final minTime = times.first;
    final maxTime = times.last;
    final avgTime = times.reduce((a, b) => a + b) ~/ times.length;
    final medianTime = times[times.length ~/ 2];

    // スループット計算（行/秒）
    final throughput = (scenario.lines / (avgTime / 1000)).toStringAsFixed(0);
    final msPerKLines = (avgTime / (scenario.lines / 1000)).toStringAsFixed(2);

    print('\n  [パフォーマンス] ($iterations回実行)');
    print('  最小時間: $minTime ms');
    print('  平均時間: $avgTime ms');
    print('  中央値:   $medianTime ms');
    print('  最大時間: $maxTime ms');
    print('  スループット: $throughput 行/秒');
    print('  処理速度:     $msPerKLines ms/1k行');
    print('\n  [出力]');
    print('  要素数: $elementCount');
    print('----------------------------------------\n');

    results.add(
      BenchmarkResult(
        scenario: scenario,
        avgTime: avgTime,
        minTime: minTime,
        maxTime: maxTime,
        medianTime: medianTime,
        elementCount: elementCount,
        dataSize: html.length,
      ),
    );
  }

  // サマリー表示
  _printSummary(results);
}

/// 実用的なHTMLを生成（なろう小説の実際の構造に近い）
String _generateRealisticHtml(int lines) {
  final buffer = StringBuffer();

  for (var i = 0; i < lines; i++) {
    final lineType = i % 10;

    buffer.write('<p>');

    switch (lineType) {
      // 0-2: ルビ付きテキスト（30%）
      case 0:
        buffer
          ..write('その日、')
          ..write('<ruby><rb>彼</rb><rt>かれ</rt></ruby>')
          ..write('は')
          ..write('<ruby><rb>不思議</rb><rt>ふしぎ</rt></ruby>')
          ..write('な')
          ..write('<ruby><rb>体験</rb><rt>たいけん</rt></ruby>')
          ..write('をした。');
      case 1:
        buffer
          ..write('<ruby><rb>魔法</rb><rt>まほう</rt></ruby>')
          ..write('の')
          ..write('<ruby><rb>世界</rb><rt>せかい</rt></ruby>')
          ..write('へようこそ。ここは')
          ..write('<ruby><rb>異世界</rb><rt>いせかい</rt></ruby>')
          ..write('です。');
      case 2:
        buffer
          ..write('「')
          ..write('<ruby><rb>君</rb><rt>きみ</rt></ruby>')
          ..write('は')
          ..write('<ruby><rb>勇者</rb><rt>ゆうしゃ</rt></ruby>')
          ..write('として')
          ..write('<ruby><rb>選</rb><rt>えら</rt></ruby>')
          ..write('ばれたのだ」');

      // 3-4: 改行を含むテキスト（20%）
      case 3:
        buffer.write('これは長い文章です。<br>改行が含まれています。<br>三行目もあります。');
      case 4:
        buffer.write('段落の中で<br>改行することで<br>演出効果を高めることができる。');

      // 5-7: プレーンテキスト（30%）
      case 5:
        buffer.write('普通の文章が続きます。特別な装飾はありません。');
      case 6:
        buffer.write('そして物語は進んでいく。主人公は冒険を続ける。');
      case 7:
        buffer.write('時には戦い、時には仲間と語り合う。そんな日々が続いた。');

      // 8-9: 混在パターン（20%）
      case 8:
        buffer
          ..write('彼女は')
          ..write('<ruby><rb>微笑</rb><rt>ほほえ</rt></ruby>')
          ..write('んだ。<br>その')
          ..write('<ruby><rb>笑顔</rb><rt>えがお</rt></ruby>')
          ..write('は美しかった。');
      case 9:
        buffer
          ..write('「')
          ..write('<ruby><rb>分</rb><rt>わ</rt></ruby>')
          ..write('かった」<br>そう言って、彼は')
          ..write('<ruby><rb>頷</rb><rt>うなず</rt></ruby>')
          ..write('いた。');
    }

    buffer.write('</p>');
  }

  return buffer.toString();
}

void _printSummary(List<BenchmarkResult> results) {
  print('========================================');
  print('サマリー');
  print('========================================');
  print('');
  print('| シナリオ | 行数 | データサイズ | 平均時間 | ms/1k行 |');
  print('|---------|------|------------|---------|---------|');

  for (final result in results) {
    final sizeKb = (result.dataSize / 1024).toStringAsFixed(1);
    final msPerKLines = (result.avgTime / (result.scenario.lines / 1000))
        .toStringAsFixed(2);

    print(
      '| ${result.scenario.name.padRight(7)} | ${result.scenario.lines.toString().padLeft(6)} | ${sizeKb.padLeft(8)} KB | ${result.avgTime.toString().padLeft(7)} ms | ${msPerKLines.padLeft(7)} |',
    );
  }

  print('');
  print('========================================');
}

class ScenarioConfig {
  ScenarioConfig({required this.name, required this.lines});

  final String name;
  final int lines;
}

class BenchmarkResult {
  BenchmarkResult({
    required this.scenario,
    required this.avgTime,
    required this.minTime,
    required this.maxTime,
    required this.medianTime,
    required this.elementCount,
    required this.dataSize,
  });

  final ScenarioConfig scenario;
  final int avgTime;
  final int minTime;
  final int maxTime;
  final int medianTime;
  final int elementCount;
  final int dataSize;
}
