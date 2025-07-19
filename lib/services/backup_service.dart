import 'dart:convert';
import 'dart:io';

import 'package:drift/drift.dart';
import 'package:file_picker/file_picker.dart';
import 'package:novelty/database/database.dart';
import 'package:path/path.dart' as p;

/// バックアップ・復元サービス
/// ライブラリデータと履歴データのエクスポート・インポート機能を提供
class BackupService {
  /// コンストラクタ
  const BackupService(this._database);

  /// データベースインスタンス
  final AppDatabase _database;

  /// ライブラリデータをエクスポートする
  Future<Map<String, dynamic>> exportLibraryData() async {
    final libraryNovels = await (_database.select(_database.novels)
          ..where((t) => t.fav.equals(1)))
        .get();

    return {
      'version': '1.0',
      'exportedAt': DateTime.now().toIso8601String(),
      'data': libraryNovels.map(_novelToJson).toList(),
    };
  }

  /// 履歴データをエクスポートする
  Future<Map<String, dynamic>> exportHistoryData() async {
    final historyData = await _database.getHistory();

    return {
      'version': '1.0',
      'exportedAt': DateTime.now().toIso8601String(),
      'data': historyData.map(_historyToJson).toList(),
    };
  }

  /// ライブラリデータをインポートする
  Future<void> importLibraryData(Map<String, dynamic> jsonData) async {
    _validateVersion(jsonData);

    final novels = jsonData['data'] as List<dynamic>;

    for (final novelData in novels) {
      final novel = _jsonToNovelCompanion(novelData as Map<String, dynamic>);
      await _database.insertNovel(novel);
    }
  }

  /// 履歴データをインポートする
  Future<void> importHistoryData(Map<String, dynamic> jsonData) async {
    _validateVersion(jsonData);

    final histories = jsonData['data'] as List<dynamic>;

    for (final historyData in histories) {
      final history =
          _jsonToHistoryCompanion(historyData as Map<String, dynamic>);
      await _database.addToHistory(history);
    }
  }

  /// ライブラリデータをファイルにエクスポートする
  Future<String?> exportLibraryToFile() async {
    final String? selectedDirectory = await FilePicker.platform.getDirectoryPath(
      dialogTitle: 'バックアップ先のディレクトリを選択',
    );

    if (selectedDirectory == null) {
      return null;
    }

    final libraryData = await exportLibraryData();
    final fileName = 'novelty_library_${_formatDateTime(DateTime.now())}.json';
    final filePath = p.join(selectedDirectory, fileName);
    final file = File(filePath);

    await file.writeAsString(
      const JsonEncoder.withIndent('  ').convert(libraryData),
    );

    return filePath;
  }

  /// 履歴データをファイルにエクスポートする
  Future<String?> exportHistoryToFile() async {
    final String? selectedDirectory = await FilePicker.platform.getDirectoryPath(
      dialogTitle: 'バックアップ先のディレクトリを選択',
    );

    if (selectedDirectory == null) {
      return null;
    }

    final historyData = await exportHistoryData();
    final fileName = 'novelty_history_${_formatDateTime(DateTime.now())}.json';
    final filePath = p.join(selectedDirectory, fileName);
    final file = File(filePath);

    await file.writeAsString(
      const JsonEncoder.withIndent('  ').convert(historyData),
    );

    return filePath;
  }

