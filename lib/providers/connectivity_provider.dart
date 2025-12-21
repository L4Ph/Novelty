import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'connectivity_provider.g.dart';

/// ネットワーク接続状態を管理するクラス
@Riverpod(keepAlive: true)
class ConnectivityStatus extends _$ConnectivityStatus {
  @override
  Future<List<ConnectivityResult>> build() async {
    final subscription = Connectivity().onConnectivityChanged.listen((result) {
      state = AsyncValue.data(result);
    });
    ref.onDispose(subscription.cancel);

    return Connectivity().checkConnectivity();
  }
}

/// オフラインかどうかを判定するプロバイダー
@riverpod
bool isOffline(IsOfflineRef ref) {
  final status = ref.watch(connectivityStatusProvider);
  return status.maybeWhen(
    data: (result) => result.contains(ConnectivityResult.none),
    orElse: () => false,
  );
}
