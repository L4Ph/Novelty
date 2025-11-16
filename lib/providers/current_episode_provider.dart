import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'current_episode_provider.g.dart';

@riverpod
/// 現在のエピソード番号を管理するプロバイダー。
class CurrentEpisode extends _$CurrentEpisode {
  @override
  int build() => 1;

  /// 現在のエピソード番号を設定するメソッド。
  void set(int value) => state = value;
}
