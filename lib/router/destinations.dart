import 'package:flutter/foundation.dart';
import 'package:novelty/models/novel_search_query.dart';
import 'package:novelty/sites/novel_source.dart';

/// A screen the app can show.
///
/// These are plain values: they carry the screen's arguments with their real
/// types and nothing else. Building the widget from them, and deciding whether
/// a screen stacks inside a tab or over the whole shell, happens at the call
/// site — see `screens.dart` and `app_router.dart`.
///
/// Equality matters: the router keys pages by destination, so two screens with
/// equal arguments must be equal here or the page loses its state (and two of
/// them on one stack would collide).
@immutable
sealed class NovelDestination {
  /// Const constructor for subclasses.
  const NovelDestination();
}

/// The library tab.
@immutable
final class LibraryDest extends NovelDestination {
  /// Const constructor.
  const LibraryDest();

  @override
  bool operator ==(Object other) => other is LibraryDest;

  @override
  int get hashCode => runtimeType.hashCode;
}

/// The explore tab.
@immutable
final class ExploreDest extends NovelDestination {
  /// Const constructor.
  const ExploreDest();

  @override
  bool operator ==(Object other) => other is ExploreDest;

  @override
  int get hashCode => runtimeType.hashCode;
}

/// The history tab.
@immutable
final class HistoryDest extends NovelDestination {
  /// Const constructor.
  const HistoryDest();

  @override
  bool operator ==(Object other) => other is HistoryDest;

  @override
  int get hashCode => runtimeType.hashCode;
}

/// The "more" tab.
@immutable
final class MoreDest extends NovelDestination {
  /// Const constructor.
  const MoreDest();

  @override
  bool operator ==(Object other) => other is MoreDest;

  @override
  int get hashCode => runtimeType.hashCode;
}

/// Appearance settings.
@immutable
final class AppearanceSettingsDest extends NovelDestination {
  /// Const constructor.
  const AppearanceSettingsDest();

  @override
  bool operator ==(Object other) => other is AppearanceSettingsDest;

  @override
  int get hashCode => runtimeType.hashCode;
}

/// Reader settings.
@immutable
final class ReaderSettingsDest extends NovelDestination {
  /// Const constructor.
  const ReaderSettingsDest();

  @override
  bool operator ==(Object other) => other is ReaderSettingsDest;

  @override
  int get hashCode => runtimeType.hashCode;
}

/// Data storage settings.
@immutable
final class DataStorageDest extends NovelDestination {
  /// Const constructor.
  const DataStorageDest();

  @override
  bool operator ==(Object other) => other is DataStorageDest;

  @override
  int get hashCode => runtimeType.hashCode;
}

/// About screen.
@immutable
final class AboutDest extends NovelDestination {
  /// Const constructor.
  const AboutDest();

  @override
  bool operator ==(Object other) => other is AboutDest;

  @override
  int get hashCode => runtimeType.hashCode;
}

/// Download manager.
@immutable
final class DownloadsDest extends NovelDestination {
  /// Const constructor.
  const DownloadsDest();

  @override
  bool operator ==(Object other) => other is DownloadsDest;

  @override
  int get hashCode => runtimeType.hashCode;
}

/// Full-text search.
@immutable
final class SearchDest extends NovelDestination {
  /// Const constructor.
  const SearchDest({this.query});

  /// The query the screen opens with.
  final NovelSearchQuery? query;

  @override
  bool operator ==(Object other) => other is SearchDest && query == other.query;

  @override
  int get hashCode => (SearchDest, query).hashCode;
}

/// A novel's table of contents.
@immutable
final class NovelDetailDest extends NovelDestination {
  /// Const constructor.
  const NovelDetailDest({required this.source, required this.workId});

  /// The site the novel belongs to.
  final NovelSource source;

  /// Site-wide novel id.
  final String workId;

  @override
  bool operator ==(Object other) =>
      other is NovelDetailDest &&
      source == other.source &&
      workId == other.workId;

  @override
  int get hashCode => (NovelDetailDest, source, workId).hashCode;
}

/// A novel episode.
@immutable
final class NovelEpisodeDest extends NovelDestination {
  /// Const constructor.
  const NovelEpisodeDest({
    required this.source,
    required this.workId,
    required this.episode,
    this.revised,
  });

  /// The site the novel belongs to.
  final NovelSource source;

  /// Site-wide novel id.
  final String workId;

  /// Episode number, 1-based in table-of-contents order.
  final int episode;

  /// Revision timestamp the reader should prefer, when one was requested.
  final String? revised;

  @override
  bool operator ==(Object other) =>
      other is NovelEpisodeDest &&
      source == other.source &&
      workId == other.workId &&
      episode == other.episode &&
      revised == other.revised;

  @override
  int get hashCode =>
      (NovelEpisodeDest, source, workId, episode, revised).hashCode;
}

/// The novels of one author.
@immutable
final class AuthorNovelsDest extends NovelDestination {
  /// Const constructor.
  const AuthorNovelsDest({required this.userId});

  /// Author id on the site.
  final int userId;

  @override
  bool operator ==(Object other) =>
      other is AuthorNovelsDest && userId == other.userId;

  @override
  int get hashCode => (AuthorNovelsDest, userId).hashCode;
}
