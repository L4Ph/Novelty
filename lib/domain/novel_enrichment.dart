import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:novelty/database/database.dart';
import 'package:novelty/models/novel_info.dart';
import 'package:novelty/models/novel_search_query.dart';
import 'package:novelty/services/api_service.dart';
import 'package:novelty/sites/novel_source.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'novel_enrichment.g.dart';

/// APIデータとローカルライブラリの状態の両方を含む、充実した新規データ
class EnrichedNovelData {
  /// Constructor
  const EnrichedNovelData({
    required this.novel,
    required this.isInLibrary,
  });

  /// The novel data from API
  final NovelInfo novel;

  /// Whether the novel is in user's library
  final bool isInLibrary;

  /// 小説の画像URLを取得する。
  String get imageUrl {
    // ncodeから数字部分を抽出（なろう専用）
    final ncode = novel.ncode;
    if (ncode == null || ncode.length < 2) return '';
    final ncodeNumber = ncode.substring(1);
    return 'https://img.syosetu.com/image/$ncodeNumber.jpg';
  }
}

@riverpod
/// 検索結果をデータベースのライブラリ状態で強化するプロバイダー
Future<List<EnrichedNovelData>> enrichedSearchData(
  Ref ref,
  List<NovelInfo> searchResults,
) async {
  final db = ref.watch(appDatabaseProvider);

  // すべてのライブラリ小説を一度に取得して効率的に検索
  final libraryNovels = await db.getLibraryNovels();
  final libraryWorkIds = libraryNovels.map((novel) => novel.workId).toSet();

  // 検索結果の各小説をライブラリ状態で強化
  final enrichedData = searchResults.map((novel) {
    final isInLibrary = libraryWorkIds.contains(novel.workId);
    return EnrichedNovelData(
      novel: novel,
      isInLibrary: isInLibrary,
    );
  }).toList();

  return enrichedData;
}

/// 小説のライブラリ状態を取得するヘルパー関数
Future<bool> getNovelLibraryStatus(
  WidgetRef ref,
  NovelSource source,
  String workId,
) async {
  final db = ref.read(appDatabaseProvider);
  return db.isInLibrary(source, workId);
}

/// すべてのライブラリ小説の作品IDを取得するヘルパー関数
Future<Set<String>> getLibraryWorkIds(WidgetRef ref) async {
  final db = ref.read(appDatabaseProvider);
  final libraryNovels = await db.getLibraryNovels();
  return libraryNovels.map((novel) => novel.workId).toSet();
}

@riverpod
/// 作品IDから単一の豊富な小説データを取得するプロバイダー
Future<EnrichedNovelData> enrichedNovel(
  Ref ref,
  NovelSource source,
  String workId,
) async {
  final apiService = ref.watch(apiServiceProvider);
  final db = ref.watch(appDatabaseProvider);

  // APIから小説データを取得（P1時点ではなろうのみ対応）
  final query = NovelSearchQuery(ncode: [workId], lim: 1);
  final searchResult = await apiService.searchNovels(query);
  if (searchResult.novels.isEmpty) {
    throw Exception('Novel not found: $source $workId');
  }
  final novel = searchResult.novels.first;

  // ライブラリ状態を確認
  final isInLibrary = await db.isInLibrary(source, workId);

  return EnrichedNovelData(
    novel: novel,
    isInLibrary: isInLibrary,
  );
}
