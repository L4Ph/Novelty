import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:novelty/router/router.dart';
import 'package:novelty/utils/settings_provider.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

Future<void> main() async {
  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }

  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);

    return settings.when(
      data: (settings) => MaterialApp.router(
        title: 'Novelty',
        theme: ThemeData(
          colorScheme: settings.colorScheme,
          textTheme: settings.selectedFontTheme.apply(
            bodyColor: settings.colorScheme.onSurface,
            displayColor: settings.colorScheme.onSurface,
          ),
        ),
        routerConfig: router,
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) => Center(child: Text('Error: $err')),
    );
  }
}
