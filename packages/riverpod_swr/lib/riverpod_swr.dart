library;

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:riverpod_swr/src/swr_client.dart';

export 'src/swr_client.dart';
export 'src/swr_client_infinite.dart';
export 'src/types.dart';

part 'riverpod_swr.g.dart';

/// [SwrClient] のシングルトンを提供するプロバイダー。
@Riverpod(keepAlive: true)
SwrClient swrClient(Ref ref) {
  return SwrClient();
}
