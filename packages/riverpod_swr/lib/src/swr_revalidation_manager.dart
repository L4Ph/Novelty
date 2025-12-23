import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/widgets.dart';
import 'package:riverpod_swr/src/swr_client.dart';

/// アプリのライフサイクルとネットワーク接続状況に基づき、SWRの再検証を管理するクラス。
class SwrRevalidationManager extends WidgetsBindingObserver {
  /// 指定された [client] に対して新しい [SwrRevalidationManager] を作成します。
  SwrRevalidationManager(this.client);

  /// 再検証の対象となる [SwrClient]。
  final SwrClient client;

  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;

  /// 再検証マネージャーを初期化します。
  void init() {
    WidgetsBinding.instance.addObserver(this);

    _connectivitySubscription =
        Connectivity().onConnectivityChanged.listen((results) {
      if (results.any((r) => r != ConnectivityResult.none)) {
        unawaited(client.revalidateAll());
      }
    });
  }

  /// 再検証マネージャーを破棄します。
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    unawaited(_connectivitySubscription?.cancel());
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      unawaited(client.revalidateAll());
    }
  }
}
