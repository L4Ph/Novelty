import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:novelty/database/database.dart';
import 'package:novelty/router/router.dart';
import 'package:novelty/services/database_migration_service.dart';
import 'package:novelty/services/database_service.dart';
import 'package:novelty/utils/settings_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final container = ProviderContainer();
  final database = container.read(appDatabaseProvider);
  final oldDatabaseService = DatabaseService(database);

  // データ移行が必要かチェック
  final prefs = await SharedPreferences.getInstance();
  final migrationCompleted = prefs.getBool('drift_migration_completed') ?? false;

  if (!migrationCompleted) {
    // データ移行の実行
    final migrationService =
        DatabaseMigrationService(oldDatabaseService, database);
    await migrationService.migrateData();

    // 移行完了フラグを設定
    await prefs.setBool('drift_migration_completed', true);
  }

  runApp(
    ProviderScope(
      child: const MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);

    return settings.when(
      data: (settings) => DynamicColorBuilder(
        builder: (ColorScheme? lightDynamic, ColorScheme? darkDynamic) {
          final colorScheme =
              lightDynamic ??
              ColorScheme.fromSeed(seedColor: const Color(0x00b6e1e1));
          final darkColorSchema =
              darkDynamic ??
              ColorScheme.fromSeed(seedColor: const Color(0x00b6e1e1));

          return MaterialApp.router(
            title: 'Novelty',
            theme: ThemeData(
              colorScheme: colorScheme,
              fontFamily: GoogleFonts.notoSansJp().fontFamily,
            ),
            darkTheme: ThemeData(
              colorScheme: darkColorSchema,
              fontFamily: GoogleFonts.notoSansJp().fontFamily,
            ),
            routerConfig: router,
          );
        },
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) => Center(child: Text('Error: $err')),
    );
  }
}

