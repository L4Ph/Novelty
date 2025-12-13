import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'library_filter_state.freezed.dart';
part 'library_filter_state.g.dart';

/// ライブラリのフィルタ状態を表すモデル。
@freezed
abstract class LibraryFilterState with _$LibraryFilterState {
  /// コンストラクタ。
  const factory LibraryFilterState({
    /// 連載中の作品のみを表示するかどうか。
    @Default(false) bool showOnlyOngoing,

    /// 選択されたジャンル。
    int? selectedGenre,
  }) = _LibraryFilterState;
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
