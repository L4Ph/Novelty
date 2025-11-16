import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:novelty/database/database.dart';
import 'package:novelty/domain/ranking_filter_state.dart';
import 'package:novelty/models/novel_search_query.dart';
import 'package:novelty/models/ranking_response.dart';
import 'package:novelty/services/api_service.dart';
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
  final RankingResponse novel;

  /// Whether the novel is in user's library
  final bool isInLibrary;

  /// 小説の画像URLを取得する。
  String get imageUrl {
    // ncodeから数字部分を抽出
    final ncodeNumber = novel.ncode.substring(1);
    return 'https://img.syosetu.com/image/$ncodeNumber.jpg';
  }
}

@riverpod
/// 豊富な小説データをデータベースから取得するプロバイダー
Future<List<EnrichedNovelData>> enrichedRankingData(
  Ref ref,
  String rankingType,
) async {
  final db = ref.watch(appDatabaseProvider);

  // Get ranking data from API
  final rankingData = await ref.watch(
    rankingDataProvider(rankingType).future,
  );

  // Get all library novels at once for efficient lookup
  final libraryNovels = await db.getLibraryNovels();
  final libraryNcodes = libraryNovels.map((novel) => novel.ncode).toSet();

  // Enrich each novel with library status
  final enrichedData = rankingData.map((novel) {
    final isInLibrary = libraryNcodes.contains(novel.ncode);
    return EnrichedNovelData(
      novel: novel,
      isInLibrary: isInLibrary,
    );
  }).toList();

  return enrichedData;
}

@riverpod
/// 検索結果をデータベースのライブラリ状態で強化するプロバイダー
Future<List<EnrichedNovelData>> enrichedSearchData(
  Ref ref,
  List<RankingResponse> searchResults,
) async {
  final db = ref.watch(appDatabaseProvider);

  // すべてのライブラリ小説を一度に取得して効率的に検索
  final libraryNovels = await db.getLibraryNovels();
  final libraryNcodes = libraryNovels.map((novel) => novel.ncode).toSet();

  // 検索結果の各小説をライブラリ状態で強化
  final enrichedData = searchResults.map((novel) {
    final isInLibrary = libraryNcodes.contains(novel.ncode);
    return EnrichedNovelData(
      novel: novel,
      isInLibrary: isInLibrary,
    );
  }).toList();

  return enrichedData;
}

/// 小説のライブラリ状態を取得するヘルパー関数
Future<bool> getNovelLibraryStatus(WidgetRef ref, String ncode) async {
  final db = ref.read(appDatabaseProvider);
  return db.isInLibrary(ncode);
}

/// すべてのライブラリ小説のNコードを取得するヘルパー関数
Future<Set<String>> getLibraryNcodes(WidgetRef ref) async {
  final db = ref.read(appDatabaseProvider);
  final libraryNovels = await db.getLibraryNovels();
  return libraryNovels.map((novel) => novel.ncode).toSet();
}

@riverpod
/// ncodeから単一の豊富な小説データを取得するプロバイダー
Future<EnrichedNovelData> enrichedNovel(Ref ref, String ncode) async {
  final apiService = ref.watch(apiServiceProvider);
  final db = ref.watch(appDatabaseProvider);

  // APIから小説データを取得
  final query = NovelSearchQuery(ncode: [ncode], lim: 1);
  final searchResult = await apiService.searchNovels(query);
  if (searchResult.isEmpty) {
    throw Exception('Novel not found for ncode: $ncode');
  }
  final novel = searchResult.first;

  // ライブラリ状態を確認
  final isInLibrary = await db.isInLibrary(ncode);

  return EnrichedNovelData(
    novel: novel,
    isInLibrary: isInLibrary,
  );
}

@riverpod
/// フィルタリングされた豊富なランキングデータを取得するプロバイダー
Future<List<EnrichedNovelData>> filteredEnrichedRankingData(
  Ref ref,
  String rankingType,
) async {
  // 元のランキングデータを取得
  final enrichedData = await ref.watch(
    enrichedRankingDataProvider(rankingType).future,
  );

  // フィルタ状態を取得
  final filterState = ref.watch(
    rankingFilterStateProvider(rankingType),
  );

  // フィルタが設定されていない場合は元のデータをそのまま返す
  if (!filterState.showOnlyOngoing && filterState.selectedGenre == null) {
    return enrichedData;
  }

  // フィルタリングを適用
  var filtered = enrichedData;

  // 連載中フィルタ
  if (filterState.showOnlyOngoing) {
    filtered = filtered.where((enrichedNovel) {
      final novel = enrichedNovel.novel;
      // 詳細未読み込み（title == null）のアイテムはフィルタリング対象外
      // 詳細読み込み済みのアイテムのみフィルタ条件を適用
      return novel.title == null || novel.end == 1;
    }).toList();
  }

  // ジャンルフィルタ
  if (filterState.selectedGenre != null) {
    filtered = filtered.where((enrichedNovel) {
      final novel = enrichedNovel.novel;
      // 詳細未読み込み（title == null）のアイテムはフィルタリング対象外
      // 詳細読み込み済みのアイテムのみフィルタ条件を適用
      return novel.title == null || novel.genre == filterState.selectedGenre;
    }).toList();
  }

  return filtered;
}
