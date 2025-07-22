import 'dart:convert';
import 'dart:io';

import 'package:drift/drift.dart';
import 'package:file_picker/file_picker.dart';
import 'package:novelty/database/database.dart';
import 'package:novelty/models/novel_info.dart';
import 'package:path/path.dart' as p;

/// バックアップ・復元サービス
/// ライブラリデータと履歴データのエクスポート・インポート機能、
/// およびダウンロードフォルダからの復元機能を提供
class BackupService {
  /// コンストラクタ
  const BackupService(this._database);

  /// データベースインスタンス
  final AppDatabase _database;

  /// ライブラリデータをエクスポートする
  Future<Map<String, dynamic>> exportLibraryData() async {
    // LibraryNovelsテーブルからライブラリリストを取得
    final libraryNovels = await _database.getLibraryNovels();
    final novelsData = <Map<String, dynamic>>[];

    // 各ライブラリ小説の詳細情報を取得
    for (final libNovel in libraryNovels) {
      final novel = await _database.getNovel(libNovel.ncode);
      if (novel != null) {
        final novelData = _novelToJson(novel);
        novelData['addedAt'] = libNovel.addedAt; // ライブラリ追加日時を追加
        novelsData.add(novelData);
      }
    }

    return {
      'version': '2.0', // バージョンを2.0に更新（LibraryNovelsテーブル対応）
      'exportedAt': DateTime.now().toIso8601String(),
      'data': novelsData,
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

    final version = jsonData['version'] as String;
    final novels = jsonData['data'] as List<dynamic>;

    for (final novelData in novels) {
      final novelMap = novelData as Map<String, dynamic>;

      // 小説データをNovelsテーブルに保存（favは除外）
      final novel = _jsonToNovelCompanion(novelMap);
      await _database.insertNovel(novel);

      // ライブラリテーブルに追加
      int addedAt;
      if (version == '2.0') {
        // v2.0では addedAt フィールドを使用
        addedAt =
            novelMap['addedAt'] as int? ??
            DateTime.now().millisecondsSinceEpoch;
      } else {
        // v1.0では現在時刻を使用（下位互換性）
        addedAt = DateTime.now().millisecondsSinceEpoch;
      }

      await _database.addToLibrary(
        LibraryNovelsCompanion(
          ncode: Value(novelMap['ncode'] as String),
          addedAt: Value(addedAt),
        ),
      );
    }
  }

  /// 履歴データをインポートする
  Future<void> importHistoryData(Map<String, dynamic> jsonData) async {
    _validateVersion(jsonData);

    final histories = jsonData['data'] as List<dynamic>;

    for (final historyData in histories) {
      final history = _jsonToHistoryCompanion(
        historyData as Map<String, dynamic>,
      );
      await _database.addToHistory(history);
    }
  }

  /// ライブラリデータをファイルにエクスポートする
  Future<String?> exportLibraryToFile() async {
    final selectedDirectory = await FilePicker.platform.getDirectoryPath(
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
    final selectedDirectory = await FilePicker.platform.getDirectoryPath(
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
      // fav カラムは削除（LibraryNovelsテーブルで管理）
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
      // fav カラムは削除（LibraryNovelsテーブルで管理）
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
    if (version != '1.0' && version != '2.0') {
      throw Exception('サポートされていないバックアップファイルのバージョンです: $version');
    }
  }

  /// 日時をファイル名用にフォーマットする
  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.year}${dateTime.month.toString().padLeft(2, '0')}${dateTime.day.toString().padLeft(2, '0')}_${dateTime.hour.toString().padLeft(2, '0')}${dateTime.minute.toString().padLeft(2, '0')}${dateTime.second.toString().padLeft(2, '0')}';
  }

  /// ダウンロードフォルダからデータを復元する
  ///
  /// [downloadPath] ダウンロードフォルダのパス
  /// [addToLibrary] ライブラリに追加するかどうか
  ///
  /// 戻り値：復元された小説の数
  Future<int> restoreFromDownloadDirectory(
    String downloadPath, {
    required bool addToLibrary,
  }) async {
    final downloadDir = Directory(downloadPath);
    if (!await downloadDir.exists()) {
      return 0;
    }

    var restoredCount = 0;

    await for (final entity in downloadDir.list()) {
      if (entity is Directory) {
        final infoFile = File(p.join(entity.path, 'info.json'));
        if (await infoFile.exists()) {
          try {
            final jsonContent = await infoFile.readAsString();
            final jsonData = json.decode(jsonContent) as Map<String, dynamic>;
            final novelInfo = NovelInfo.fromJson(jsonData);

            if (novelInfo.ncode != null) {
              // 小説情報をNovelsテーブルに保存
              final novelCompanion = _novelInfoToNovelCompanion(novelInfo);
              await _database.insertNovel(novelCompanion);

              // ライブラリに追加するかどうかのフラグをチェック
              if (addToLibrary) {
                await _database.addToLibrary(
                  LibraryNovelsCompanion(
                    ncode: Value(novelInfo.ncode!.toLowerCase()),
                    title: Value(novelInfo.title),
                    writer: Value(novelInfo.writer),
                    story: Value(novelInfo.story),
                    novelType: Value(novelInfo.novelType),
                    end: Value(novelInfo.end),
                    generalAllNo: Value(novelInfo.generalAllNo),
                    novelUpdatedAt:
                        Value(novelInfo.novelupdatedAt?.toString()),
                    addedAt: Value(DateTime.now().millisecondsSinceEpoch),
                  ),
                );
              }

              restoredCount++;
            }
          } on Exception {
            // 無効なJSONファイルはスキップする
            continue;
          }
        }
      }
    }

    return restoredCount;
  }

  /// ダウンロードパスを検証する
  /// 
  /// [downloadPath] 検証するダウンロードフォルダのパス
  /// 
  /// 戻り値：検証結果
  Future<DownloadPathValidationResult> validateDownloadPath(String downloadPath) async {
    final downloadDir = Directory(downloadPath);
    if (!await downloadDir.exists()) {
      return const DownloadPathValidationResult(
        isValid: false,
        foundNovelsCount: 0,
        sampleNcodes: [],
      );
    }

    var foundCount = 0;
    final sampleNcodes = <String>[];

    await for (final entity in downloadDir.list()) {
      if (entity is Directory) {
        final infoFile = File(p.join(entity.path, 'info.json'));
        if (await infoFile.exists()) {
          try {
            final jsonContent = await infoFile.readAsString();
            final jsonData = json.decode(jsonContent) as Map<String, dynamic>;
            final ncode = jsonData['ncode'] as String?;
            
            if (ncode != null) {
              foundCount++;
              if (sampleNcodes.length < 3) {
                sampleNcodes.add(ncode);
              }
            }
          } on Exception {
            // 無効なJSONファイルはスキップ
            continue;
          }
        }
      }
    }

    return DownloadPathValidationResult(
      isValid: foundCount > 0,
      foundNovelsCount: foundCount,
      sampleNcodes: sampleNcodes,
    );
  }

  /// NovelInfoからNovelsCompanionに変換する
  NovelsCompanion _novelInfoToNovelCompanion(NovelInfo novelInfo) {
    return NovelsCompanion(
      ncode: Value(novelInfo.ncode!.toLowerCase()),
      title: Value(novelInfo.title),
      writer: Value(novelInfo.writer),
      story: Value(novelInfo.story),
      novelType: Value(novelInfo.novelType),
      end: Value(novelInfo.end),
      isr15: Value(novelInfo.isr15),
      isbl: Value(novelInfo.isbl),
      isgl: Value(novelInfo.isgl),
      iszankoku: Value(novelInfo.iszankoku),
      istensei: Value(novelInfo.istensei),
      istenni: Value(novelInfo.istenni),
      keyword: Value(novelInfo.keyword),
      generalFirstup: _parseToTimestamp(novelInfo.generalFirstup),
      generalLastup: _parseToTimestamp(novelInfo.generalLastup),
      globalPoint: Value(novelInfo.globalPoint),
      reviewCount: Value(novelInfo.reviewCnt),
      rateCount: Value(novelInfo.allHyokaCnt),
      allPoint: Value(novelInfo.allPoint),
      pointCount: Value(novelInfo.allPoint), // pointCountフィールドがないため、allPointで代用
      dailyPoint: Value(novelInfo.dailyPoint),
      weeklyPoint: Value(novelInfo.weeklyPoint),
      monthlyPoint: Value(novelInfo.monthlyPoint),
      quarterPoint: Value(novelInfo.quarterPoint),
      yearlyPoint: Value(novelInfo.yearlyPoint),
      generalAllNo: Value(novelInfo.generalAllNo),
      novelUpdatedAt: Value(novelInfo.novelupdatedAt?.toString()),
      cachedAt: Value(DateTime.now().millisecondsSinceEpoch),
    );
  }

  /// 日時文字列をタイムスタンプに変換する
  Value<int?> _parseToTimestamp(String? dateTimeStr) {
    if (dateTimeStr == null) return const Value(null);
    
    try {
      final dateTime = DateTime.parse(dateTimeStr.replaceAll(' ', 'T'));
      return Value(dateTime.millisecondsSinceEpoch);
    } on Exception {
      return const Value(null);
    }
  }
}

/// ダウンロードパスの検証結果
/// 
/// 確認ダイアログ用の情報を提供
class DownloadPathValidationResult {
  /// コンストラクタ
  const DownloadPathValidationResult({
    required this.isValid,
    required this.foundNovelsCount,
    required this.sampleNcodes,
  });

  /// パスが有効かどうか
  final bool isValid;

  /// 見つかった小説の数
  final int foundNovelsCount;

  /// サンプルのncode（最大3個）
  final List<String> sampleNcodes;
}
