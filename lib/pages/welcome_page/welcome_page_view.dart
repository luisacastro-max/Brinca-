import 'package:app_twins/design_system/components/gradient_progress_bar/gradient_progress_bar.dart';
import 'package:app_twins/design_system/components/gradient_progress_bar/gradient_progress_bar_vm.dart';
import 'package:app_twins/pages/welcome_page/welcome_page_router.dart';
import 'package:app_twins/theme/theme_data_base.dart';
import 'package:flutter/material.dart';

class WelcomePageView extends StatelessWidget {
  const WelcomePageView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Passo 1 de 4',
                    style: buttonTextStyle.copyWith(color: Colors.grey[600]),
                  ),
                  Text(
                    '25%',
                    style: buttonTextStyle.copyWith(color: Colors.grey[600]),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              GradientProgressBarComponent.instantiate(
                viewModel: GradientProgressBarViewModel(
                  progress: 0.25,
                  height: 8,
                  backgroundColor: Colors.grey[200]!,
                  gradientColors: const [
                    Color(0xFFFCA1AA),
                    Color(0xFF7AA4E3),
                    Color(0xFFA8D8BB),
                  ],
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              const SizedBox(height: 50),
              Image.asset(
                'assets/images/brinca_mais_logo_welcome.jpeg',
                width: 250,
                height: 150,
                fit: BoxFit.contain,
                filterQuality: FilterQuality.high,
                alignment: Alignment.center,
              ),
              const SizedBox(height: 40),
              Text(
                'Bem-vindo(a) ao Brinca+!',
                style: containerTextStyle.copyWith(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                'Vamos ajuda-lo a criar atividades educativas e divertidas para seus filhos, reduzindo o tempo de tela de forma pratica e personalizada.',
                style: buttonTextStyle.copyWith(
                  fontSize: 14,
                  color: Colors.grey[600],
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 50),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildFeatureIcon(
                    Icons.favorite_border,
                    'Atividades\nPersonalizadas',
                    const Color(0xFFFCA1AA),
                  ),
                  _buildFeatureIcon(
                    Icons.star_border,
                    'Desenvolvimento\nIntegral',
                    const Color(0xFF7AA4E3),
                  ),
                  _buildFeatureIcon(
                    Icons.track_changes,
                    'Facil de Usar',
                    const Color(0xFFA8D8BB),
                  ),
                ],
              ),
              const SizedBox(height: 60),
              GestureDetector(
                onTap: () => WelcomePageRouter.goToChildrenSelection(context),
                child: Container(
                  height: 60,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [
                        Color(0xFFFCA1AA),
                        Color(0xFF7ACDE3),
                        Color(0xFFA8D8BB),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Center(
                    child: const Text(
                      'Comecar',
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
                'Leva apenas 2 minutos',
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
