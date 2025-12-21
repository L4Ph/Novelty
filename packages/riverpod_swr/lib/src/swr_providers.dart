import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:riverpod_swr/src/swr_client.dart';

part 'swr_providers.g.dart';

/// A provider that exposes the [SwrClient] instance.
///
/// This client manages the SWR state, including inflight requests,
/// caching, and deduplication.
@Riverpod(keepAlive: true)
SwrClient swrClient(Ref ref) {
  return SwrClient();
}

/// Returns whether a fetch is currently in progress for the given [key].
@riverpod
Stream<bool> swrLoading(Ref ref, String key) {
  final client = ref.watch(swrClientProvider);

  // Create a stream that:
  // 1. Emits the current loading state immediately.
  // 2. Listens for updates for THIS key.

  // Note: We use a generator to combine initial value and stream events.
  return Stream.multi((controller) {
    controller.add(client.isLoading(key));

    final subscription = client.loadingUpdates.listen((event) {
      if (event.$1 == key) {
        controller.add(event.$2);
      }
    });

    controller.onCancel = subscription.cancel;
  });
}
