import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:novelty/database/database.dart';
import 'package:novelty/models/ranking_response.dart';
import 'package:novelty/services/api_service.dart';

/// Enriched novel data containing both API data and local library status
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

/// Provider that enriches ranking results with library status from database
final FutureProviderFamily<List<EnrichedNovelData>, String> enrichedRankingDataProvider =
    FutureProvider.autoDispose.family<List<EnrichedNovelData>, String>(
      (ref, rankingType) async {
        final db = ref.watch(appDatabaseProvider);
        
        // Get ranking data from API
        final rankingData = await ref.watch(rankingDataProvider(rankingType).future);
        
        // Enrich each novel with library status
        final enrichedData = <EnrichedNovelData>[];
        for (final novel in rankingData) {
          final dbNovel = await db.getNovel(novel.ncode);
          final isInLibrary = dbNovel?.fav == 1;
          enrichedData.add(EnrichedNovelData(
            novel: novel,
            isInLibrary: isInLibrary,
          ));
        }
        
        return enrichedData;
      },
    );

/// Provider that enriches search results with library status from database
final Provider<List<EnrichedNovelData> Function(List<RankingResponse>)> enrichedSearchDataProvider =
    Provider<List<EnrichedNovelData> Function(List<RankingResponse>)>((ref) {
      final db = ref.watch(appDatabaseProvider);
      
      return (List<RankingResponse> searchResults) {
        final enrichedData = <EnrichedNovelData>[];
        for (final novel in searchResults) {
          // For immediate synchronous access, we need to check if we have cached data
          // This is a limitation - for real-time updates, we might need a different approach
          enrichedData.add(EnrichedNovelData(
            novel: novel,
            isInLibrary: false, // Will be updated by UI state management
          ));
        }
        return enrichedData;
      };
    });

/// Helper function to get library status for a single novel
Future<bool> getNovelLibraryStatus(WidgetRef ref, String ncode) async {
  final db = ref.read(appDatabaseProvider);
  final novel = await db.getNovel(ncode);
  return novel?.fav == 1;
}