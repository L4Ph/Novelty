import 'dart:async';

import 'package:tiny_state/tiny_state.dart';

/// Subscribes to a stream and keeps its latest value as [Async] state.
///
/// A page that needs several streams at once (novel info, episode pages,
/// download progress) holds one of these per stream instead of nesting
/// `StreamBuilder`s. Errors are reported through [onError] but the subscription
/// stays alive: the next event puts the state back to [AsyncData].
class AsyncSubscription<T> {
  /// Subscribes immediately.
  AsyncSubscription(this.stream, {this.onChanged, this.onError}) {
    _subscription = stream.listen(_onData, onError: _onFailure);
  }

  /// The source stream.
  final Stream<T> stream;

  /// Called after [state] changes, including on error.
  final void Function()? onChanged;

  /// Called with the error before the stream is allowed to continue.
  final void Function(Object error)? onError;

  /// The latest state. Starts as [AsyncLoading].
  Async<T> state = const AsyncLoading();

  late final StreamSubscription<T> _subscription;

  void _onData(T value) {
    state = AsyncData(value);
    onChanged?.call();
  }

  void _onFailure(Object error, StackTrace stackTrace) {
    state = AsyncError(error, stackTrace);
    onChanged?.call();
    onError?.call(error);
  }

  /// Stops listening.
  Future<void> cancel() => _subscription.cancel();
}
