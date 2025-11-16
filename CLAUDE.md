# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Novelty is a Flutter-based cross-platform novel viewer specifically designed for "Shōsetsuka ni Narō" (小説家になろう). It runs on iOS, Android, and desktop platforms (Windows/macOS/Linux).

**IMPORTANT**: All commit messages, Pull Request titles/descriptions, documentation, implementation comments, and reasoning should be written in Japanese.

## Essential Commands

### Install Dependencies
```bash
fvm flutter pub get
```

### Code Generation (Required after model/provider updates)
```bash
fvm dart run build_runner build -d
```

### Static Analysis (Lint)
```bash
fvm dart analyze
```
Fix info-level issues as needed. Always run before committing changes.

### Run Tests
```bash
# Run all tests
fvm flutter test

# Run a specific test file
fvm flutter test test/path/to/test_file.dart

# Run tests with coverage
fvm flutter test --coverage
```

### Run Application
```bash
fvm flutter run

# Run on a specific device
fvm flutter run -d <device-id>
```

## Architecture

### Layer Structure

**Multi-Layered Clean Architecture with Repository Pattern**

```
Presentation Layer (screens/, widgets/)
        ↓
State Management Layer (providers/)
        ↓
Repository Layer (repositories/)
        ↓ ↙
Service Layer (services/)  ←→  Database Layer (database/)
        ↓
External APIs / Local Storage
```

### Directory Structure

- `lib/database/` - Drift database definitions and DAOs
- `lib/models/` - Immutable models using Freezed
- `lib/providers/` - Riverpod providers (core of state management)
- `lib/repositories/` - Business logic (NovelRepository)
- `lib/services/` - External dependencies (ApiService, DatabaseService)
- `lib/screens/` - Screen components
- `lib/widgets/` - Reusable widgets
- `lib/router/` - GoRouter routing configuration
- `lib/utils/` - Utility functions
- `docs/` - Documentation for Narou API and HTML structure

### State Management (Riverpod)

**Provider Types and Usage**:

```dart
// Singleton service
final apiServiceProvider = Provider<ApiService>((ref) => ApiService());

// Async data fetching (with parameters, auto-dispose)
final novelInfoProvider = FutureProvider.autoDispose.family<NovelInfo, String>(
  (ref, ncode) async => ref.watch(apiServiceProvider).fetchNovelInfo(ncode),
);

// Real-time data monitoring
final historyProvider = StreamProvider.autoDispose<List<HistoryWithNovel>>(
  (ref) => ref.watch(appDatabaseProvider).watchHistory(),
);

// Complex state management (with methods)
final libraryStatusProvider = NotifierProvider<LibraryStatus, AsyncValue<bool>>(...);
```

**Key Providers**:
- `appDatabaseProvider` - Database singleton
- `apiServiceProvider` - API communication service
- `settingsProvider` - User preferences (font, font size, vertical reading)
- `enrichedNovelProvider` - Combines API data with library status
- `novelRepositoryProvider` - Novel operations and download progress management
- `historyProvider` - Reading history

**Provider Invalidation Pattern**:
When adding/removing from library, invalidate multiple providers to refresh UI:
```dart
ref..invalidate(libraryNovelsProvider)
   ..invalidate(enrichedRankingDataProvider('d'))
   ..invalidate(enrichedRankingDataProvider('w'));
```

### Database Layer (Drift)

**Schema (7 Tables)**:
1. **Novels** - Novel metadata cache
2. **LibraryNovels** - User's library registrations
3. **History** - Reading history (ncode, last episode, viewed timestamp)
4. **Episodes** - Episode content cache
5. **DownloadedEpisodes** - Downloaded episodes for offline reading
6. **DownloadedNovels** - Download progress tracking
7. **Bookmarks** - Position bookmarks (defined but unused)

**Important Design Patterns**:
- **Dual-Table Library Pattern**: Separates `Novels` (cache) and `LibraryNovels` (user library)
- **Custom Converter**: Serializes `List<NovelContentElement>` to/from JSON
- ncodes are always normalized to lowercase before storage
- Reactive data updates via Stream watching
- Efficient data handling through batch operations

**DAO Pattern Example**:
```dart
@DriftAccessor(tables: [LibraryNovels])
class LibraryNovelDao extends DatabaseAccessor<AppDatabase> {
  Future<void> addToLibrary(String ncode) =>
      into(libraryNovels).insert(LibraryNovel(ncode: ncode.toLowerCase()));
}
```

### API Integration

**ApiService Responsibilities**:

1. **Narou Novel API** (`api.syosetu.com/novelapi/api`)
   - Fetches novel metadata (gzip-compressed JSON)
   - Supports bulk fetching up to 20 novels at once

2. **Narou Ranking API** (`api.syosetu.com/rank/rankget/`)
   - Daily, weekly, monthly, quarterly, and all-time rankings
   - Returns rankings with points

3. **Web Scraping** (using html package)
   - Fetches episode listings from novel pages
   - Extracts episode content from ncode.syosetu.com
   - Handles pagination for multi-page episode lists

