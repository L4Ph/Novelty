import 'dart:async';

import 'package:riverpod/riverpod.dart';
import 'package:riverpod_swr/src/swr_client.dart';
import 'package:riverpod_swr/src/types.dart';

/// Extension on [SwrClient] to support infinite (paginated) queries.
extension InfiniteSwrExtension on SwrClient {
  /// Watches an infinite (paginated) resource.
  /// [key] should be a base key for the collection.
  Stream<AsyncValue<List<T>>> watchInfinite<T>({
    required String key,
    required Future<List<T>> Function(int page) fetcher,
    int initialPage = 0,
    SwrOptions options = const SwrOptions(),
  }) {
    // This is a simplified implementation of infinite queries.
    // In a real-world scenario, we might want to track each page separately in the cache.
    // For now, we'll treat the whole list as a single resource.

    // We can use a composite key like 'infinite:$key'
    final compositeKey = 'infinite:$key';

    return watch<List<T>>(
      key: compositeKey,
      fetcher: () => fetcher(initialPage),
      options: options,
    );
  }
}
