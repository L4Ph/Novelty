import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:novelty/database/database.dart';
import 'package:novelty/models/ranking_response.dart';
import 'package:novelty/services/api_service.dart';
import 'package:riverpod/src/providers/future_provider.dart';

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
}

/// 豊富な小説データをデータベースから取得するプロバイダー
final FutureProviderFamily<List<EnrichedNovelData>, String>
enrichedRankingDataProvider = FutureProvider.autoDispose
    .family<List<EnrichedNovelData>, String>(
      (ref, rankingType) async {
        final db = ref.watch(appDatabaseProvider);

        // Get ranking data from API
        final rankingData = await ref.watch(
          rankingDataProvider(rankingType).future,
        );

        // Get all library novels at once for efficient lookup
        final libraryNovels = await (db.select(
          db.novels,
        )..where((tbl) => tbl.fav.equals(1))).get();
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
      },
    );

/// 検索結果をデータベースのライブラリ状態で強化するプロバイダー
final Provider<List<EnrichedNovelData> Function(List<RankingResponse>)>
enrichedSearchDataProvider =
    Provider<List<EnrichedNovelData> Function(List<RankingResponse>)>((ref) {
      final _ = ref.watch(appDatabaseProvider);

      return (List<RankingResponse> searchResults) {
        final enrichedData = <EnrichedNovelData>[];
        for (final novel in searchResults) {
          // For immediate synchronous access, we need to check if we have cached data
          // This is a limitation - for real-time updates, we might need a different approach
          enrichedData.add(
            EnrichedNovelData(
              novel: novel,
              isInLibrary: false, // Will be updated by UI state management
            ),
          );
        }
        return enrichedData;
      };
    });

/// 小説のライブラリ状態を取得するヘルパー関数
Future<bool> getNovelLibraryStatus(WidgetRef ref, String ncode) async {
  final db = ref.read(appDatabaseProvider);
  final novel = await db.getNovel(ncode);
  return novel?.fav == 1;
}

/// すべてのライブラリ小説のNコードを取得するヘルパー関数
Future<Set<String>> getLibraryNcodes(WidgetRef ref) async {
  final db = ref.read(appDatabaseProvider);
  final libraryNovels = await (db.select(
    db.novels,
  )..where((tbl) => tbl.fav.equals(1))).get();
  return libraryNovels.map((novel) => novel.ncode).toSet();
}
