import 'package:flutter/foundation.dart';

/// The state of something that is loaded asynchronously.
///
/// Three states, not four: a loader always starts by loading, so there is no
/// "idle" to represent, and no "reloading with the previous value" because a
/// key change starts over.
sealed class Async<T> {
  const Async();

  /// Folds the state into a value.
  R when<R>({
    required R Function() loading,
    required R Function(T value) data,
    required R Function(Object error, StackTrace stackTrace) error,
  }) {
    return switch (this) {
      AsyncLoading<T>() => loading(),
      AsyncData<T>(:final value) => data(value),
      AsyncError<T>(error: final failure, stackTrace: final trace) => error(
        failure,
        trace,
      ),
    };
  }

  /// The value when there is one.
  T? get valueOrNull => switch (this) {
    AsyncData<T>(:final value) => value,
    _ => null,
  };

  /// Whether a first result is still pending.
  bool get isLoading => this is AsyncLoading<T>;

  /// The error when the load failed.
  Object? get errorOrNull => switch (this) {
    AsyncError<T>(:final error) => error,
    _ => null,
  };
}

/// No result yet.
final class AsyncLoading<T> extends Async<T> {
  /// Creates a loading state.
  const AsyncLoading();
}

/// A result.
@immutable
final class AsyncData<T> extends Async<T> {
  /// Creates a data state.
  const AsyncData(this.value);

  /// The result.
  final T value;

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is AsyncData<T> && other.value == value;

  @override
  int get hashCode => value.hashCode;

  @override
  String toString() => 'AsyncData($value)';
}

/// A failure.
final class AsyncError<T> extends Async<T> {
  /// Creates an error state.
  const AsyncError(this.error, this.stackTrace);

  /// The failure.
  final Object error;

  /// Where it came from.
  final StackTrace stackTrace;

  @override
  String toString() => 'AsyncError($error)';
}
