import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'library_filter_state.g.dart';

/// ライブラリのフィルタ状態を表すモデル。
@immutable
class LibraryFilterState {
  /// コンストラクタ。
  const LibraryFilterState({
    this.showOnlyOngoing = false,
    this.selectedGenre,
  });

  /// 連載中の作品のみを表示するかどうか。
  final bool showOnlyOngoing;

  /// 選択されたジャンル。
  final int? selectedGenre;

  /// フィールドを変更した新しいインスタンスを作成する
  LibraryFilterState copyWith({
    bool? showOnlyOngoing,
    int? selectedGenre,
  }) {
    return LibraryFilterState(
      showOnlyOngoing: showOnlyOngoing ?? this.showOnlyOngoing,
      selectedGenre: selectedGenre ?? this.selectedGenre,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LibraryFilterState &&
          runtimeType == other.runtimeType &&
          showOnlyOngoing == other.showOnlyOngoing &&
          selectedGenre == other.selectedGenre;

  @override
  int get hashCode => Object.hash(showOnlyOngoing, selectedGenre);

  @override
  String toString() =>
      'LibraryFilterState(showOnlyOngoing: $showOnlyOngoing, '
      'selectedGenre: $selectedGenre)';
}

/// ライブラリのフィルタ状態を管理するNotifier。
@riverpod
class LibraryFilterStateNotifier extends _$LibraryFilterStateNotifier {
  @override
  LibraryFilterState build() {
    return const LibraryFilterState();
  }

  /// 連載中のみ表示フィルタを設定する。
  void setShowOnlyOngoing({required bool value}) {
    state = state.copyWith(showOnlyOngoing: value);
  }

  /// ジャンルフィルタを設定する。
  void setSelectedGenre(int? genre) {
    state = state.copyWith(selectedGenre: genre);
  }

  /// フィルタ状態をリセットする。
  void reset() {
    state = const LibraryFilterState();
  }
}
