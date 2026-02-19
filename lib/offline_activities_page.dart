import 'package:flutter/material.dart';

class OfflineActivitiesPage extends StatefulWidget {
  const OfflineActivitiesPage({super.key});

  @override
  State<OfflineActivitiesPage> createState() => _OfflineActivitiesPageState();
}

class _OfflineActivitiesPageState extends State<OfflineActivitiesPage> {
  String selectedAgeGroup = "Todas as idades";
  String selectedDevelopmentArea = "Todas";

  // Lista de atividades
  final List<Map<String, dynamic>> allActivities = [
    {
      "icon": Icons.search,
      "iconGradient": [Color(0xFFFCA1AA), Color(0xFF7AA4E3)],
      "title": "Caça ao Tesouro Sensorial",
      "description": "Separe objetos de diferentes texturas pela casa e deixe a criança adivinhá-los usando apenas o tato.",
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
      "description": "Use uma lanterna e as mãos para criar sombras na parede e contar histórias criativas.",
      "duration": "15-20 min",
      "ageRange": "4-8 anos",
      "category": "Criatividade",
      "isValidatedForNeurodivergence": false,
      "isPremium": false,
    },
    {
        "icon": Icons.palette, // Ícone de paleta de pintura
        "iconGradient": [Color(0xFFA8D8BB), Color(0xFF7AA4E3)],
        "title": "Pintura com Elementos da Natureza",
        "description": "Crie tintas naturais com folhas, flores e terra para uma experiência artística sustentável.",
        "duration": "30-40 min",
        "ageRange": "5-8 anos",
        "category": "Criatividade",
        "isValidatedForNeurodivergence": false,
        "isPremium": true,
    },
    {
      "icon": Icons.directions_run,
      "iconGradient": [Color(0xFFFCA1AA), Color(0xFFA8D8BB)],
      "title": "Circuito de Obstáculos Caseiro",
      "description": "Monte um percurso com almofadas, cadeiras e caixas para desenvolver coordenação motora.",
      "duration": "25-35 min",
      "ageRange": "3-6 anos",
      "category": "Habilidades Motoras",
      "isValidatedForNeurodivergence": true,
      "isPremium": false,
    },
    {
      "icon": Icons.menu_book,
      "iconGradient": [Color(0xFF7AA4E3), Color(0xFFFCA1AA)],
      "title": "Hora da História Interativa",
      "description": "Leia um livro e convide a criança a fazer sons, gestos e participar da narrativa.",
      "duration": "15-25 min",
      "ageRange": "2-6 anos",
      "category": "Linguagem",
      "isValidatedForNeurodivergence": true,
      "isPremium": false,
    },
    {
      "icon": Icons.music_note,
      "iconGradient": [Color(0xFFFCA1AA), Color(0xFF7AA4E3)],
      "title": "Banda Musical com Materiais Recicláveis",
      "description": "Transforme potes, caixas e garrafas em instrumentos musicais para criar diferentes sons.",
      "duration": "30-45 min",
      "ageRange": "4-8 anos",
      "category": "Criatividade",
      "isValidatedForNeurodivergence": false,
      "isPremium": true,
    },
    {
      "icon": Icons.self_improvement,
      "iconGradient": [Color(0xFFFCA1AA), Color(0xFF7AA4E3)],
      "title": "Yoga para Crianças",
      "description": "Poses simples e divertidas inspiradas em animais para relaxamento e consciência corporal.",
      "duration": "15-20 min",
      "ageRange": "3-7 anos",
      "category": "Habilidades Emocionais",
      "isValidatedForNeurodivergence": true,
      "isPremium": true,
    },
    {
      "icon": Icons.extension,
      "iconGradient": [Color(0xFFA8D8BB), Color(0xFF7AA4E3)],
      "title": "Quebra-Cabeça Gigante",
      "description": "Desenhe e recorte um quebra-cabeça grande em papelão para estimular raciocínio lógico.",
      "duration": "20-30 min",
      "ageRange": "5-9 anos",
      "category": "Habilidades Motoras",
      "isValidatedForNeurodivergence": false,
      "isPremium": true,
    },
    {
      "icon": Icons.park,
      "iconGradient": [Color(0xFFA8D8BB), Color(0xFF7AA4E3)],
      "title": "Exploração ao Ar Livre",
      "description": "Saia para observar plantas, insetos e elementos da natureza, coletando folhas e pedras.",
      "duration": "30-60 min",
      "ageRange": "4-10 anos",
      "category": "Socialização",
      "isValidatedForNeurodivergence": true,
      "isPremium": false,
    },
  ];

  // Função para filtrar atividades
  List<Map<String, dynamic>> get filteredActivities {
    return allActivities.where((activity) {
      // Filtro de faixa etária
      bool matchesAgeGroup = selectedAgeGroup == "Todas as idades" || activity["ageRange"] == selectedAgeGroup;

      // Filtro de área de desenvolvimento
      bool matchesDevelopmentArea = selectedDevelopmentArea == "Todas" || activity["category"] == selectedDevelopmentArea;

      return matchesAgeGroup && matchesDevelopmentArea;
    }).toList();
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
            // Título
            const Text(
              "Atividades para Brincar Offline",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
            ),
            const SizedBox(height: 8),
            const Text(
              "Promova o desenvolvimento saudável das crianças com brincadeiras que estimulam criatividade, movimento e aprendizado além das telas",
              style: TextStyle(fontSize: 14, color: Colors.grey, height: 1.4),
            ),
            const SizedBox(height: 24),

            // Filtro de Faixa Etária
            const Text(
              "Faixa Etária",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _buildFilterChip("Todas as idades", selectedAgeGroup, (value) {
                  setState(() {
                    selectedAgeGroup = value;
                  });
                }, isGradient: true),
                _buildFilterChip("0-2 anos", selectedAgeGroup, (value) {
                  setState(() {
                    selectedAgeGroup = value;
                  });
                }),
                _buildFilterChip("3-5 anos", selectedAgeGroup, (value) {
                  setState(() {
                    selectedAgeGroup = value;
                  });
                }),
                _buildFilterChip("6+ anos", selectedAgeGroup, (value) {
                  setState(() {
                    selectedAgeGroup = value;
                  });
                }),
              ],
            ),
            const SizedBox(height: 24),

