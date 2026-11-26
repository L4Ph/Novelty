import 'package:flutter/material.dart';
import 'package:novelty/app_services.dart';
import 'package:novelty/database/database.dart';
import 'package:novelty/models/novel_info_extension.dart';
import 'package:novelty/models/novel_search_query.dart';
import 'package:novelty/widgets/novel_list_tile.dart';

/// Library search screen.
class SearchPage extends StatefulWidget {
  /// Creates the page.
  const SearchPage({
    super.key,
    this.initialQuery,
  });

  /// The query the page opens with.
  final NovelSearchQuery? initialQuery;

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  late final TextEditingController _searchController;
  late NovelSearchQuery _query;
  Future<List<Novel>?>? _results;

  @override
  void initState() {
    super.initState();
    // Use the initial query as the starting text when it has a keyword.
    _searchController = TextEditingController(text: widget.initialQuery?.word);
    _query = widget.initialQuery ?? const NovelSearchQuery();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _results ??= _search(_query);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _updateQuery(NovelSearchQuery query) {
    setState(() {
      _query = query;
      _results = _search(query);
    });
  }

  Future<List<Novel>?> _search(NovelSearchQuery query) async {
    final db = context.services.db;

    // The modal can pass a full query with an empty keyword. DB search relies
    // on FTS and therefore needs a keyword, but filtering by genre alone has to
    // work too. Kept from the original page: use FTS when there is text, and
    // load the whole library when there are only filters.

    final searchText = query.word ?? '';

    var novels = <Novel>[];

    if (searchText.trim().isNotEmpty) {
      novels = await db.searchNovels(searchText);
    } else {
      // No keyword but other filters: show the whole library, then filter.
      // A bare page with no filters stays empty.

      final hasFilters = query != const NovelSearchQuery();
      if (hasFilters) {
        novels = await db.getLibraryNovels();
      } else {
        return null;
      }
    }

    // Filter in memory by the query.
    final filteredNovels = novels.where((novel) {
      final q = query;

      // Genre.
      if (q.genreId != null && q.genreId!.isNotEmpty) {
        // genre_id is a nullable String in the DB.
        if (novel.genreId == null || !q.genreId!.contains(novel.genreId)) {
          return false;
        }
      }

      // Novel type.
      if (q.type != null) {
        // novelType: 0 = short story, 1 = serialised.
        // end: 0 = short story or finished, 1 = ongoing.
        // Query type: t (short), r (ongoing), er (finished),
        // re (all serialised), ter (short + finished).
        final isShort = novel.novelType == 0; // short story
        // Serialised novels: end decides between ongoing (r) and finished (er).

        if (q.type == 't') {
          if (!isShort) return false;
        } else if (q.type == 'r') {
          if (isShort || novel.end != 1) return false;
        } else if (q.type == 'er') {
          if (isShort || novel.end != 0) return false;
        } else if (q.type == 're') {
          if (isShort) return false;
        } else if (q.type == 'ter') {
          // Short story or finished serialised story: the union of both.

          if (!isShort && novel.end != 0) return false;
        }
      }

      // Target fields (title, author, keyword) are not narrowed here: the FTS
      // query already searched them, and the narou API treats them as
      // "include in the search" rather than as strict field filters.
      return true;
    }).toList();

    // Ordering: the DB result follows the FTS rank (or the library's added-at
    // order), so the query's order is not applied. Sorting by
    // novelUpdatedAt/lastup is intentionally left out.
    return filteredNovels;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          // Autofocus only when the page is opened without a query.
          autofocus:
              widget.initialQuery?.word == null ||
              widget.initialQuery!.word!.isEmpty,
          decoration: const InputDecoration(
            hintText: 'ライブラリを検索...',
            border: InputBorder.none,
          ),
          onChanged: (value) => _updateQuery(_query.copyWith(word: value)),
        ),
        actions: [
          if (_query.word != null && _query.word!.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.clear),
              onPressed: () {
                _searchController.clear();
                _updateQuery(_query.copyWith(word: ''));
              },
            ),
        ],
      ),
      body:
          (_query.word == null || _query.word!.isEmpty) &&
              (widget.initialQuery == null ||
                  widget.initialQuery == const NovelSearchQuery())
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
          : FutureBuilder<List<Novel>?>(
              future: _results,
              builder: _buildResults,
            ),
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
        // Search results.
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
