import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:novelty/router/router.dart';
import 'package:novelty/utils/settings_provider.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  await dotenv.load(fileName: '.env');

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