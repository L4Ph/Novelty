import 'package:flutter/widgets.dart';
import 'package:novelty/database/database.dart';
import 'package:novelty/database/database_maintenance.dart';
import 'package:novelty/providers/network_fallback_event_provider.dart';
import 'package:novelty/repositories/novel_repository.dart';
import 'package:novelty/repositories/preferences_repository.dart';
import 'package:novelty/services/api_service.dart';
import 'package:novelty/sites/novel_site.dart';
import 'package:novelty/sites/novel_source.dart';
import 'package:novelty/utils/settings_provider.dart';
import 'package:tiny_state/tiny_state.dart';

/// The long-lived services the widget tree reads from the [Scope].
///
/// The app root owns every instance. A new bundle is built when the database is
/// replaced, so widgets never hold a repository bound to a closed connection.
class AppServices {
  /// Creates the service bundle.
  const AppServices({
    required this.db,
    required this.api,
    required this.prefs,
    required this.settings,
    required this.repository,
    required this.maintenance,
    required this.fallback,
    required this.sites,
    required this.now,
  });

  /// The database.
  final AppDatabase db;

  /// The narou API client.
  final ApiService api;

  /// The key-value store behind the settings.
  final PreferencesRepository prefs;

  /// The settings, plus their change notifications.
  final SettingsController settings;

  /// The repository every screen writes through.
  final NovelRepository repository;

  /// Import/export state shared with the root overlay.
  final DatabaseMaintenanceController maintenance;

  /// Cache-fallback events shown as a snackbar.
  final NetworkFallbackBus fallback;

  /// Site implementations, keyed by source.
  final Map<NovelSource, NovelSite> sites;

  /// The clock. Results labelled by date take it from here so tests can pin it;
  /// recompute on each build rather than caching a timestamp.
  final DateTime Function() now;
}

/// Reads [AppServices] from the enclosing [Scope].
extension AppServicesContext on BuildContext {
  /// The services above this widget.
  AppServices get services => Scope.of(this).get<AppServices>();
}
