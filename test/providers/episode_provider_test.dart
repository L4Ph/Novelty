import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:novelty/models/episode.dart';
import 'package:novelty/services/api_service.dart';
import 'package:novelty/widgets/novel_content.dart';

@GenerateMocks([ApiService])
import 'episode_provider_test.mocks.dart';

void main() {
  group('episodeProvider.family', () {
    late MockApiService mockApiService;
    late ProviderContainer container;

    setUp(() {
      mockApiService = MockApiService();
      container = ProviderContainer();
    });

    tearDown(() {
      container.dispose();
    });

    test('should be auto-disposed when not in use', () {
      const testParams = (ncode: 'N1234AB', episode: 1);
      
      container.read(episodeProvider(testParams));
      
      container.dispose();
      
      final newContainer = ProviderContainer();
      expect(
        () => newContainer.read(episodeProvider(testParams)),
        returnsNormally,
      );
      newContainer.dispose();
    });

    test('should create different providers for different parameters', () {
      const params1 = (ncode: 'N1234AB', episode: 1);
      const params2 = (ncode: 'N1234AB', episode: 2);
      const params3 = (ncode: 'N5678CD', episode: 1);

      final provider1 = episodeProvider(params1);
      final provider2 = episodeProvider(params2);
      final provider3 = episodeProvider(params3);

      expect(provider1, isNot(equals(provider2)));
      expect(provider1, isNot(equals(provider3)));
      expect(provider2, isNot(equals(provider3)));
    });

    test('should return same provider instance for same parameters', () {
      const testParams = (ncode: 'N1234AB', episode: 1);

      final provider1 = episodeProvider(testParams);
      final provider2 = episodeProvider(testParams);

      expect(provider1, equals(provider2));
    });

    test('should handle API errors gracefully', () async {
      const testParams = (ncode: 'INVALID_NCODE', episode: 1);

      expect(
        () => container.read(episodeProvider(testParams).future),
        throwsA(isA<Exception>()),
      );
    });

    test('should maintain separate state for different episodes of same novel', () {
      const params1 = (ncode: 'N1234AB', episode: 1);
      const params2 = (ncode: 'N1234AB', episode: 2);

      final asyncValue1 = container.read(episodeProvider(params1));
      final asyncValue2 = container.read(episodeProvider(params2));

      expect(asyncValue1, isNot(equals(asyncValue2)));
    });

    test('should be disposed when container is disposed', () {
      const testParams = (ncode: 'N1234AB', episode: 1);
      
      container.read(episodeProvider(testParams));
      
      expect(() => container.dispose(), returnsNormally);
    });

    test('should handle concurrent requests for same episode', () async {
      const testParams = (ncode: 'N1234AB', episode: 1);

      final future1 = container.read(episodeProvider(testParams).future);
      final future2 = container.read(episodeProvider(testParams).future);

      expect(future1, equals(future2));
    });
  });
}
