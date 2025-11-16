import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:novelty/router/router.dart';
import 'package:novelty/utils/settings_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

/// アプリケーションのエントリーポイント。
/// アプリの設定を初期化し、ルーターを設定してアプリを起動
class MyApp extends ConsumerWidget {
  /// コンストラクタ。
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);

    return settings.when(
      data: (settings) => DynamicColorBuilder(
        builder: (ColorScheme? lightDynamic, ColorScheme? darkDynamic) {
          final colorScheme =
              lightDynamic ??
              ColorScheme.fromSeed(
                seedColor: const Color.fromARGB(255, 179, 220, 226),
              );
          final darkColorSchema =
              darkDynamic ??
              ColorScheme.fromSeed(
                seedColor: const Color.fromARGB(255, 179, 220, 226),
              );

          return MaterialApp.router(
            title: 'Novelty',
            theme: ThemeData(
              colorScheme: colorScheme,
            ),
            darkTheme: ThemeData(
              colorScheme: darkColorSchema,
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
