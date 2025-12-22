import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/widgets.dart';
import 'package:riverpod_swr/src/swr_client.dart';

/// Manages SWR revalidation based on app lifecycle and connectivity.
class SwrRevalidationManager extends WidgetsBindingObserver {
  /// Creates a new [SwrRevalidationManager] for the given [client].
  SwrRevalidationManager(this.client);

  /// The [SwrClient] to revalidate.
  final SwrClient client;

  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;

  /// Initializes the revalidation manager.
  void init() {
    WidgetsBinding.instance.addObserver(this);

    _connectivitySubscription =
        Connectivity().onConnectivityChanged.listen((results) {
      if (results.any((r) => r != ConnectivityResult.none)) {
        client.revalidateAll();
      }
    });
  }

  /// Disposes the revalidation manager.
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    unawaited(_connectivitySubscription?.cancel());
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      client.revalidateAll();
    }
  }
}
