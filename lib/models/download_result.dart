import 'package:flutter/foundation.dart';

/// The result of a download or delete operation.
///
/// Deliberately not `sealed`: the mocks generated for the repository implement
/// this type, which a sealed class forbids across libraries.
@immutable
abstract class DownloadResult {
  /// Creates a result.
  const DownloadResult();

  /// The operation succeeded.
  const factory DownloadResult.success({
    bool needsLibraryAddition,
  }) = DownloadResultSuccess;

  /// The user cancelled.
  const factory DownloadResult.cancelled() = DownloadResultCancelled;

  /// The operation failed with [message].
  const factory DownloadResult.error(String message) = DownloadResultError;
}

/// The operation succeeded.
@immutable
final class DownloadResultSuccess extends DownloadResult {
  /// Creates a success.
  const DownloadResultSuccess({this.needsLibraryAddition = false});

  /// Whether the work still has to be offered for the library.
  final bool needsLibraryAddition;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DownloadResultSuccess &&
          other.needsLibraryAddition == needsLibraryAddition;

  @override
  int get hashCode => needsLibraryAddition.hashCode;

  @override
  String toString() =>
      'DownloadResult.success(needsLibraryAddition: $needsLibraryAddition)';
}

/// The user cancelled.
@immutable
final class DownloadResultCancelled extends DownloadResult {
  /// Creates a cancellation.
  const DownloadResultCancelled();

  @override
  bool operator ==(Object other) => other is DownloadResultCancelled;

  @override
  int get hashCode => (DownloadResultCancelled).hashCode;

  @override
  String toString() => 'DownloadResult.cancelled()';
}

/// The operation failed.
@immutable
final class DownloadResultError extends DownloadResult {
  /// Creates a failure.
  const DownloadResultError(this.message);

  /// The failure message.
  final String message;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DownloadResultError && other.message == message;

  @override
  int get hashCode => message.hashCode;

  @override
  String toString() => 'DownloadResult.error($message)';
}
