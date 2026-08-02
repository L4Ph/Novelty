// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ranking_filter_state.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// ランキングタイプごとのフィルタ状態を管理するNotifier。
///
/// familyキーは `(source, rankingType)`。

@ProviderFor(RankingFilterStateNotifier)
final rankingFilterStateProvider = RankingFilterStateNotifierFamily._();

/// ランキングタイプごとのフィルタ状態を管理するNotifier。
///
/// familyキーは `(source, rankingType)`。
final class RankingFilterStateNotifierProvider
    extends $NotifierProvider<RankingFilterStateNotifier, RankingFilterState> {
  /// ランキングタイプごとのフィルタ状態を管理するNotifier。
  ///
  /// familyキーは `(source, rankingType)`。
  RankingFilterStateNotifierProvider._({
    required RankingFilterStateNotifierFamily super.from,
    required (NovelSource, String) super.argument,
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
        '$argument';
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
    r'17eef1cb11a252286145b4597098e7143fa7a1c3';

/// ランキングタイプごとのフィルタ状態を管理するNotifier。
///
/// familyキーは `(source, rankingType)`。

final class RankingFilterStateNotifierFamily extends $Family
    with
        $ClassFamilyOverride<
          RankingFilterStateNotifier,
          RankingFilterState,
          RankingFilterState,
          RankingFilterState,
          (NovelSource, String)
        > {
  RankingFilterStateNotifierFamily._()
    : super(
        retry: null,
        name: r'rankingFilterStateProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// ランキングタイプごとのフィルタ状態を管理するNotifier。
  ///
  /// familyキーは `(source, rankingType)`。

  RankingFilterStateNotifierProvider call(
    NovelSource source,
    String rankingType,
  ) => RankingFilterStateNotifierProvider._(
    argument: (source, rankingType),
    from: this,
  );

  @override
  String toString() => r'rankingFilterStateProvider';
}

/// ランキングタイプごとのフィルタ状態を管理するNotifier。
///
/// familyキーは `(source, rankingType)`。

abstract class _$RankingFilterStateNotifier
    extends $Notifier<RankingFilterState> {
  late final _$args = ref.$arg as (NovelSource, String);
  NovelSource get source => _$args.$1;
  String get rankingType => _$args.$2;

  RankingFilterState build(NovelSource source, String rankingType);
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<RankingFilterState, RankingFilterState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<RankingFilterState, RankingFilterState>,
              RankingFilterState,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, () => build(_$args.$1, _$args.$2));
  }
}
