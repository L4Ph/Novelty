// CRC32 ハッシュとバケット化
// yuhsak/wakachigaki の src/hash/crc32.ts / hash.ts を Dart に移植

import 'dart:convert';
import 'dart:typed_data';

List<int> _buildCrc32Table() {
  final table = Uint32List(256);
  for (var i = 0; i < 256; i++) {
    var c = i;
    for (var k = 0; k < 8; k++) {
      c = (c & 1) != 0 ? (0xEDB88320 ^ (c >> 1)) : c >> 1;
    }
    table[i] = c & 0xFFFFFFFF;
  }
  return table;
}

final _crc32Table = _buildCrc32Table();

/// CRC32 (IEEE, reflected) を計算する
int crc32(Uint8List data) {
  var crc = 0xFFFFFFFF;
  for (final b in data) {
    final idx = (crc ^ b) & 0xFF;
    crc = ((crc >> 8) ^ _crc32Table[idx]) & 0xFFFFFFFF;
  }
  return (crc ^ 0xFFFFFFFF) & 0xFFFFFFFF;
}

/// テキストを nBuckets 個のバケットにハッシュし、16進小文字文字列で返す
String Function(String) hash(int nBuckets) {
  return (text) {
    final bytes = Uint8List.fromList(utf8.encode(text));
    return (crc32(bytes) % nBuckets).toRadixString(16).toLowerCase();
  };
}