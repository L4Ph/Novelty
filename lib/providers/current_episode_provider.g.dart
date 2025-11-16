// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'current_episode_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 現在のエピソード番号を管理するプロバイダー。

@ProviderFor(CurrentEpisode)
const currentEpisodeProvider = CurrentEpisodeProvider._();

/// 現在のエピソード番号を管理するプロバイダー。
final class CurrentEpisodeProvider
    extends $NotifierProvider<CurrentEpisode, int> {
  /// 現在のエピソード番号を管理するプロバイダー。
  const CurrentEpisodeProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'currentEpisodeProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$currentEpisodeHash();

  @$internal
  @override
  CurrentEpisode create() => CurrentEpisode();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<int>(value),
    );
  }
}

String _$currentEpisodeHash() => r'b524bb5851aa7661c96937fb4f8c96a303eded20';

/// 現在のエピソード番号を管理するプロバイダー。

abstract class _$CurrentEpisode extends $Notifier<int> {
  int build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<int, int>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<int, int>,
              int,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
