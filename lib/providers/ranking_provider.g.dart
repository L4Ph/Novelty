// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ranking_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// ランキングのロジックを管理するNotifier
///
/// familyキーは `(source, rankingType)`。

@ProviderFor(RankingNotifier)
final rankingProvider = RankingNotifierFamily._();

/// ランキングのロジックを管理するNotifier
///
/// familyキーは `(source, rankingType)`。
final class RankingNotifierProvider
    extends $NotifierProvider<RankingNotifier, RankingState> {
  /// ランキングのロジックを管理するNotifier
  ///
  /// familyキーは `(source, rankingType)`。
  RankingNotifierProvider._({
    required RankingNotifierFamily super.from,
    required (NovelSource, String) super.argument,
  }) : super(
         retry: null,
         name: r'rankingProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$rankingNotifierHash();

  @override
  String toString() {
    return r'rankingProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  RankingNotifier create() => RankingNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(RankingState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<RankingState>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is RankingNotifierProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$rankingNotifierHash() => r'9b84fa5e1a047f6be679980374c61aca14db8daf';

/// ランキングのロジックを管理するNotifier
///
/// familyキーは `(source, rankingType)`。

final class RankingNotifierFamily extends $Family
    with
        $ClassFamilyOverride<
          RankingNotifier,
          RankingState,
          RankingState,
          RankingState,
          (NovelSource, String)
        > {
  RankingNotifierFamily._()
    : super(
        retry: null,
        name: r'rankingProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// ランキングのロジックを管理するNotifier
  ///
  /// familyキーは `(source, rankingType)`。

  RankingNotifierProvider call(NovelSource source, String rankingType) =>
      RankingNotifierProvider._(argument: (source, rankingType), from: this);

  @override
  String toString() => r'rankingProvider';
}

/// ランキングのロジックを管理するNotifier
///
/// familyキーは `(source, rankingType)`。

abstract class _$RankingNotifier extends $Notifier<RankingState> {
  late final _$args = ref.$arg as (NovelSource, String);
  NovelSource get source => _$args.$1;
  String get rankingType => _$args.$2;

  RankingState build(NovelSource source, String rankingType);
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<RankingState, RankingState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<RankingState, RankingState>,
              RankingState,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, () => build(_$args.$1, _$args.$2));
  }
}
