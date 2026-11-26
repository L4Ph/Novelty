import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:tiny_state/src/async_value.dart';
import 'package:tiny_state/src/cancel_token.dart';

/// Loads a value when [loadKey] changes, and only then.
///
/// The counterpart of Remix 3's "queue a task from render and guard it with the
/// prop value" pattern: the key is the guard, the token is the abort signal, and
/// a result that arrives after the key has moved on is dropped. The widget owns
/// the lifetime, so there is nothing to release by hand.
class KeyedLoader<T> extends StatefulWidget {
  /// Creates a loader.
  const KeyedLoader({
    required this.loadKey,
    required this.load,
    required this.builder,
    super.key,
  });

  /// The value whose change triggers a new load.
  ///
  /// A rebuild with an equal key does not reload, so pass a value that has
  /// stable equality — a record of ids, or a domain key — not a fresh object.
  final Object? loadKey;

  /// Starts the load. Check [CancelToken] before using an expensive result, or
  /// call [CancelToken.throwIfCancelled].
  final Future<T> Function(CancelToken token) load;

  /// Builds the widget for each state.
  final Widget Function(BuildContext context, Async<T> state) builder;

  @override
  State<KeyedLoader<T>> createState() => _KeyedLoaderState<T>();
}

class _KeyedLoaderState<T> extends State<KeyedLoader<T>> {
  Async<T> _state = AsyncLoading<T>();
  CancelToken? _token;
  var _started = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Started here rather than in initState so that [KeyedLoader.load] may read
    // inherited widgets (a Scope, a Theme) on its first line.
    if (_started) return;
    _started = true;
    _start(widget.loadKey);
  }

  @override
  void didUpdateWidget(covariant KeyedLoader<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.loadKey != oldWidget.loadKey) {
      setState(() => _state = AsyncLoading<T>());
      _start(widget.loadKey);
    }
  }

  @override
  void dispose() {
    _token?.cancel();
    _token = null;
    super.dispose();
  }

  void _start(Object? loadKey) {
    _token?.cancel();
    final token = CancelToken();
    _token = token;
    unawaited(_run(loadKey, token));
  }

  Future<void> _run(Object? loadKey, CancelToken token) async {
    try {
      final value = await widget.load(token);
      if (!mounted || token.isCancelled) {
        return;
      }
      setState(() => _state = AsyncData<T>(value));
    } on LoadCancelled {
      // The key moved on or the widget is gone; the newer load owns the state.
    } on Object catch (error, stackTrace) {
      if (!mounted || token.isCancelled) {
        return;
      }
      setState(() => _state = AsyncError<T>(error, stackTrace));
    }
  }

  @override
  Widget build(BuildContext context) => widget.builder(context, _state);
}
