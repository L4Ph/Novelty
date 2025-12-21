import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_swr/src/swr_client.dart';
import 'package:riverpod_swr/src/swr_options.dart';
import 'package:riverpod_swr/src/swr_providers.dart';

export 'src/swr_client.dart';
export 'src/swr_options.dart';
export 'src/swr_providers.dart';

/// SWR機能への便利なアクセスを提供する[Ref]の拡張。
extension RiverpodSwrRefX on Ref {
  /// [SwrClient]を使用してSWRクエリを実行します。
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
