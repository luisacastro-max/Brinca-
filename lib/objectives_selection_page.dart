import 'package:app_twins/children_option.dart';
import 'package:app_twins/gradient_progress_bar.dart';
import 'package:app_twins/theme/theme_data_base.dart';
import 'package:flutter/material.dart';

class ObjectivesSelectionPage extends StatefulWidget {
  const ObjectivesSelectionPage({super.key});

  @override
  State<ObjectivesSelectionPage> createState() =>
      _ObjectivesSelectionPageState();
}

class _ObjectivesSelectionPageState extends State<ObjectivesSelectionPage> {
  final Set<int> selectedObjectives = {};
  final Set<int> selectedInterests = {};

  final List<Map<String, dynamic>> objectives = [
    {'label': '🤸 Coordenação motora', 'color': Color(0xFFFCA1AA)},
    {'label': '🎨 Criatividade', 'color': Color(0xFF7AA4E3)},
    {'label': '🗣️ Linguagem', 'color': Color(0xFFA8D8BB)},
    {'label': '👥 Socialização', 'color': Color(0xFFFEC578)},
    {'label': '🍎 Autonomia', 'color': Color(0xFFFCA1AA)},
    {'label': '🧘 Concentração', 'color': Color(0xFF7AA4E3)},
    {'label': '🧠 Pensamento lógico', 'color': Color(0xFFA8D8BB)},
  ];

  final List<Map<String, dynamic>> interests = [
    {'label': '🎼 Música', 'color': Color(0xFFFCA1AA)},
    {'label': '💃 Dança', 'color': Color(0xFF7AA4E3)},
    {'label': '🌿 Natureza', 'color': Color(0xFFA8D8BB)},
    {'label': '🎨 Artes', 'color': Color(0xFFFEC578)},
    {'label': '🏗️ Construção', 'color': Color(0xFFFCA1AA)},
    {'label': '🎭 Faz de conta', 'color': Color(0xFF7AA4E3)},
    {'label': '🔬 Ciências', 'color': Color(0xFFA8D8BB)},
    {'label': '📚 Leitura', 'color': Color(0xFFFEC578)},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
        children: [
          // Progresso
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Passo 4 de 4", style: buttonTextStyle),
              Text("100%", style: buttonTextStyle),
            ],
          ),
          const SizedBox(height: 8),
          const GradientProgressBar(progress: 1.0),
          const SizedBox(height: 40),

          // Título Objetivos
          Text(
            "Objetivos de desenvolvimento",
            style: containerTextStyle.copyWith(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Escolha quantos quiser",
            style: buttonTextStyle.copyWith(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 20),

          // Grid de Objetivos
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 2.2,
            ),
            itemCount: objectives.length,
            itemBuilder: (context, index) {
              final isSelected = selectedObjectives.contains(index);
              return ChildrenOption(
                label: objectives[index]['label'],
                color: objectives[index]['color'],
                selected: isSelected,
                onTap: () {
                  setState(() {
                    if (isSelected) {
                      selectedObjectives.remove(index);
                    } else {
                      selectedObjectives.add(index);
                    }
                  });
                },
              );
            },
          ),

          const SizedBox(height: 40),

          // Título Interesses
          Text(
            "Interesses da criança",
            style: containerTextStyle.copyWith(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),

          // Grid de Interesses
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 2.2,
            ),
            itemCount: interests.length,
            itemBuilder: (context, index) {
              final isSelected = selectedInterests.contains(index);
              return ChildrenOption(
                label: interests[index]['label'],
                color: interests[index]['color'],
                selected: isSelected,
                onTap: () {
                  setState(() {
                    if (isSelected) {
                      selectedInterests.remove(index);
                    } else {
                      selectedInterests.add(index);
                    }
                  });
                },
              );
            },
          ),

          const SizedBox(height: 40),

          // Botões
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Voltar"),
              ),
              ElevatedButton(
                onPressed: selectedObjectives.isEmpty || selectedInterests.isEmpty
                    ? null
                    : () {
                        // Onboarding concluído!
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Perfil criado com sucesso!'),
                          ),
                        );
                      },
                child: const Text("Continuar"),
              ),
            ],
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }
}
