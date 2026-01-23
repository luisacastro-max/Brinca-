import 'package:app_twins/theme/theme_data_base.dart';
import 'package:app_twins/children_selection_page.dart';
import 'package:flutter/material.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
          child: Column(
            children: [
              // Indicador de Progresso (Passo 1 de 4 - 25%)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Passo 1 de 4",
                    style: buttonTextStyle.copyWith(color: Colors.grey[600]),
                  ),
                  Text(
                    "25%",
                    style: buttonTextStyle.copyWith(color: Colors.grey[600]),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Container(
                height: 6,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: FractionallySizedBox(
                  alignment: Alignment.centerLeft,
                  widthFactor: 0.25,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [
                          Color(0xFFFCA1AA),
                          Color(0xFFFEC578),
                          Color(0xFF7AA4E3),
                          Color(0xFFA8D8BB),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 50),

              // Logo Brinca+
              Image.asset(
                "assets/images/brinca_mais_logo_welcome.jpeg",
                width: 250,
                height: 150,
                fit: BoxFit.contain,
                filterQuality: FilterQuality.high,
                alignment: AlignmentGeometry.center,
              ),
              const SizedBox(height: 40),

              // Textos de Boas-vindas
              Text(
                "Bem-vindo(a) ao Brinca+!",
                style: containerTextStyle.copyWith(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                "Vamos ajudá-lo a criar atividades educativas e divertidas para seus filhos, reduzindo o tempo de tela de forma prática e personalizada.",
                style: buttonTextStyle.copyWith(
                  fontSize: 14,
                  color: Colors.grey[600],
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 50),

              // Diferenciais (Ícones Circulares)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildFeatureIcon(
                    Icons.favorite_border,
                    "Atividades\nPersonalizadas",
                    const Color(0xFFFCA1AA),
                  ),
                  _buildFeatureIcon(
                    Icons.star_border,
                    "Desenvolvimento\nIntegral",
                    const Color(0xFF7AA4E3),
                  ),
                  _buildFeatureIcon(
                    Icons.track_changes,
                    "Fácil de Usar",
                    const Color(0xFFA8D8BB),
                  ),
                ],
              ),
              const SizedBox(height: 60),

              // Botão Começar com Degradê
              GestureDetector(
                onTap: () {
                  // Navegação para o Passo 2 (Seleção de Crianças)
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ChildrenSelectionPage(),
                    ),
                  );
                },
                child: Container(
                  height: 60,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [
                        Color(0xFFFCA1AA), // Rosa
                        Color(0xFF7ACDE3), // Amarelo
                        Color(0xFFA8D8BB), // Verde
                      ],
                    ),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: const Center(
                    child: Text(
                      "Começar",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                "Leva apenas 2 minutos",
                style: buttonTextStyle.copyWith(color: Colors.grey[500]),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureIcon(IconData icon, String label, Color color) {
    return Column(
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.2),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color, size: 30),
        ),
        const SizedBox(height: 12),
        Text(
          label,
          style: buttonTextStyle.copyWith(
            fontSize: 10,
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
