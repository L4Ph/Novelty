import 'package:flutter/material.dart';
import 'package:novelty/app_services.dart';
import 'package:novelty/database/database.dart';
import 'package:novelty/database/database_maintenance.dart';
import 'package:novelty/providers/network_fallback_event_provider.dart';
import 'package:novelty/repositories/novel_repository.dart';
import 'package:novelty/repositories/preferences_repository.dart';
import 'package:novelty/services/api_service.dart';
import 'package:novelty/sites/novel_site.dart';
import 'package:novelty/sites/novel_site_registry.dart';
import 'package:novelty/sites/novel_source.dart';
import 'package:novelty/utils/settings_provider.dart';
import 'package:tiny_state/tiny_state.dart';

/// Settings every test starts from; override per test when the values matter.
const testSettings = AppSettings(
  themeMode: ThemeMode.system,
  fontSize: 16,
  lineHeight: 1.5,
  isVertical: false,
  isIncognito: false,
  isPageFlip: false,
  isRubyEnabled: true,
);

/// Settings with offline mode enabled.
const offlineTestSettings = AppSettings(
  themeMode: ThemeMode.system,
  fontSize: 16,
  lineHeight: 1.5,
  isVertical: false,
  isIncognito: false,
  isPageFlip: false,
  isRubyEnabled: true,
  isOfflineMode: true,
);

/// Builds an [AppServices] bundle for widget tests.
///
/// Settings are already loaded so pages do not have to await anything, and the
/// repository is built on [db] so page actions hit the same test database.
AppServices buildTestServices({
  required AppDatabase db,
  AppSettings settings = testSettings,
  ApiService? api,
  Map<NovelSource, NovelSite>? sites,
  DateTime Function()? now,
  DatabaseMaintenanceController? maintenance,
  NetworkFallbackBus? fallback,
  NovelRepository? repository,
}) {
  final resolvedSites = sites ?? defaultNovelSiteRegistry;
  final apiService = api ?? ApiService();
  final controller = SettingsController(
    PreferencesRepository(),
    initialState: AsyncData(settings),
  );
  final bus = fallback ?? NetworkFallbackBus();
  return AppServices(
    db: db,
    api: apiService,
    prefs: PreferencesRepository(),
    settings: controller,
    repository:
        repository ??
        NovelRepository(
          apiService: apiService,
          settings: controller,
          db: db,
          fallback: bus,
          sites: resolvedSites,
        ),
    maintenance: maintenance ?? DatabaseMaintenanceController(),
    fallback: bus,
    sites: resolvedSites,
    now: now ?? DateTime.now,
  );
}

/// Wraps [child] in a [Scope] carrying [services].
Widget withServices(AppServices services, Widget child) =>
    Scope(services: <Type, Object>{AppServices: services}, child: child);
