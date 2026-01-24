import 'package:app_twins/plan_selection_page.dart';
import 'package:app_twins/welcome_page.dart';
import 'package:app_twins/sensory_treasure_hunt_page.dart'; // Atualize o caminho conforme necessário
import 'package:flutter/material.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Twins APP',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        textTheme: TextTheme(),
      ),
      home: const SensoryTreasureHuntPage(),
    );
  }
}