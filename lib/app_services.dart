import 'package:novelty/database/database.dart';

/// The services the widget tree reads from the `Scope`.
///
/// Only what migrated screens need; the API client joins when the first screen
/// that calls it moves over.
///
/// During the migration this is filled from riverpod; once riverpod is gone the
/// app root will own the instances and provide them here.
class AppServices {
  /// Creates the service bundle.
  const AppServices({
    required this.db,
    required this.now,
  });

  /// The database.
  final AppDatabase db;

  /// The clock. Pages that label results by date take it from here so tests can
  /// pin it; recompute on each build rather than caching a timestamp.
  final DateTime Function() now;
}
