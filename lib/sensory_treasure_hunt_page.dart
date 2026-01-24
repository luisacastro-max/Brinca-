import 'package:flutter/material.dart';

class SensoryTreasureHuntPage extends StatelessWidget {
  const SensoryTreasureHuntPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite, color: Colors.black),
            onPressed: () {
              // Logic for favorites
            },
          ),
        ],
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Seção inicial
            _buildIntroductionSection(),
            const SizedBox(height: 20),

            // Materiais Necessários e Passo a Passo
            _buildMaterialsSection(),
            const SizedBox(height: 20),

            // Adaptações e Alternativas com Dicas para Adultos
            _buildAdaptationsSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildIntroductionSection() {
    return Column(
      children: [
        Center(
          // Ícone com Gradiente
          child: Container(
            width: 72,
            height: 72,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [Color(0xFFFCA1AA), Color(0xFF7AA4E3)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: const Icon(Icons.search, size: 36, color: Colors.white),
          ),
        ),
        const SizedBox(height: 20),

        // Título
        const Center(
          child: Text(
            "Caça ao Tesouro Sensorial",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
          ),
        ),
        const SizedBox(height: 16),

        // Informações sobre a atividade
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(child: _buildInfoCard(Icons.timer, "Duração", "20-30 min")),
            const SizedBox(width: 12),
            Expanded(child: _buildInfoCard(Icons.cake, "Idade", "3-5 anos")),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(child: _buildInfoCard(Icons.extension, "Área", "Habilidades Motoras")),
            const SizedBox(width: 12),
            Expanded(child: _buildInfoCard(Icons.star, "Dificuldade", "Fácil")),
          ],
        ),
        const SizedBox(height: 24),

        // Validação Neurodivergente
        _buildNeurodivergenceCard(),
        const SizedBox(height: 20),

        // Por que esta atividade importa
        _buildWhyItMattersCard(),
      ],
    );
  }

  Widget _buildMaterialsSection() {
    return Column(
      children: [
        // Materiais Necessários
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.inventory, color: Colors.orange, size: 24),
                  const SizedBox(width: 8),
                  const Text(
                    "Materiais Necessários",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              _buildListItem("Objetos de diferentes texturas (esponja, tecido, papel, plástico)", subtitle: "Alternativa: Itens domésticos variados"),
              _buildListItem("Venda ou lenço para cobrir os olhos", subtitle: "Alternativa: Pedir que a criança feche os olhos"),
              _buildListItem("Cesta ou caixa para guardar os objetos"),
            ],
          ),
        ),
        const SizedBox(height: 20),

        // Passo a Passo
        _buildStepByStepSection(),
      ],
    );
  }

  Widget _buildAdaptationsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildAlternativesCard(), // Adaptações e Alternativas
        const SizedBox(height: 20),
        _buildAdviceForAdultsCard(), // Dicas para Adultos
      ],
    );
  }

  Widget _buildInfoCard(IconData icon, String title, String description) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, color: Colors.blue),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
          ),
          Text(
            description,
            style: const TextStyle(color: Colors.grey, fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildNeurodivergenceCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: const LinearGradient(
          colors: [Color(0xFFFF6B9D), Color(0xFF4A90E2)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.all_inclusive, color: Colors.white, size: 32),
          const SizedBox(height: 8),
          const Text(
            "Validada para Neurodivergência",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white),
          ),
          const SizedBox(height: 8),
          const Text(
            "Esta atividade mostrou maior engajamento e respostas positivas entre crianças neurodivergentes, baseado em testes com clínicas de psicologia parceiras.",
            style: TextStyle(color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildWhyItMattersCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFE0F7E9), // Verde claro
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.lightbulb, color: Color(0xFF56C596), size: 24),
              const SizedBox(width: 8),
              const Text(
                "Por que esta atividade importa",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildBulletPoint("Desenvolve a percepção tátil e o reconhecimento de texturas"),
          _buildBulletPoint("Estimula a concentração e atenção aos detalhes"),
          _buildBulletPoint("Promove a exploração sensorial de forma lúdica"),
          _buildBulletPoint("Reduz dependência de estímulos visuais digitais"),
        ],
      ),
    );
  }

  Widget _buildStepByStepSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.list, color: Colors.blue, size: 24),
              const SizedBox(width: 8),
              const Text(
                "Passo a Passo",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Passos numerados com dicas
          _buildNumberedStep(
            1,
            "Selecione 5-8 objetos de texturas variadas pela casa.",
            tip: "Dica: Escolha itens seguros e de tamanhos adequados para a idade.",
          ),
          _buildNumberedStep(2, "Esconda os objetos em locais acessíveis do ambiente."),
          _buildNumberedStep(3, "Vende os olhos da criança ou peça para fechá-los."),
          _buildNumberedStep(
            4,
            "Guie a criança pela casa e incentive-a a explorar com as mãos.",
            tip: "Dica: Use linguagem descritiva: \"Sente algo macio? Áspero? Liso?\"",
          ),
          _buildNumberedStep(5, "Quando encontrar um objeto, peça para descrever a textura antes de ver."),
          _buildNumberedStep(6, "Após todas as descobertas, conversem sobre as sensações experimentadas."),
        ],
      ),
    );
  }

  Widget _buildAlternativesCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Adaptações e Alternativas",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          const SizedBox(height: 16),
          _buildAdaptationItem(
            "Para crianças mais novas (2-3 anos)",
            "Use apenas 3-4 objetos grandes e texturas bem distintas. Mantenha os olhos abertos e foque na exploração tátil.",
          ),
          _buildAdaptationItem(
            "Para crianças neurodivergentes",
            "Permita que vejam os objetos primeiro. Respeite se não quiserem vendar os olhos. Foque no prazer da descoberta, não na competição.",
          ),
          _buildAdaptationItem(
            "Para grupos",
            "Cada criança pode esconder objetos para as outras encontrarem, desenvolvendo cooperação e revezamento.",
          ),
        ],
      ),
    );
  }

  Widget _buildAdviceForAdultsCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFEFF7FF), // Azul claro
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.info, color: Colors.blue, size: 24),
              const SizedBox(width: 8),
              const Text(
                "Dicas para Adultos",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildBulletPointWithIcon("Observe quais texturas a criança prefere ou evita, isso pode indicar sensibilidades sensoriais"),
          _buildBulletPointWithIcon("Não force a criança a tocar algo que ela demonstre desconforto"),
          _buildBulletPointWithIcon("Celebre cada descoberta com entusiasmo genuíno"),
          _buildBulletPointWithIcon("Use a atividade para expandir vocabulário sensorial"),
        ],
      ),
    );
  }

  Widget _buildListItem(String text, {String? subtitle}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.circle, size: 8, color: Colors.grey),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  text,
                  style: const TextStyle(fontSize: 14, color: Colors.black87),
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNumberedStep(int number, String text, {String? tip}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                radius: 14,
                child: Text(
                  "$number",
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  text,
                  style: const TextStyle(fontSize: 14, color: Colors.black87),
                ),
              ),
            ],
          ),
          if (tip != null) ...[
            const SizedBox(height: 8),
            Container(
              margin: const EdgeInsets.only(left: 40),
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFFE3F2FD),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                tip,
                style: const TextStyle(fontSize: 12, color: Colors.blue),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildBulletPoint(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.circle, size: 8, color: Color(0xFF56C596)),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 14, color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBulletPointWithIcon(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.check_circle, size: 20, color: Colors.blue),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 14, color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAdaptationItem(String title, String description) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 4,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.pink,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: const TextStyle(fontSize: 13, color: Colors.black87),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}