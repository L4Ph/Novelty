import 'package:flutter/material.dart';
import 'package:novelty/screens/ranking_page.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> main() async {
  const envFile = String.fromEnvironment('env');
  await dotenv.load(fileName: envFile);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '小説ランキング',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const RankingPage(),
    );
  }
}