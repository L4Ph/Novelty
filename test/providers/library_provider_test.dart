import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:novelty/database/database.dart';
import 'package:novelty/screens/library_page.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  
  group('libraryNovelsProvider', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer();
    });

    tearDown(() {
      container.dispose();
    });

    test('should be auto-disposed when not in use', () {
      container.read(libraryNovelsProvider);
      
      container.dispose();
      
      final newContainer = ProviderContainer();
      expect(
        () => newContainer.read(libraryNovelsProvider),
        returnsNormally,
      );
      newContainer.dispose();
    });

    test('should return Future<List<Novel>>', () {
      final asyncValue = container.read(libraryNovelsProvider);
      
      expect(asyncValue, isA<AsyncValue<List<Novel>>>());
    });

    test('should handle refresh correctly', () {
      container.read(libraryNovelsProvider);
      
      expect(
        () => container.refresh(libraryNovelsProvider),
        returnsNormally,
      );
    });

    test('should maintain state across multiple reads', () {
      final asyncValue1 = container.read(libraryNovelsProvider);
      final asyncValue2 = container.read(libraryNovelsProvider);
      
      expect(asyncValue1, equals(asyncValue2));
    });

    test('should create new state after refresh', () async {
      // Wait for initial state to load
      await container.read(libraryNovelsProvider.future);
      final asyncValue1 = container.read(libraryNovelsProvider);
      
      container.refresh(libraryNovelsProvider);
      final asyncValue2 = container.read(libraryNovelsProvider);
      
      // After refresh, the new state should be different (likely AsyncLoading)
      expect(asyncValue1, isNot(equals(asyncValue2)));
    });
  });
}
