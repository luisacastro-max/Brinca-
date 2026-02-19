import 'package:app_twins/children_selection_page.dart';
import 'package:app_twins/plan_selection_page.dart';
import 'package:app_twins/welcome_page.dart';
import 'package:app_twins/sensory_treasure_hunt_page.dart'; // Atualize o caminho conforme necessário
import 'package:app_twins/progress_dashboard_page.dart';
import 'package:flutter/material.dart';
import 'offline_activities_page.dart';
import 'shadow_theater_page.dart';
import 'package:app_twins/child_details_page.dart';
import 'package:app_twins/advanced_dashboard_page.dart';

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
      home: const ChildrenSelectionPage()
    );
  }
}
