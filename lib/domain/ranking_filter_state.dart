import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'ranking_filter_state.g.dart';

/// ランキングのフィルタ状態を表すモデル。
@immutable
class RankingFilterState {
  /// コンストラクタ。
  const RankingFilterState({
    this.showOnlyOngoing = false,
    this.selectedGenre,
  });

  /// 連載中の作品のみを表示するかどうか。
  final bool showOnlyOngoing;

  /// 選択されたジャンル。
  final int? selectedGenre;

  /// フィールドを変更した新しいインスタンスを作成する
  RankingFilterState copyWith({
    bool? showOnlyOngoing,
    int? selectedGenre,
  }) {
    return RankingFilterState(
      showOnlyOngoing: showOnlyOngoing ?? this.showOnlyOngoing,
      selectedGenre: selectedGenre ?? this.selectedGenre,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RankingFilterState &&
          runtimeType == other.runtimeType &&
          showOnlyOngoing == other.showOnlyOngoing &&
          selectedGenre == other.selectedGenre;

  @override
  int get hashCode => Object.hash(showOnlyOngoing, selectedGenre);

  @override
  String toString() =>
      'RankingFilterState(showOnlyOngoing: $showOnlyOngoing, '
      'selectedGenre: $selectedGenre)';
}

/// ランキングタイプごとのフィルタ状態を管理するNotifier。
@riverpod
class RankingFilterStateNotifier extends _$RankingFilterStateNotifier {
  @override
  RankingFilterState build(String rankingType) {
    // 初期状態はフィルタなし
    return const RankingFilterState();
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
    state = const RankingFilterState();
  }
}
