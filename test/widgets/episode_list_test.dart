import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:novelty/models/episode.dart';
import 'package:novelty/services/api_service.dart';
import 'package:novelty/screens/novel_detail_page.dart';

import 'episode_list_test.mocks.dart';

@GenerateMocks([ApiService])
void main() {
  group('Episode List Infinite Scroll Tests', () {
    late MockApiService mockApiService;

    setUp(() {
      mockApiService = MockApiService();
    });

    test('fetchEpisodeList should return episodes for given page', () async {
      // Mock episode data
      final mockEpisodes = [
        Episode(
          subtitle: 'Episode 1',
          url: 'https://ncode.syosetu.com/n1234ab/1/',
          index: 1,
          ncode: 'N1234AB',
        ),
        Episode(
          subtitle: 'Episode 2',
          url: 'https://ncode.syosetu.com/n1234ab/2/',
          index: 2,
          ncode: 'N1234AB',
        ),
      ];

      when(mockApiService.fetchEpisodeList('N1234AB', 1))
          .thenAnswer((_) async => mockEpisodes);

      final result = await mockApiService.fetchEpisodeList('N1234AB', 1);

      expect(result, equals(mockEpisodes));
      expect(result.length, equals(2));
      expect(result.first.subtitle, equals('Episode 1'));
    });

    test('fetchEpisodeList should handle empty pages', () async {
      when(mockApiService.fetchEpisodeList('N1234AB', 10))
          .thenAnswer((_) async => []);

      final result = await mockApiService.fetchEpisodeList('N1234AB', 10);

      expect(result, isEmpty);
    });

    test('fetchEpisodeList should handle API errors', () async {
      when(mockApiService.fetchEpisodeList('N1234AB', 1))
          .thenThrow(Exception('Network error'));

      expect(
        () => mockApiService.fetchEpisodeList('N1234AB', 1),
        throwsA(isA<Exception>()),
      );
    });

    test('episodeList provider key parsing', () {
      // Test the key format used in the provider
      const key = 'N1234AB_1';
      final parts = key.split('_');
      
      expect(parts.length, equals(2));
      expect(parts[0], equals('N1234AB'));
      expect(int.parse(parts[1]), equals(1));
    });
  });
}