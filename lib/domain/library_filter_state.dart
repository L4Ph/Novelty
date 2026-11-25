import 'package:flutter/foundation.dart';
import 'package:novelty/sites/novel_source.dart';
import 'package:novelty/utils/value_wrapper.dart';

/// ライブラリのフィルタ状態を表すモデル。
@immutable
class LibraryFilterState {
  /// コンストラクタ。
  const LibraryFilterState({
    this.source,
    this.showOnlyOngoing = false,
    this.selectedGenreId,
  });

  /// 絞り込む提供サイト。null はすべてのサイト。
  final NovelSource? source;

  /// 連載中の作品のみを表示するかどうか。
  final bool showOnlyOngoing;

  /// 選択されたジャンルID（サイト共通の文字列ID）。
  final String? selectedGenreId;

  /// フィールドを変更した新しいインスタンスを作成する
  LibraryFilterState copyWith({
    Value<NovelSource?>? source,
    bool? showOnlyOngoing,
    Value<String?>? selectedGenreId,
  }) {
    return LibraryFilterState(
      source: source != null ? source.value : this.source,
      showOnlyOngoing: showOnlyOngoing ?? this.showOnlyOngoing,
      selectedGenreId: selectedGenreId != null
          ? selectedGenreId.value
          : this.selectedGenreId,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LibraryFilterState &&
          runtimeType == other.runtimeType &&
          source == other.source &&
          showOnlyOngoing == other.showOnlyOngoing &&
          selectedGenreId == other.selectedGenreId;

  @override
  int get hashCode => Object.hash(source, showOnlyOngoing, selectedGenreId);

  @override
  String toString() =>
      'LibraryFilterState(source: $source, showOnlyOngoing: '
      '$showOnlyOngoing, selectedGenreId: $selectedGenreId)';
}

/// ライブラリのフィルタ状態を保持し、変更を購読者へ通知する。
///
/// ライブラリ画面が1つ生成して保持する。
class LibraryFilterController extends ChangeNotifier {
  LibraryFilterState _state = const LibraryFilterState();

  /// 現在のフィルタ状態。
  LibraryFilterState get state => _state;

  void _setState(LibraryFilterState next) {
    if (next == _state) return;
    _state = next;
    notifyListeners();
  }

  /// サイト絞り込みフィルタを設定する。
  void setSource(NovelSource? source) {
    // サイトを切り替えたらジャンルフィルタはリセットする
    _setState(
      LibraryFilterState(
        source: source,
        showOnlyOngoing: _state.showOnlyOngoing,
      ),
    );
  }

  /// 連載中のみ表示フィルタを設定する。
  void setShowOnlyOngoing({required bool value}) {
    _setState(_state.copyWith(showOnlyOngoing: value));
  }

  /// ジャンルフィルタを設定する。
  void setSelectedGenreId(String? genreId) {
    _setState(
      _state.copyWith(
        selectedGenreId: genreId != null ? Value(genreId) : const Value(null),
      ),
    );
  }

  /// フィルタ状態をリセットする。
  void reset() {
    _setState(const LibraryFilterState());
  }
}
