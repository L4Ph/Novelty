import 'package:drift/drift.dart' as drift;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:novelty/database/database.dart';
import 'package:novelty/models/novel_info.dart';
import 'package:novelty/providers/enriched_novel_provider.dart';
import 'package:novelty/screens/library_page.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'library_status_provider.g.dart';

@riverpod
/// 小説のライブラリ状態を管理するプロバイダー。
class LibraryStatus extends _$LibraryStatus {
  @override
  Stream<bool> build(String ncode) {
    final db = ref.watch(appDatabaseProvider);
    return db.watchIsInLibrary(ncode);
  }

  /// ライブラリの状態をトグルするメソッド。
  Future<void> toggle(NovelInfo novelInfo) async {
    final db = ref.read(appDatabaseProvider);
    final isInLibrary = state.value ?? false;
    final newStatus = !isInLibrary;

    state = const AsyncValue.loading();
    try {
      if (newStatus) {
        final entry = LibraryNovelsCompanion(
          ncode: drift.Value(novelInfo.ncode!),
          title: drift.Value(novelInfo.title),
          writer: drift.Value(novelInfo.writer),
          story: drift.Value(novelInfo.story),
          novelType: drift.Value(novelInfo.novelType),
          end: drift.Value(novelInfo.end),
          generalAllNo: drift.Value(novelInfo.generalAllNo),
          novelUpdatedAt: drift.Value(novelInfo.novelupdatedAt?.toString()),
          addedAt: drift.Value(DateTime.now().millisecondsSinceEpoch),
        );
        await db.addToLibrary(entry);
      } else {
        await db.removeFromLibrary(novelInfo.ncode!);
      }

      ref
        ..invalidate(libraryNovelsProvider)
        ..invalidate(enrichedRankingDataProvider('d'))
        ..invalidate(enrichedRankingDataProvider('w'))
        ..invalidate(enrichedRankingDataProvider('m'))
        ..invalidate(enrichedRankingDataProvider('q'))
        ..invalidate(enrichedRankingDataProvider('all'));
    } on Exception catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}
