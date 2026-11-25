import 'package:flutter/foundation.dart';
import 'package:novelty/sites/novel_source.dart';
import 'package:novelty/utils/value_wrapper.dart';

/// ランキングのフィルタ状態を表すモデル。
@immutable
class RankingFilterState {
  /// コンストラクタ。
  const RankingFilterState({
    this.source = NovelSource.narou,
    this.showOnlyOngoing = false,
    this.selectedGenreId,
  });

  /// 提供サイト（プロバイダ）。
  final NovelSource source;

  /// 連載中の作品のみを表示するかどうか。
  final bool showOnlyOngoing;

  /// 選択されたジャンルID（サイト共通の文字列ID）。
  final String? selectedGenreId;

  /// フィールドを変更した新しいインスタンスを作成する
  RankingFilterState copyWith({
    NovelSource? source,
    bool? showOnlyOngoing,
    Value<String?>? selectedGenreId,
  }) {
    return RankingFilterState(
      source: source ?? this.source,
      showOnlyOngoing: showOnlyOngoing ?? this.showOnlyOngoing,
      selectedGenreId: selectedGenreId != null
          ? selectedGenreId.value
          : this.selectedGenreId,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RankingFilterState &&
          runtimeType == other.runtimeType &&
          source == other.source &&
          showOnlyOngoing == other.showOnlyOngoing &&
          selectedGenreId == other.selectedGenreId;

  @override
  int get hashCode => Object.hash(source, showOnlyOngoing, selectedGenreId);

  @override
  String toString() =>
      'RankingFilterState(source: $source, showOnlyOngoing: '
      '$showOnlyOngoing, selectedGenreId: $selectedGenreId)';
}

/// ランキングタイプごとのフィルタ状態を保持し、変更を購読者へ通知する。
///
/// ランキング画面が `(source, rankingType)` ごとに1つ生成して保持する。
class RankingFilterController extends ChangeNotifier {
  /// コンストラクタ。
  RankingFilterController({required NovelSource source})
    : _state = RankingFilterState(source: source);

  RankingFilterState _state;

  /// 現在のフィルタ状態。
  RankingFilterState get state => _state;

  void _setState(RankingFilterState next) {
    if (next == _state) return;
    _state = next;
    notifyListeners();
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
    _setState(RankingFilterState(source: _state.source));
  }
}