  /// ライブラリデータをファイルからインポートする
  Future<int> importLibraryFromFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['json'],
      dialogTitle: 'ライブラリバックアップファイルを選択',
    );

    if (result == null || result.files.isEmpty) {
      return 0;
    }

    final file = File(result.files.single.path!);
    final jsonString = await file.readAsString();
    final jsonData = json.decode(jsonString) as Map<String, dynamic>;

    await importLibraryData(jsonData);

    final dataList = jsonData['data'] as List<dynamic>;
    return dataList.length;
  }

  /// 履歴データをファイルからインポートする
  Future<int> importHistoryFromFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['json'],
      dialogTitle: '履歴バックアップファイルを選択',
    );

    if (result == null || result.files.isEmpty) {
      return 0;
    }

    final file = File(result.files.single.path!);
    final jsonString = await file.readAsString();
    final jsonData = json.decode(jsonString) as Map<String, dynamic>;

    await importHistoryData(jsonData);

    final dataList = jsonData['data'] as List<dynamic>;
    return dataList.length;
  }

  /// NovelをJSONに変換する
  Map<String, dynamic> _novelToJson(Novel novel) {
    return {
      'ncode': novel.ncode,
      'title': novel.title,
      'writer': novel.writer,
      'story': novel.story,
      'novelType': novel.novelType,
      'end': novel.end,
      'isr15': novel.isr15,
      'isbl': novel.isbl,
      'isgl': novel.isgl,
      'iszankoku': novel.iszankoku,
      'istensei': novel.istensei,
      'istenni': novel.istenni,
      'keyword': novel.keyword,
      'generalFirstup': novel.generalFirstup,
      'generalLastup': novel.generalLastup,
      'globalPoint': novel.globalPoint,
      'fav': novel.fav,
      'reviewCount': novel.reviewCount,
      'rateCount': novel.rateCount,
      'allPoint': novel.allPoint,
      'pointCount': novel.pointCount,
      'dailyPoint': novel.dailyPoint,
      'weeklyPoint': novel.weeklyPoint,
      'monthlyPoint': novel.monthlyPoint,
      'quarterPoint': novel.quarterPoint,
      'yearlyPoint': novel.yearlyPoint,
      'generalAllNo': novel.generalAllNo,
      'novelUpdatedAt': novel.novelUpdatedAt,
      'cachedAt': novel.cachedAt,
    };
  }

  /// HistoryDataをJSONに変換する
  Map<String, dynamic> _historyToJson(HistoryData history) {
    return {
      'ncode': history.ncode,
      'title': history.title,
      'writer': history.writer,
      'lastEpisode': history.lastEpisode,
      'viewedAt': history.viewedAt,
    };
  }

  /// JSONからNovelsCompanionに変換する
  NovelsCompanion _jsonToNovelCompanion(Map<String, dynamic> json) {
    return NovelsCompanion(
      ncode: Value(json['ncode'] as String),
      title: Value(json['title'] as String?),
      writer: Value(json['writer'] as String?),
      story: Value(json['story'] as String?),
      novelType: Value(json['novelType'] as int?),
      end: Value(json['end'] as int?),
      isr15: Value(json['isr15'] as int?),
      isbl: Value(json['isbl'] as int?),
      isgl: Value(json['isgl'] as int?),
      iszankoku: Value(json['iszankoku'] as int?),
      istensei: Value(json['istensei'] as int?),
      istenni: Value(json['istenni'] as int?),
      keyword: Value(json['keyword'] as String?),
      generalFirstup: Value(json['generalFirstup'] as int?),
      generalLastup: Value(json['generalLastup'] as int?),
      globalPoint: Value(json['globalPoint'] as int?),
      fav: Value(json['fav'] as int? ?? 1), // インポート時は必ずライブラリに追加
      reviewCount: Value(json['reviewCount'] as int?),
      rateCount: Value(json['rateCount'] as int?),
      allPoint: Value(json['allPoint'] as int?),
      pointCount: Value(json['pointCount'] as int?),
      dailyPoint: Value(json['dailyPoint'] as int?),
      weeklyPoint: Value(json['weeklyPoint'] as int?),
      monthlyPoint: Value(json['monthlyPoint'] as int?),
      quarterPoint: Value(json['quarterPoint'] as int?),
      yearlyPoint: Value(json['yearlyPoint'] as int?),
      generalAllNo: Value(json['generalAllNo'] as int?),
      novelUpdatedAt: Value(json['novelUpdatedAt'] as String?),
      cachedAt: Value(json['cachedAt'] as int?),
    );
  }

  /// JSONからHistoryCompanionに変換する
  HistoryCompanion _jsonToHistoryCompanion(Map<String, dynamic> json) {
    return HistoryCompanion(
      ncode: Value(json['ncode'] as String),
      title: Value(json['title'] as String?),
      writer: Value(json['writer'] as String?),
      lastEpisode: Value(json['lastEpisode'] as int?),
      viewedAt: Value(json['viewedAt'] as int),
    );
  }

  /// バージョンの検証
  void _validateVersion(Map<String, dynamic> jsonData) {
    final version = jsonData['version'] as String?;
    if (version != '1.0') {
      throw Exception('サポートされていないバックアップファイルのバージョンです: $version');
    }
  }

  /// 日時をファイル名用にフォーマットする
  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.year}${dateTime.month.toString().padLeft(2, '0')}${dateTime.day.toString().padLeft(2, '0')}_${dateTime.hour.toString().padLeft(2, '0')}${dateTime.minute.toString().padLeft(2, '0')}${dateTime.second.toString().padLeft(2, '0')}';
  }
}
