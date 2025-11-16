import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'ranking_filter_state.freezed.dart';
part 'ranking_filter_state.g.dart';

/// ランキングのフィルタ状態を表すモデル。
@freezed
abstract class RankingFilterState with _$RankingFilterState {
  /// コンストラクタ。
  const factory RankingFilterState({
    /// 連載中の作品のみを表示するかどうか。
    @Default(false) bool showOnlyOngoing,

    /// 選択されたジャンル。
    int? selectedGenre,
  }) = _RankingFilterState;
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
