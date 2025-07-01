import 'package:flutter/material.dart';
import 'package:novelty/screens/ranking_page.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:novelty/utils/font_provider.dart';

Future<void> main() async {
  await dotenv.load(fileName: '.env');

  runApp(
    ChangeNotifierProvider(
      create: (context) => FontProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<FontProvider>(
      builder: (context, fontProvider, child) {
        return MaterialApp(
          title: '小説ランキング',
          theme: ThemeData(
            primarySwatch: Colors.blue,
            textTheme: fontProvider.selectedFontTheme.apply(
              bodyColor: Colors.black,
              displayColor: Colors.black,
            ),
          ),
          home: const RankingPage(),
        );
      },
    );
  }
}