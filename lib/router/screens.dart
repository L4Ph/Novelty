import 'package:flutter/material.dart';
import 'package:novelty/router/destinations.dart';
import 'package:novelty/screens/about_page.dart';
import 'package:novelty/screens/author_novels_page.dart';
import 'package:novelty/screens/data_storage_page.dart';
import 'package:novelty/screens/download_manager_page.dart';
import 'package:novelty/screens/explore_page.dart';
import 'package:novelty/screens/history_page.dart';
import 'package:novelty/screens/library_page.dart';
import 'package:novelty/screens/more_page.dart';
import 'package:novelty/screens/novel_detail_page.dart';
import 'package:novelty/screens/novel_page.dart';
import 'package:novelty/screens/search_page.dart';
import 'package:novelty/screens/settings/appearance_settings_page.dart';
import 'package:novelty/screens/settings/reader_settings_page.dart';

/// Builds the screen for [destination].
///
/// The switch is exhaustive, so adding a destination without a screen here is
/// a compile error. This is the only place where destinations meet widgets,
/// which is what keeps the router free of screen types.
Widget screenFor(NovelDestination destination) => switch (destination) {
  LibraryDest() => const LibraryPage(),
  ExploreDest() => const ExplorePage(),
  HistoryDest() => const HistoryPage(),
  MoreDest() => const MorePage(),
  AppearanceSettingsDest() => const AppearanceSettingsPage(),
  ReaderSettingsDest() => const ReaderSettingsPage(),
  DataStorageDest() => const DataStoragePage(),
  AboutDest() => const AboutPage(),
  DownloadsDest() => const DownloadManagerPage(),
  SearchDest(:final query) => SearchPage(initialQuery: query),
  NovelDetailDest(:final source, :final workId) => NovelDetailPage(
    source: source,
    workId: workId,
  ),
  NovelEpisodeDest(
    :final source,
    :final workId,
    :final episode,
    :final revised,
  ) =>
    NovelPage(
      source: source,
      workId: workId,
      episode: episode,
      revised: revised,
    ),
  AuthorNovelsDest(:final userId) => AuthorNovelsPage(userId: userId),
};
