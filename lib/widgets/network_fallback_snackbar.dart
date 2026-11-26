import 'dart:async';

import 'package:flutter/material.dart';
import 'package:novelty/app_services.dart';
import 'package:novelty/providers/network_fallback_event_provider.dart';

/// ネットワークフォールバックイベントを購読し、スナックバーで通知するラッパー。
///
/// キャッシュフォールバックが発生した際に、表示中のデータが最新でない可能性を
/// ユーザーに伝える。永続的なヘッダーは表示しない。
class NetworkFallbackSnackbar extends StatefulWidget {
  /// コンストラクタ。
  const NetworkFallbackSnackbar({
    required this.bus,
    required this.child,
    super.key,
  });

  /// Where events come from.
  final NetworkFallbackBus bus;

  /// ラップする子ウィジェット。
  final Widget child;

  @override
  State<NetworkFallbackSnackbar> createState() =>
      _NetworkFallbackSnackbarState();
}

class _NetworkFallbackSnackbarState extends State<NetworkFallbackSnackbar> {
  @override
  void initState() {
    super.initState();
    widget.bus.addListener(_onEvent);
  }

  @override
  void didUpdateWidget(NetworkFallbackSnackbar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!identical(oldWidget.bus, widget.bus)) {
      oldWidget.bus.removeListener(_onEvent);
      widget.bus.addListener(_onEvent);
    }
  }

  @override
  void dispose() {
    widget.bus.removeListener(_onEvent);
    super.dispose();
  }

  void _onEvent() {
    final event = widget.bus.event;
    if (event == null || !mounted) return;
    // Consume the event so it is shown once.
    widget.bus.clear();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(event.message),
        action: SnackBarAction(
          label: 'オフラインモードをオン',
          onPressed: () {
            if (!mounted) return;
            unawaited(
              context.services.settings.setIsOfflineMode(isOfflineMode: true),
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
