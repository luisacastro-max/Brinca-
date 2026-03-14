import 'package:flutter/material.dart';
import 'package:app_twins/sensory_treasure_hunt_page.dart';
import 'package:app_twins/plan_selection_page.dart';

class OfflineActivitiesPage extends StatefulWidget {
  const OfflineActivitiesPage({super.key});

  @override
  State<OfflineActivitiesPage> createState() => _OfflineActivitiesPageState();
}

class _OfflineActivitiesPageState extends State<OfflineActivitiesPage> {
  String selectedAgeGroup = "Todas as idades";
  String selectedDevelopmentArea = "Todas";

  final List<Map<String, dynamic>> allActivities = [
    {
      "icon": Icons.search,
      "iconGradient": [Color(0xFFFCA1AA), Color(0xFF7AA4E3)],
      "title": "Caça ao Tesouro Sensorial",
      "description":
          "Separe objetos de diferentes texturas pela casa e deixe a criança adivinhá-los usando apenas o tato.",
      "duration": "20-30 min",
      "ageRange": "3-5 anos",
      "category": "Habilidades Motoras",
      "isValidatedForNeurodivergence": true,
      "isPremium": false,
    },
    {
      "icon": Icons.theater_comedy,
      "iconGradient": [Color(0xFF7AA4E3), Color(0xFFA8D8BB)],
      "title": "Teatro de Sombras",
      "description":
          "Use uma lanterna e as mãos para criar sombras na parede e contar histórias criativas.",
      "duration": "15-20 min",
      "ageRange": "4-8 anos",
      "category": "Criatividade",
      "isValidatedForNeurodivergence": false,
      "isPremium": false,
    },
  ];

  List<Map<String, dynamic>> get filteredActivities {
    return allActivities.where((activity) {
      bool matchesAgeGroup =
          selectedAgeGroup == "Todas as idades" ||
          activity["ageRange"] == selectedAgeGroup;

      bool matchesDevelopmentArea =
          selectedDevelopmentArea == "Todas" ||
          activity["category"] == selectedDevelopmentArea;

      return matchesAgeGroup && matchesDevelopmentArea;
    }).toList();
  }

  void _openActivityDetails(Map<String, dynamic> activity) {
    if (activity["title"] == "Caça ao Tesouro Sensorial") {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const SensoryTreasureHuntPage(),
        ),
      );
    }
  }

  void _openPremiumPlan() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const PlanSelectionPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Atividades para Brincar Offline",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
            ),
            const SizedBox(height: 32),

            ...filteredActivities.map((activity) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: _buildActivityCard(
                  icon: activity["icon"],
                  iconGradient: activity["iconGradient"],
                  title: activity["title"],
                  description: activity["description"],
                  duration: activity["duration"],
                  ageRange: activity["ageRange"],
                  category: activity["category"],
                  isValidatedForNeurodivergence:
                      activity["isValidatedForNeurodivergence"],
                  isPremium: activity["isPremium"],
                  onTap: () => _openActivityDetails(activity),
                ),
              );
            }).toList(),

            const SizedBox(height: 16),
            _buildPremiumCallToAction(),
          ],
        ),
      ),
    );
  }

  Widget _buildActivityCard({
    required IconData icon,
    required List<Color> iconGradient,
    required String title,
    required String description,
    required String duration,
    required String ageRange,
    required String category,
    required bool isValidatedForNeurodivergence,
    required bool isPremium,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 8),
            Text(description),
          ],
        ),
      ),
    );
  }

  Widget _buildPremiumCallToAction() {
    return GestureDetector(
      onTap: _openPremiumPlan,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: const LinearGradient(
            colors: [Color(0xFFFFDDDD), Color(0xFFDDD8FF)],
          ),
        ),
        child: Column(
          children: [
            const Text(
              "Desbloqueie Todo o Potencial",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            const SizedBox(height: 20),
            Container(
              height: 48,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                gradient: const LinearGradient(
                  colors: [Color(0xFFFCA1AA), Color(0xFF7AA4E3)],
                ),
              ),
              child: const Center(
                child: Text(
                  "Ver Planos Premium",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
