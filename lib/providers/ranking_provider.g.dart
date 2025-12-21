// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ranking_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// ランキングのロジックを管理するNotifier

@ProviderFor(RankingNotifier)
const rankingProvider = RankingNotifierFamily._();

/// ランキングのロジックを管理するNotifier
final class RankingNotifierProvider
    extends $NotifierProvider<RankingNotifier, RankingState> {
  /// ランキングのロジックを管理するNotifier
  const RankingNotifierProvider._({
    required RankingNotifierFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'rankingProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  static const $allTransitiveDependencies0 = apiServiceProvider;
  static const $allTransitiveDependencies1 = rankingFilterStateProvider;

  @override
  String debugGetCreateSourceHash() => _$rankingNotifierHash();

  @override
  String toString() {
    return r'rankingProvider'
        ''
        '($argument)';
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

String _$rankingNotifierHash() => r'3b6a02c13d719683225b0b561b6f44f370694306';

/// ランキングのロジックを管理するNotifier

final class RankingNotifierFamily extends $Family
    with
        $ClassFamilyOverride<
          RankingNotifier,
          RankingState,
          RankingState,
          RankingState,
          String
        > {
  const RankingNotifierFamily._()
    : super(
        retry: null,
        name: r'rankingProvider',
        dependencies: const <ProviderOrFamily>[
          apiServiceProvider,
          rankingFilterStateProvider,
        ],
        $allTransitiveDependencies: const <ProviderOrFamily>[
          RankingNotifierProvider.$allTransitiveDependencies0,
          RankingNotifierProvider.$allTransitiveDependencies1,
        ],
        isAutoDispose: true,
      );

  /// ランキングのロジックを管理するNotifier

  RankingNotifierProvider call(String rankingType) =>
      RankingNotifierProvider._(argument: rankingType, from: this);

  @override
  String toString() => r'rankingProvider';
}

/// ランキングのロジックを管理するNotifier

abstract class _$RankingNotifier extends $Notifier<RankingState> {
  late final _$args = ref.$arg as String;
  String get rankingType => _$args;

  RankingState build(String rankingType);
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build(_$args);
    final ref = this.ref as $Ref<RankingState, RankingState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<RankingState, RankingState>,
              RankingState,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