            // Filtro de Área de Desenvolvimento
            const Text(
              "Área de Desenvolvimento",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _buildFilterChip("Todas", selectedDevelopmentArea, (value) {
                  setState(() {
                    selectedDevelopmentArea = value;
                  });
                }, isGradient: true),
                _buildFilterChip("Habilidades Motoras", selectedDevelopmentArea, (value) {
                  setState(() {
                    selectedDevelopmentArea = value;
                  });
                }),
                _buildFilterChip("Criatividade", selectedDevelopmentArea, (value) {
                  setState(() {
                    selectedDevelopmentArea = value;
                  });
                }),
                _buildFilterChip("Habilidades Emocionais", selectedDevelopmentArea, (value) {
                  setState(() {
                    selectedDevelopmentArea = value;
                  });
                }),
                _buildFilterChip("Linguagem", selectedDevelopmentArea, (value) {
                  setState(() {
                    selectedDevelopmentArea = value;
                  });
                }),
                _buildFilterChip("Socialização", selectedDevelopmentArea, (value) {
                  setState(() {
                    selectedDevelopmentArea = value;
                  });
                }),
              ],
            ),
            const SizedBox(height: 32),

            // Cards de Atividades Filtradas
            if (filteredActivities.isEmpty)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(32.0),
                  child: Text(
                    "Nenhuma atividade encontrada para os filtros selecionados.",
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                ),
              )
            else
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
                    isValidatedForNeurodivergence: activity["isValidatedForNeurodivergence"],
                    isPremium: activity["isPremium"],
                  ),
                );
              }).toList(),

            // Card de Call-to-Action Premium
            const SizedBox(height: 16),
            _buildPremiumCallToAction(),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip(String label, String selectedValue, Function(String) onSelected, {bool isGradient = false}) {
    final isSelected = selectedValue == label;

    return GestureDetector(
      onTap: () => onSelected(label),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          gradient: isSelected && isGradient
              ? const LinearGradient(
                  colors: [Color(0xFFFCA1AA), Color(0xFF7AA4E3)],
                )
              : null,
          color: isSelected && !isGradient ? Colors.grey[300] : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? Colors.transparent : Colors.grey[300]!,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected && isGradient ? Colors.white : Colors.black87,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            fontSize: 14,
          ),
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
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // Ícone com gradiente
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: iconGradient,
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Icon(icon, color: Colors.white, size: 24),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: isPremium ? Colors.pink[50] : Colors.green[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    if (isPremium)
                      const Icon(Icons.lock, color: Colors.pink, size: 12),
                    if (isPremium) const SizedBox(width: 4),
                    Text(
                      isPremium ? "Premium" : "Grátis",
                      style: TextStyle(
                        color: isPremium ? Colors.pink : Colors.green,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            description,
            style: const TextStyle(fontSize: 14, color: Colors.grey, height: 1.4),
          ),
          const SizedBox(height: 12),

          // Informações de Duração, Idade e Categoria
          Row(
            children: [
              const Icon(Icons.timer, size: 16, color: Colors.grey),
              const SizedBox(width: 4),
              Text(duration, style: const TextStyle(fontSize: 12, color: Colors.grey)),
              const SizedBox(width: 16),
              const Icon(Icons.people, size: 16, color: Colors.grey),
              const SizedBox(width: 4),
              Text(ageRange, style: const TextStyle(fontSize: 12, color: Colors.grey)),
              const SizedBox(width: 16),
              Expanded(child: Text(category, style: const TextStyle(fontSize: 12, color: Colors.grey))),
            ],
          ),

          // Validação para Neurodivergência
          if (isValidatedForNeurodivergence) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFFFFE8EC),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const Icon(Icons.verified, color: Colors.pink, size: 16),
                  const SizedBox(width: 8),
                  const Expanded(
                    child: Text(
                      "Validada para neurodivergência",
                      style: TextStyle(fontSize: 12, color: Colors.black87),
                    ),
                  ),
                  const Icon(Icons.info_outline, color: Colors.blue, size: 16),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildPremiumCallToAction() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          colors: [Color(0xFFFFDDDD), Color(0xFFDDD8FF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        children: [
          // Ícone de coroa
          Container(
            width: 60,
            height: 60,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.workspace_premium, size: 32, color: Colors.black87),
          ),
          const SizedBox(height: 16),
          const Text(
            "Desbloqueie Todo o Potencial",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          const Text(
            "Acesse centenas de atividades exclusivas, personalizadas para o desenvolvimento da sua família",
            style: TextStyle(fontSize: 14, color: Colors.black87, height: 1.4),
            textAlign: TextAlign.center,
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
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            "Todas as atividades são desenvolvidas por especialistas em desenvolvimento infantil",
            style: TextStyle(fontSize: 12, color: Colors.black54),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}