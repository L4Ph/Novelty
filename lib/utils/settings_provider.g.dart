// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// アプリケーションの設定を提供するプロバイダー。

@ProviderFor(Settings)
final settingsProvider = SettingsProvider._();

/// アプリケーションの設定を提供するプロバイダー。
final class SettingsProvider
    extends $AsyncNotifierProvider<Settings, AppSettings> {
  /// アプリケーションの設定を提供するプロバイダー。
  SettingsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'settingsProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$settingsHash();

  @$internal
  @override
  Settings create() => Settings();
}

String _$settingsHash() => r'6ad7f26502d5118f307d8d6428d1e663499654cf';

/// アプリケーションの設定を提供するプロバイダー。

abstract class _$Settings extends $AsyncNotifier<AppSettings> {
  FutureOr<AppSettings> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<AppSettings>, AppSettings>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<AppSettings>, AppSettings>,
              AsyncValue<AppSettings>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

/// オフラインモードが有効かどうかを同期で取得するプロバイダー。
///
/// [settingsProvider] の値から派生し、取得中やエラー時は `false` を返す。

@ProviderFor(isOfflineMode)
final isOfflineModeProvider = IsOfflineModeProvider._();

/// オフラインモードが有効かどうかを同期で取得するプロバイダー。
///
/// [settingsProvider] の値から派生し、取得中やエラー時は `false` を返す。

final class IsOfflineModeProvider extends $FunctionalProvider<bool, bool, bool>
    with $Provider<bool> {
  /// オフラインモードが有効かどうかを同期で取得するプロバイダー。
  ///
  /// [settingsProvider] の値から派生し、取得中やエラー時は `false` を返す。
  IsOfflineModeProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'isOfflineModeProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$isOfflineModeHash();

  @$internal
  @override
  $ProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  bool create(Ref ref) {
    return isOfflineMode(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$isOfflineModeHash() => r'8e04cbaa3263f0ac8ac4d95c25045666e76b9c71';
