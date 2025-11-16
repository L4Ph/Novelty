// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ranking_filter_state.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// ランキングタイプごとのフィルタ状態を管理するNotifier。

@ProviderFor(RankingFilterStateNotifier)
const rankingFilterStateProvider = RankingFilterStateNotifierFamily._();

/// ランキングタイプごとのフィルタ状態を管理するNotifier。
final class RankingFilterStateNotifierProvider
    extends $NotifierProvider<RankingFilterStateNotifier, RankingFilterState> {
  /// ランキングタイプごとのフィルタ状態を管理するNotifier。
  const RankingFilterStateNotifierProvider._({
    required RankingFilterStateNotifierFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'rankingFilterStateProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$rankingFilterStateNotifierHash();

  @override
  String toString() {
    return r'rankingFilterStateProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  RankingFilterStateNotifier create() => RankingFilterStateNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(RankingFilterState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<RankingFilterState>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is RankingFilterStateNotifierProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$rankingFilterStateNotifierHash() =>
    r'20f7773afb2ec492a0ab3e759b37787cb6ae5e2e';

/// ランキングタイプごとのフィルタ状態を管理するNotifier。

final class RankingFilterStateNotifierFamily extends $Family
    with
        $ClassFamilyOverride<
          RankingFilterStateNotifier,
          RankingFilterState,
          RankingFilterState,
          RankingFilterState,
          String
        > {
  const RankingFilterStateNotifierFamily._()
    : super(
        retry: null,
        name: r'rankingFilterStateProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// ランキングタイプごとのフィルタ状態を管理するNotifier。

  RankingFilterStateNotifierProvider call(String rankingType) =>
      RankingFilterStateNotifierProvider._(argument: rankingType, from: this);

  @override
  String toString() => r'rankingFilterStateProvider';
}

/// ランキングタイプごとのフィルタ状態を管理するNotifier。

abstract class _$RankingFilterStateNotifier
    extends $Notifier<RankingFilterState> {
  late final _$args = ref.$arg as String;
  String get rankingType => _$args;

  RankingFilterState build(String rankingType);
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build(_$args);
    final ref = this.ref as $Ref<RankingFilterState, RankingFilterState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<RankingFilterState, RankingFilterState>,
              RankingFilterState,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
