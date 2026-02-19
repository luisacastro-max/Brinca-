import 'package:flutter/material.dart';

class ShadowTheaterPage extends StatelessWidget {
  const ShadowTheaterPage({super.key});

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
            _buildIntroductionSection(),
            const SizedBox(height: 20),
            _buildMaterialsSection(),
            const SizedBox(height: 20),
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
          child: Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                colors: [Color(0xFF7AA4E3), Color(0xFFA8D8BB)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: const Icon(Icons.theater_comedy, size: 36, color: Colors.white),
          ),
        ),
        const SizedBox(height: 20),

        const Center(
          child: Text(
            "Teatro de Sombras",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
          ),
        ),
        const SizedBox(height: 16),

        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(child: _buildInfoCard(Icons.timer, "Duração", "15-20 min")),
            const SizedBox(width: 12),
            Expanded(child: _buildInfoCard(Icons.cake, "Idade", "4-8 anos")),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(child: _buildInfoCard(Icons.extension, "Área", "Criatividade")),
            const SizedBox(width: 12),
            Expanded(child: _buildInfoCard(Icons.star, "Dificuldade", "Fácil")),
          ],
        ),
        const SizedBox(height: 24),

        _buildWhyItMattersCard(),
      ],
    );
  }

  Widget _buildMaterialsSection() {
    return Column(
      children: [
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
              _buildListItem("Lanterna ou luminária de mesa"),
              _buildListItem("Parede lisa e clara", subtitle: "Alternativa: Lençol branco esticado"),
              _buildListItem("Recortes de papel para criar personagens (opcional)"),
            ],
          ),
        ),
        const SizedBox(height: 20),

        _buildStepByStepSection(),
      ],
    );
  }

  Widget _buildAdaptationsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildAlternativesCard(),
        const SizedBox(height: 20),
        _buildAdviceForAdultsCard(),
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
            textAlign: TextAlign.center,
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
        color: const Color(0xFFE0F7E9),
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
          _buildBulletPoint("Estimula a imaginação e a criatividade narrativa"),
          _buildBulletPoint("Desenvolve coordenação motora fina das mãos"),
          _buildBulletPoint("Promove expressão artística sem necessidade de telas"),
          _buildBulletPoint("Fortalece vínculo familiar através de brincadeiras compartilhadas"),
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

          _buildNumberedStep(1, "Escureça o ambiente e posicione a lanterna voltada para a parede."),
          _buildNumberedStep(2, "Posicione as mãos entre a luz e a parede para criar sombras."),
          _buildNumberedStep(
            3,
            "Experimente diferentes formatos: animais, pessoas.",
            tip: "Dica: Comece com formas simples como pássaros e cachorros.",
          ),
          _buildNumberedStep(4, "Crie uma história com as sombras."),
          _buildNumberedStep(5, "Convide a criança a criar suas próprias formas e continuar a história."),
          _buildNumberedStep(6, "Finalize com aplausos e compartilhem o que mais gostaram."),
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
            "Para crianças mais novas",
            "Mantenha as formas simples, sem pressão de criar histórias complexas.",
          ),
          _buildAdaptationItem(
            "Para crianças mais velhas",
            "Incentive criação mais elaborada, com início, meio e fim. Podem criar cenários com recortes de papel.",
          ),
          _buildAdaptationItem(
            "Em grupos escolares",
            "Divida em equipes para criar peças teatrais curtas e apresentar para os colegas.",
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
        color: const Color(0xFFEFF7FF),
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
          _buildBulletPointWithIcon("Deixe a criança liderar a história, mesmo que não faça muito sentido"),
          _buildBulletPointWithIcon("Valorize a tentativa e o processo criativo, não apenas o resultado"),
          _buildBulletPointWithIcon("Ajude a criança a criar personagens para tornar mais fácil"),
          _buildBulletPointWithIcon("Use a atividade para acalmar antes de dormir"),
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