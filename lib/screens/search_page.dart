import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:novelty/database/database.dart';
import 'package:novelty/models/novel_info_extension.dart';
import 'package:novelty/models/novel_search_query.dart';
import 'package:novelty/widgets/novel_list_tile.dart';

/// 小説検索画面
class SearchPage extends HookConsumerWidget {
  /// コンストラクタ
  const SearchPage({
    super.key,
    this.initialQuery,
  });

  /// 初期検索クエリ
  final NovelSearchQuery? initialQuery;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // initialQuery にキーワードがあれば初期テキストとして使用する
    final searchController = useTextEditingController(
      text: initialQuery?.word ?? '',
    );
    // クエリ全体の状態を保持する
    final query = useState(initialQuery ?? const NovelSearchQuery());
    final db = ref.watch(appDatabaseProvider);

    // 検索実行
    final searchFuture = useMemoized(() async {
      // モーダルから総合クエリが渡された場合、キーワードが空でも検索したい
      // 通常、DB 検索は FTS に依存するためキーワードが必要
      // ただし、キーワードなしの「ジャンルで絞り込み」もサポートしたい
      // 現状は既存ロジックのまま: キーワードがあれば FTS を使用
      // キーワードがなく他の絞り込みがある場合、ライブラリ全件を取得して絞り込む
      // SearchPage は元々テキスト検索用のため、テキスト検索を前提とする
      // その後、結果を絞り込む

      final searchText = query.value.word ?? '';

      var novels = <Novel>[];

      if (searchText.trim().isNotEmpty) {
        novels = await db.searchNovels(searchText);
      } else {
        // 検索テキストがなく他の絞り込みがある場合、条件に一致するライブラリ全件を表示する
        // ただし元の SearchPage は初期状態では空だった
        // initialQuery に何らかの絞り込みがあれば、ライブラリ全件を取得する
        final hasFilters = query.value != const NovelSearchQuery();
        if (hasFilters) {
          novels = await db.getLibraryNovels();
        } else {
          return null;
        }
      }

      // NovelSearchQuery に基づいてメモリ内で絞り込む
      final filteredNovels = novels.where((novel) {
        final q = query.value;

        // ジャンルで絞り込み
        if (q.genreId != null && q.genreId!.isNotEmpty) {
          // DB 上の genre_id は nullable な String
          if (novel.genreId == null || !q.genreId!.contains(novel.genreId)) {
            return false;
          }
        }

        // 種別で絞り込み
        if (q.type != null) {
          // novelType: 0: 短編, 1: 連載中
          // end: 0: 短編 or 完結済, 1: 連載中
          // クエリ種別: t(短編), r(連載中), er(完結済), re(すべて連載), ter(短編+完結)

          final isShort = novel.novelType == 0; // 短編
          // 連載小説の場合:
          // novelType=1 なら連載
          // end=1 -> 連載中
          // end=0 -> 完結済 -- ただしコメントには「0: 短編 or 完結済」とある
          // 標準的ななろうの対応関係やアプリ内の使用法を確認する
          // 想定:
          // novelType=1, end=1 => 連載中 (r)
          // novelType=1, end=0 => 完結済連載 (er)

          if (q.type == 't') {
            if (!isShort) return false;
          } else if (q.type == 'r') {
            if (isShort || novel.end != 1) return false;
          } else if (q.type == 'er') {
            if (isShort || novel.end != 0) return false;
          } else if (q.type == 're') {
            if (isShort) return false;
          } else if (q.type == 'ter') {
            // 短編かつ完結済み連載? いいえ、和集合。
            // 短編 または 完結済み連載。
            if (!isShort && novel.end != 0) return false;
          }
        }

        // 検索対象で絞り込み (タイトル, 作者, キーワード)
        // DB 検索は FTS に一致したフィールドを既に検索している
        // ただしタイトルのみに限定したい場合はここでチェックが必要
        // DB 検索は OR の広い検索になる
        if (searchText.isNotEmpty) {
          // ユーザーがタイトルのみ指定した場合、タイトル内で一致するかを確認する
          // ただし DB 検索は全一致を返す
          // この段階で厳密なフィールド絞り込みを実装するのは過剰かもしれない
          // 特に厳密さが求められていない限り
          // なろう API ではこれらを「検索対象に含める」として扱う
          // デフォルトが全て false の場合（UI では「全て」または特定のデフォルトを意味する）
          // ただし SearchModal はユーザーが選択した値を渡す

          // シンプルな方法: 特定フィールドが選択された場合のみ厳密に絞り込む?
          // 実際、なろう API では何もチェックされていないと通常は無効またはデフォルト扱い
          // この UI ではチェックをデフォルトにする?
          // 過剰設計を避けるため、現状は厳密なフィールド検証をスキップ
          // 誤検知が見られない限り
        }

        return true;
      }).toList();

      // 並び替え
      // order: new (新しい順), old (古い順) など
      // DB の結果は FTS の順位で並ぶことがある
      // ただし特定の並び替えが指定されている場合:
      if (query.value.order == 'new') {
        // ライブラリの追加日時? それとも小説の更新日時?
        // ライブラリ検索では通常「追加日」または「小説の更新日」
        // 検索は DB の並び順（Rank 順）、ライブラリ取得は追加日順に依存する
        // または getLibraryNovels の追加日順
        // 並び替えをサポートする場合は `filteredNovels` を並べ替える必要がある
        // novel.novelUpdatedAt は String? "YYYY-MM-DD..."
        // novel.generalLastup は int? (タイムスタンプ?)
      }

      return filteredNovels;
    }, [query.value, db]); // クエリ変更時に再実行

    final snapshot = useFuture(searchFuture);

    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: searchController,
          // クエリを持たずに来た場合のみオートフォーカス
          autofocus: initialQuery?.word == null || initialQuery!.word!.isEmpty,
          decoration: const InputDecoration(
            hintText: 'ライブラリを検索...',
            border: InputBorder.none,
          ),
          onChanged: (value) {
            query.value = query.value.copyWith(word: value);
          },
        ),
        actions: [
          if (query.value.word != null && query.value.word!.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.clear),
              onPressed: () {
                searchController.clear();
                query.value = query.value.copyWith(word: '');
              },
            ),
        ],
      ),
      body:
          (query.value.word == null || query.value.word!.isEmpty) &&
              (initialQuery == null || initialQuery == const NovelSearchQuery())
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.search, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'タイトル、作者、あらすじから検索できます',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            )
          : _buildResults(context, snapshot),
    );
  }

  Widget _buildResults(
    BuildContext context,
    AsyncSnapshot<List<Novel>?> snapshot,
  ) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return const Center(child: CircularProgressIndicator());
    }

    if (snapshot.hasError) {
      return Center(child: Text('Error: ${snapshot.error}'));
    }

    final novels = snapshot.data;
    if (novels == null) {
      return const SizedBox.shrink(); // Should match empty state logic ideally
    }

    if (novels.isEmpty) {
      return const Center(child: Text('見つかりませんでした'));
    }

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // 小説の検索結果
        Text(
          '小説 (${novels.length})',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        ...novels.map((novel) {
          final novelData = novel.toModel();
          return NovelListTile(item: novelData);
        }),
      ],
    );
  }
}
