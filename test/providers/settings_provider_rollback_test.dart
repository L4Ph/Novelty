import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:novelty/repositories/preferences_repository.dart';
import 'package:novelty/utils/settings_provider.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'settings_provider_rollback_test.mocks.dart';

@GenerateMocks([PreferencesRepository])
/// path_providerのモック実装
class FakePathProviderPlatform extends Fake
    with MockPlatformInterfaceMixin
    implements PathProviderPlatform {
  @override
  Future<String?> getApplicationDocumentsPath() async {
    return '/mock/documents';
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Settings Provider ロールバック機構', () {
    late MockPreferencesRepository mockPrefsRepo;
    late ProviderContainer container;

    setUp(() {
      // path_providerのモック設定
      PathProviderPlatform.instance = FakePathProviderPlatform();
      mockPrefsRepo = MockPreferencesRepository();

      container = ProviderContainer(
        overrides: [
          preferencesRepositoryProvider.overrideWithValue(mockPrefsRepo),
        ],
      );
    });

    tearDown(() {
      container.dispose();
    });

    test('isRubyEnabled永続化失敗時、例外がスローされる', () async {
      // デフォルト値を設定
      when(mockPrefsRepo.getInt(any)).thenAnswer((_) async => null);
      when(mockPrefsRepo.getDouble(any)).thenAnswer((_) async => null);
      when(mockPrefsRepo.getString(any)).thenAnswer((_) async => null);
      when(mockPrefsRepo.getBool(any)).thenAnswer((_) async => null);

      // 初期状態をロード
      await container.read(settingsProvider.future);

      // isRubyEnabledの永続化を失敗させる
      when(
        mockPrefsRepo.setBool('is_ruby_enabled', false),
      ).thenAnswer((_) async => false);

      final settingsNotifier = container.read(settingsProvider.notifier);

      await expectLater(
        settingsNotifier.setIsRubyEnabled(isRubyEnabled: false),
        throwsException,
      );
    });

    test('lineHeight永続化失敗時、isRubyEnabledがロールバックされる', () async {
      // デフォルト値を設定
      when(mockPrefsRepo.getInt(any)).thenAnswer((_) async => null);
      when(mockPrefsRepo.getString(any)).thenAnswer((_) async => null);
      when(mockPrefsRepo.getBool(any)).thenAnswer((_) async => null);
      when(mockPrefsRepo.getDouble(any)).thenAnswer((_) async => null);

      // 初期値を設定: lineHeight=1.0, isRubyEnabled=false
      when(mockPrefsRepo.getDouble('line_height')).thenAnswer((_) async => 1.0);
      when(
        mockPrefsRepo.getBool('is_ruby_enabled'),
      ).thenAnswer((_) async => false);

      // 初期状態をロード
      await container.read(settingsProvider.future);

      // Phase 1: isRubyEnabledの永続化は成功
      when(
        mockPrefsRepo.setBool('is_ruby_enabled', true),
      ).thenAnswer((_) async => true);

      // Phase 2: lineHeightの永続化は失敗
      when(
        mockPrefsRepo.setDouble('line_height', 1.3),
      ).thenAnswer((_) async => false);

      // ロールバック: isRubyEnabledを元に戻す
      when(
        mockPrefsRepo.setBool('is_ruby_enabled', false),
      ).thenAnswer((_) async => true);

      final settingsNotifier = container.read(settingsProvider.notifier);

      await expectLater(
        settingsNotifier.setIsRubyEnabled(isRubyEnabled: true),
        throwsException,
      );

      // ロールバックが呼ばれたことを確認
      verify(mockPrefsRepo.setBool('is_ruby_enabled', false)).called(1);
    });

    test('ロールバック失敗時、クリティカルエラーがスローされる', () async {
      // デフォルト値を設定
      when(mockPrefsRepo.getInt(any)).thenAnswer((_) async => null);
      when(mockPrefsRepo.getString(any)).thenAnswer((_) async => null);
      when(mockPrefsRepo.getBool(any)).thenAnswer((_) async => null);
      when(mockPrefsRepo.getDouble(any)).thenAnswer((_) async => null);

      // 初期値を設定: lineHeight=1.0, isRubyEnabled=false
      when(mockPrefsRepo.getDouble('line_height')).thenAnswer((_) async => 1.0);
      when(
        mockPrefsRepo.getBool('is_ruby_enabled'),
      ).thenAnswer((_) async => false);

      // 初期状態をロード
      await container.read(settingsProvider.future);

      // Phase 1: isRubyEnabledの永続化は成功
      when(
        mockPrefsRepo.setBool('is_ruby_enabled', true),
      ).thenAnswer((_) async => true);

      // Phase 2: lineHeightの永続化は失敗
      when(
        mockPrefsRepo.setDouble('line_height', 1.3),
      ).thenAnswer((_) async => false);

      // ロールバック: isRubyEnabledを元に戻すのも失敗
      when(
        mockPrefsRepo.setBool('is_ruby_enabled', false),
      ).thenAnswer((_) async => false);

      final settingsNotifier = container.read(settingsProvider.notifier);

      await expectLater(
        settingsNotifier.setIsRubyEnabled(isRubyEnabled: true),
        throwsA(
          isA<Exception>().having(
            (e) => e.toString(),
            'message',
            contains('rollback'),
          ),
        ),
      );
    });

    test('行間自動調整が正常に動作する', () async {
      // デフォルト値を設定
      when(mockPrefsRepo.getInt(any)).thenAnswer((_) async => null);
      when(mockPrefsRepo.getString(any)).thenAnswer((_) async => null);
      when(mockPrefsRepo.getBool(any)).thenAnswer((_) async => null);
      when(mockPrefsRepo.getDouble(any)).thenAnswer((_) async => null);

      // 初期値を設定: lineHeight=1.0, isRubyEnabled=false
      when(mockPrefsRepo.getDouble('line_height')).thenAnswer((_) async => 1.0);
      when(
        mockPrefsRepo.getBool('is_ruby_enabled'),
      ).thenAnswer((_) async => false);

      // 初期状態をロード
      await container.read(settingsProvider.future);

      // Phase 1: isRubyEnabledの永続化は成功
      when(
        mockPrefsRepo.setBool('is_ruby_enabled', true),
      ).thenAnswer((_) async => true);

      // Phase 2: lineHeightの永続化は成功
      when(
        mockPrefsRepo.setDouble('line_height', 1.3),
      ).thenAnswer((_) async => true);

      final settingsNotifier = container.read(settingsProvider.notifier);
      await settingsNotifier.setIsRubyEnabled(isRubyEnabled: true);

      final asyncValue = container.read(settingsProvider);
      expect(asyncValue.hasValue, isTrue);
      final settings = asyncValue.value!;
      expect(settings.isRubyEnabled, isTrue);
      expect(settings.lineHeight, equals(1.3));

      // 永続化が呼ばれたことを確認
      verify(mockPrefsRepo.setBool('is_ruby_enabled', true)).called(1);
      verify(mockPrefsRepo.setDouble('line_height', 1.3)).called(1);
    });
  });
}
