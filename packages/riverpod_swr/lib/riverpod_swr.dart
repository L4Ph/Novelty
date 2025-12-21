// We might want to keep the extension method but redirect it to use SwrClient?
// Or we can provide a new convenience extension.
import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_swr/src/swr_client.dart';
import 'package:riverpod_swr/src/swr_options.dart';
import 'package:riverpod_swr/src/swr_providers.dart';

// We should probably remove the old Config if we are breaking changes.
// The implementation plan implies a redesign.
// Let's export the new stuff.

export 'src/swr_client.dart';
// export 'src/swr_config.dart'; // Removed as file does not exist
export 'src/swr_options.dart';
export 'src/swr_providers.dart';

/// Extension on [Ref] to provide convenient access to SWR functionality.
extension RiverpodSwrRefX on Ref {
  /// Executes an SWR query using the [SwrClient].
  Stream<T> swr<T>({
    required String key,
    required Stream<T> Function() watch,
    required Future<T> Function() fetch,
    required Future<void> Function(T) persist,
    SwrOptions options = const SwrOptions(),
  }) {
    return read<SwrClient>(swrClientProvider).validate<T>(
      key: key,
      watch: watch,
      fetch: fetch,
      persist: persist,
      options: options,
    );
  }
}
