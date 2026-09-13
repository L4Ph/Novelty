// Unicode UAX #50 の VerticalOrientation.txt から Dart の範囲表を生成する。
//
// 使い方:
//   dart run tool/gen_vertical_orientation.dart \
//     data/VerticalOrientation.txt lib/src/layout/vertical_orientation_data.dart
import 'dart:io';

/// U=0, R=1, Tu=2, Tr=3
const _valueMap = <String, int>{
  'U': 0,
  'R': 1,
  'Tu': 2,
  'Tr': 3,
};

void main(List<String> args) {
  final inputPath = args.isNotEmpty
      ? args[0]
      : 'data/VerticalOrientation.txt';
  final outputPath = args.length > 1
      ? args[1]
      : 'lib/src/layout/vertical_orientation_data.dart';

  final lines = File(inputPath).readAsLinesSync();
  final starts = <int>[];
  final ends = <int>[];
  final values = <int>[];

  final rangePattern = RegExp(r'^([0-9A-F]+)(?:\.\.([0-9A-F]+))?\s*;\s*(\w+)');

  for (final line in lines) {
    final trimmed = line.trim();
    if (trimmed.isEmpty || trimmed.startsWith('#')) {
      continue;
    }
    final match = rangePattern.firstMatch(trimmed);
    if (match == null) {
      continue;
    }
    final start = int.parse(match.group(1)!, radix: 16);
    final end = match.group(2) != null
        ? int.parse(match.group(2)!, radix: 16)
        : start;
    final value = _valueMap[match.group(3)!];
    if (value == null) {
      continue;
    }
    starts.add(start);
    ends.add(end);
    values.add(value);
  }

  final buffer = StringBuffer()
    ..writeln('// GENERATED CODE - DO NOT MODIFY BY HAND')
    ..writeln('//')
    ..writeln('// Unicode UAX #50 Vertical_Orientation の範囲表。')
    ..writeln('// 生成: tool/gen_vertical_orientation.dart '
        '(data/VerticalOrientation.txt)')
    ..writeln('// 値: 0=U, 1=R, 2=Tu, 3=Tr')
    ..writeln()
    ..writeln('/// 範囲の開始コードポイント（昇順）')
    ..writeln('const List<int> verticalOrientationStarts = <int>[');
  for (final start in starts) {
    buffer.writeln('  0x${start.toRadixString(16)},');
  }
  buffer
    ..writeln('];')
    ..writeln()
    ..writeln('/// 範囲の終了コードポイント（昇順）')
    ..writeln('const List<int> verticalOrientationEnds = <int>[');
  for (final end in ends) {
    buffer.writeln('  0x${end.toRadixString(16)},');
  }
  buffer
    ..writeln('];')
    ..writeln()
    ..writeln('/// 各範囲の Vertical_Orientation 値')
    ..writeln('const List<int> verticalOrientationValues = <int>[');
  for (final value in values) {
    buffer.writeln('  $value,');
  }
  buffer.writeln('];');

  File(outputPath).writeAsStringSync(buffer.toString());
  stdout.writeln('Wrote $outputPath (${starts.length} ranges)');
}
