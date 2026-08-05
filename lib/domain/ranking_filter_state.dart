import 'package:flutter/foundation.dart';
import 'package:novelty/sites/novel_source.dart';
import 'package:novelty/utils/value_wrapper.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'ranking_filter_state.g.dart';

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

/// ランキングタイプごとのフィルタ状態を管理するNotifier。
///
/// familyキーは `(source, rankingType)`。
@riverpod
class RankingFilterStateNotifier extends _$RankingFilterStateNotifier {
  @override
  RankingFilterState build(NovelSource source, String rankingType) {
    // 初期状態はフィルタなし
    return RankingFilterState(source: source);
  }

  /// 連載中のみ表示フィルタを設定する。
  void setShowOnlyOngoing({required bool value}) {
    state = state.copyWith(showOnlyOngoing: value);
  }

  /// ジャンルフィルタを設定する。
  void setSelectedGenreId(String? genreId) {
    state = state.copyWith(
      selectedGenreId: genreId != null ? Value(genreId) : const Value(null),
    );
  }

  /// フィルタ状態をリセットする。
  void reset() {
    state = RankingFilterState(source: state.source);
  }
}
