import 'package:app_twins/utils/widgets.dart';
import 'package:app_twins/theme/theme_data_base.dart';
import 'package:flutter/material.dart';

class PlanSelectionPage extends StatelessWidget {
  const PlanSelectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Título e Subtítulo
            Text(
              "Escolha o plano ideal para sua família ou instituição",
              style: containerTextStyle.copyWith(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              "Desenvolvimento infantil saudável além das telas, com atividades personalizadas e acompanhamento especializado",
              style: buttonTextStyle.copyWith(
                fontSize: 14,
                color: Colors.grey[700],
                height: 1.4,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),

            // Card do Plano Premium Familiar
            _buildPlanCard(
              title: "Plano Premium Familiar",
              description: "Para famílias com uma ou mais crianças",
              benefits: [
                "Atividades personalizadas para cada criança baseadas na idade e necessidades específicas",
                "Experiência livre de anúncios e distrações",
                "Recursos avançados como recomendações inteligentes",
                "Acompanhamento de progresso e relatórios detalhados",
                "Ideal para quem busca uma experiência completa",
              ],
              buttonLabel: "Começar Premium",
              gradientColors: [Color(0xFFFCA1AA), Color(0xFF7AA4E3)],
              icon: Icons.favorite,
            ),
            const SizedBox(height: 40),

            // Card do Plano Profissional com gradiente nos botões
            _buildPlanCard(
              title: "Plano Profissional",
              description:
                  "Para psicólogos, terapeutas ocupacionais e profissionais de desenvolvimento infantil",
              benefits: [
                "Acompanhamento individualizado de atividades",
                "Gestão segura e organizada de múltiplos pacientes",
                "Planos escaláveis a partir de 10 pacientes",
                "Relatórios profissionais de progresso",
                "Ferramentas especializadas para o consultório",
              ],
              buttonLabel: "Fale conosco",
              gradientColors: [Color(0xFF7AA4E3), Color(0xFFA8D8BB)],
              icon: Icons.healing,
            ),
            const SizedBox(height: 40),

            // Card do Plano Institucional com gradiente nos botões
            _buildPlanCard(
              title: "Plano Institucional",
              description: "Para escolas e instituições de ensino",
              benefits: [
                "Uso coletivo com organização por turmas ou grupos",
                "Aplicação estruturada de atividades em contextos educacionais",
                "Gestão centralizada para coordenadores e educadores",
                "Acompanhamento de múltiplas turmas simultaneamente",
                "Integração com práticas pedagógicas",
              ],
              buttonLabel: "Fale conosco",
              gradientColors: [Color(0xFF7AA4E3), Color(0xFFFCA1AA)],
              icon: Icons.school,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlanCard({
    required String title,
    required String description,
    required List<String> benefits,
    required String buttonLabel,
    required List<Color> gradientColors,
    required IconData icon,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Ícone com Gradiente
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: gradientColors,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Icon(icon, size: 50, color: Colors.white),
          ),
          const SizedBox(height: 24),

          // Título do Plano
          Text(
            title,
            style: containerTextStyle.copyWith(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            description,
            style: buttonTextStyle.copyWith(
              fontSize: 14,
              color: Colors.grey[600],
              height: 1.3,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),

          // Lista de Benefícios
          Column(
            children: benefits
                .map((benefit) => _buildBenefitItem(benefit))
                .toList(),
          ),

          const SizedBox(height: 40),

          // Botão com Gradiente
          Container(
            height: 48,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              gradient: LinearGradient(
                colors: gradientColors,
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
            ),
            child: Center(
              child: Text(
                buttonLabel,
                style: buttonTextStyle.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBenefitItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: const BoxDecoration(
              color: Color(0xFFA8D8BB),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.check, size: 16, color: Colors.white),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: buttonTextStyle.copyWith(
                fontSize: 14,
                color: Colors.grey[800],
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
