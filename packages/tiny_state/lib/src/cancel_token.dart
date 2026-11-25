import 'dart:async';

/// A cancellation signal for work tied to a widget's lifetime.
///
/// Mirrors what Remix 3 passes to a queued task: the loader hands one to the
/// work it starts, cancels it when the key changes or the widget goes away, and
/// the work is expected to check it before using a result.
class CancelToken {
  bool _cancelled = false;
  final List<void Function()> _listeners = <void Function()>[];

  /// Whether [cancel] has been called.
  bool get isCancelled => _cancelled;

  /// Registers a callback for when this token is cancelled.
  ///
  /// Runs immediately when the token is already cancelled.
  void onCancel(void Function() listener) {
    if (_cancelled) {
      listener();
      return;
    }
    _listeners.add(listener);
  }

  /// Cancels the work. Safe to call more than once.
  void cancel() {
    if (_cancelled) {
      return;
    }
    _cancelled = true;
    final listeners = List<void Function()>.of(_listeners);
    _listeners.clear();
    for (final listener in listeners) {
      listener();
    }
  }

  /// A future that completes when this token is cancelled.
  ///
  /// Useful to race work against cancellation with `Future.any`.
  Future<void> get whenCancelled {
    if (_cancelled) {
      return Future<void>.value();
    }
    final completer = Completer<void>();
    onCancel(completer.complete);
    return completer.future;
  }

  /// Throws when the work is no longer wanted.
  ///
  /// The loader catches this and ignores the result, so it is a way for deep
  /// work to bail out early without knowing about widgets.
  void throwIfCancelled() {
    if (_cancelled) {
      throw const LoadCancelled();
    }
  }
}

/// Thrown by [CancelToken.throwIfCancelled].
class LoadCancelled implements Exception {
  /// Creates the exception.
  const LoadCancelled();

  @override
  String toString() => 'LoadCancelled';
}