**Data Processing Features**:
- Gzip decompression using archive package
- HTML parsing and element selection
- Novel type inference (short story vs serialized) based on episode count

### Navigation Structure (GoRouter)

```
Root (StatefulShellRoute with 4 branches)
├── Library (/)
├── Explore (/explore)
├── History (/history)
└── More (/more)
    ├── Settings (/more/settings)
    ├── Data Storage (/more/data-storage)
    └── About (/more/about)

Modal Routes:
├── Novel Detail (/novel/:ncode)
└── Novel Reader (/novel/:ncode/:episode)
```

- Persistent branch state via indexed stack
- Parameter-based routing (ncode, episode numbers)
- Stateful shell routes that preserve navigation history

## Coding Conventions

### TDD (Test-Driven Development)

Implement new features using test-first approach:
1. Write a failing test first (Red)
2. Implement minimal code to make it pass (Green)
3. Refactor (Refactor)
4. Separate structural changes from behavioral changes in different commits

```dart
// Test names should clearly describe behavior (Japanese preferred)
test('ライブラリに小説を追加できる', () async {
  // Arrange
  final repository = NovelRepository();

  // Act
  await repository.addToLibrary('n1234');

  // Assert
  expect(await repository.isInLibrary('n1234'), isTrue);
});
```

### Freezed Model Definition

```dart
@freezed
class NovelInfo with _$NovelInfo {
  const factory NovelInfo({
    required String ncode,
    required String title,
    @Default([]) List<String> genres,
  }) = _NovelInfo;

  factory NovelInfo.fromJson(Map<String, dynamic> json) =>
      _$NovelInfoFromJson(json);
}
```

### HookConsumerWidget Usage

```dart
class NovelDetailPage extends HookConsumerWidget {
  const NovelDetailPage({required this.ncode, super.key});
  final String ncode;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final novelAsync = ref.watch(enrichedNovelProvider(ncode));

    return novelAsync.when(
      data: (novel) => /* UI */,
      loading: () => const CircularProgressIndicator(),
      error: (error, stack) => Text('Error: $error'),
    );
  }
}
```

### public_member_api_docs Compliance

Always add documentation comments to public APIs (classes/methods used externally):

```dart
/// Repository for managing novel information
class NovelRepository {
  /// Adds the novel with the specified ncode to the library
  Future<void> addToLibrary(String ncode) async {
    // implementation
  }
}
```

### Async Handling Best Practices

Use `unawaited` for Future calls where the return value is not used:

```dart
import 'dart:async';

void example() {
  // NG: discarded_futures warning
  someFuture();

  // OK
  unawaited(someFuture());

  // Or
  someFuture().ignore();
}
```

### Static Analysis Configuration

- Uses `very_good_analysis` package
- 80-character limit is ignored (`lines_longer_than_80_chars: ignore`)
- Generated files (`*.g.dart`, `*.freezed.dart`) and mocks (`**.mocks.dart`) are excluded from analysis

## Commit Conventions

### Commit Message Format (in Japanese)

- Feature: `✨ 新機能の説明`
- Bug fix: `🐛 修正内容の説明`
- Documentation: `📄 ドキュメント更新の説明`
- Refactoring: `♻️ リファクタリング内容の説明`
- Tests: `✅ テスト内容の説明`
- Configuration: `🔧 設定変更の説明`

### Commit Requirements

Only commit when ALL of the following are satisfied:
1. All tests pass
2. No errors from `fvm dart analyze`
3. Code generation has been run if needed
4. Structural changes and behavioral changes are in separate commits

## API Documentation

Documentation within the project:

### Narou Novel HTML Structure
- [Novel top page ({ncode})](./docs/narou_html/{ncode}.md)
- [Episode page ({ncode}/{episodes})](./docs/narou_html/{ncode}/{episodes}.md)

### Narou Novel API
- [Novel Information API](./docs/narou_api/novel_api.md)
- [Ranking API](./docs/narou_api/ranking_api.md)

## Development Workflow

### Pre-Commit Checklist

1. No lint errors from `fvm dart analyze`
2. All tests pass with `fvm flutter test`
3. Tests added for new features
4. Documentation comments added for public APIs
5. Code generation run if needed: `fvm dart run build_runner build -d`

## Technology Stack

- **Framework**: Flutter 3.8.1+ with Dart
- **State Management**: Riverpod (flutter_riverpod, hooks_riverpod)
- **Routing**: GoRouter
- **Database**: Drift (SQLite)
- **API Client**: Dio
- **Code Generation**: build_runner (freezed, json_annotation, riverpod_generator)
- **Testing**: flutter_test, mockito
- **Version Management**: FVM
- **Linting**: very_good_analysis, custom_lint, riverpod_lint

## Important Design Considerations

1. **All-Time Ranking**: Not available in the ranking API, so implemented using cumulative points from the search API
2. **History Recording Timing**: Recorded when opening novel content (not when viewing table of contents)
3. **Ncode Normalization**: Always converted to lowercase when storing in database
4. **Download Progress**: Real-time updates via StreamController, automatic cleanup on completion
5. **Content Enrichment**: Combines API data with local library status to reduce unnecessary API calls
