import 'dart:io';

import 'package:flutter/material.dart';

import 'package:novelty/router/router.dart';
import 'package:novelty/utils/settings_provider.dart';
import 'package:provider/provider.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

Future<void> main() async {
  

  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }

  runApp(
    ChangeNotifierProvider(
      create: (context) => SettingsProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SettingsProvider>(
      builder: (context, settings, child) {
        return MaterialApp.router(
          title: 'Novelty',
          theme: ThemeData(
            colorScheme: settings.colorScheme,
            textTheme: settings.selectedFontTheme.apply(
              bodyColor: settings.colorScheme.onSurface,
              displayColor: settings.colorScheme.onSurface,
            ),
          ),
          routerConfig: router,
        );
      },
    );
  }
}
