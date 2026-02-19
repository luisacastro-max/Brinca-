import 'package:flutter/material.dart';

class ProgressDashboardPage extends StatefulWidget {
  const ProgressDashboardPage({super.key});

  @override
  State<ProgressDashboardPage> createState() => _ProgressDashboardPageState();
}

class _ProgressDashboardPageState extends State<ProgressDashboardPage> {
  bool isDarkMode = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: isDarkMode
          ? const Color(0xFF1A1A2E)
          : const Color(0xFFF8F9FA),
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: isDarkMode ? Colors.white : Colors.black,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: GestureDetector(
          onTap: () {
            setState(() {
              isDarkMode = !isDarkMode;
            });
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: isDarkMode ? const Color(0xFF2D2D44) : Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isDarkMode ? const Color(0xFF3D3D5C) : Colors.grey[300]!,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  isDarkMode ? Icons.dark_mode : Icons.light_mode,
                  size: 16,
                  color: isDarkMode ? Colors.amber : Colors.orange,
                ),
                const SizedBox(width: 6),
                Text(
                  "Modo Escuro",
                  style: TextStyle(
                    fontSize: 14,
                    color: isDarkMode ? Colors.white : Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(
              Icons.favorite_border,
              color: isDarkMode ? Colors.white : Colors.black,
            ),
            onPressed: () {},
          ),
        ],
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildCongratulationsCard(),
            const SizedBox(height: 24),
            _buildStatsCards(),
            const SizedBox(height: 24),
            _buildWeeklyAchievements(),
            const SizedBox(height: 24),
            _buildStimulatedAreas(),
            const SizedBox(height: 24),
            _buildWeeklyActivities(),
            const SizedBox(height: 24),
            _buildMotivationalCard(),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildCongratulationsCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: isDarkMode ? const Color(0xFF2D2D44) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: const Color(0xFFE6E6FA),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(
              Icons.auto_awesome,
              color: Color(0xFF7B68EE),
              size: 32,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            "Parabéns!",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 24,
              color: isDarkMode ? Colors.white : Colors.black87,
            ),
          ),
          const SizedBox(height: 12),
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              style: TextStyle(
                fontSize: 14,
                height: 1.5,
                color: isDarkMode ? Colors.white70 : Colors.black87,
              ),
              children: const [
                TextSpan(text: "Sofia"),
                TextSpan(
                  text: " completou ",
                  style: TextStyle(fontWeight: FontWeight.normal),
                ),
                TextSpan(
                  text: "12 atividades",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                TextSpan(text: " esta semana\ne passou "),
                TextSpan(
                  text: "8 horas e 30 minutos",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                TextSpan(text: " longe das telas."),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Text(
            "Você está criando momentos especiais e contribuindo para o desenvolvimento saudável do seu filho. Continue assim! 💚",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              color: isDarkMode ? Colors.white60 : Colors.grey[600],
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsCards() {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            Icons.access_time,
            "Tempo offline",
            "8h 30min",
            const Color(0xFFE3F2FD),
            const Color(0xFF2196F3),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildStatCard(
            Icons.check_circle,
            "Atividades",
            "12",
            const Color(0xFFE8F5E9),
            const Color(0xFF4CAF50),
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(
    IconData icon,
    String label,
    String value,
    Color bgColor,
    Color iconColor,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDarkMode ? const Color(0xFF2D2D44) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: isDarkMode ? iconColor.withOpacity(0.2) : bgColor,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: iconColor, size: 24),
          ),
          const SizedBox(height: 12),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: isDarkMode ? Colors.white60 : Colors.grey[600],
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: isDarkMode ? Colors.white : Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeeklyAchievements() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDarkMode ? const Color(0xFF2D2D44) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
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
              const Icon(
                Icons.emoji_events,
                color: Color(0xFFFFA726),
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                "Conquistas da Semana",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: isDarkMode ? Colors.white : Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildAchievementChip(
            Icons.whatshot,
            "3 dias sem telas",
            const Color(0xFFFFF3E0),
            const Color(0xFFFF9800),
          ),
          const SizedBox(height: 8),
          _buildAchievementChip(
            Icons.stars,
            "Rotina estabelecida",
            const Color(0xFFE8F5E9),
            const Color(0xFF4CAF50),
          ),
        ],
      ),
    );
  }

  Widget _buildAchievementChip(
    IconData icon,
    String text,
    Color bgColor,
    Color iconColor,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: isDarkMode ? iconColor.withOpacity(0.2) : bgColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: iconColor),
          const SizedBox(width: 8),
          Text(
            text,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: isDarkMode ? Colors.white : Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStimulatedAreas() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Áreas Estimuladas",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: isDarkMode ? Colors.white : Colors.black87,
          ),
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            _buildAreaChip(
              Icons.directions_run,
              "Habilidades Motoras",
              const Color(0xFFE1BEE7),
              const Color(0xFF9C27B0),
            ),
            _buildAreaChip(
              Icons.palette,
              "Criatividade",
              const Color(0xFFFCE4EC),
              const Color(0xFFE91E63),
            ),
            _buildAreaChip(
              Icons.favorite,
              "Desenvolvimento Emocional",
              const Color(0xFFE3F2FD),
              const Color(0xFF2196F3),
            ),
            _buildAreaChip(
              Icons.groups,
              "Socialização",
              const Color(0xFFE8F5E9),
              const Color(0xFF4CAF50),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAreaChip(
    IconData icon,
    String text,
    Color bgColor,
    Color iconColor,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: isDarkMode ? iconColor.withOpacity(0.2) : bgColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18, color: iconColor),
          const SizedBox(width: 8),
          Text(
            text,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: isDarkMode ? Colors.white : Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeeklyActivities() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Atividades da Semana",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: isDarkMode ? Colors.white : Colors.black87,
          ),
        ),
        const SizedBox(height: 16),
        _buildActivityItem(
          Icons.search,
          "Caça ao Tesouro Sensorial",
          "25 min",
          "Habilidades Motoras",
          const Color(0xFFE1BEE7),
          const Color(0xFF9C27B0),
        ),
        _buildActivityItem(
          Icons.park,
          "Exploração ao Ar Livre",
          "45 min",
          "Socialização",
          const Color(0xFFE8F5E9),
          const Color(0xFF4CAF50),
        ),
        _buildActivityItem(
          Icons.palette,
          "Pintura com Dedos",
          "30 min",
          "Criatividade",
          const Color(0xFFFCE4EC),
          const Color(0xFFE91E63),
        ),
        _buildActivityItem(
          Icons.menu_book,
          "Contação de Hist��rias",
          "20 min",
          "Desenvolvimento Cognitivo",
          const Color(0xFFE3F2FD),
          const Color(0xFF2196F3),
        ),
        _buildActivityItem(
          Icons.emoji_events,
          "Circuito de Obstáculos",
          "35 min",
          "Coordenação Motora",
          const Color(0xFFFFE0B2),
          const Color(0xFFFF9800),
        ),
        _buildActivityItem(
          Icons.music_note,
          "Música e Movimento",
          "30 min",
          "Ritmo e Expressão",
          const Color(0xFFE1BEE7),
          const Color(0xFF9C27B0),
        ),
        _buildActivityItem(
          Icons.favorite,
          "Brincadeira de Faz de Conta",
          "40 min",
          "Desenvolvimento Emocional",
          const Color(0xFFFCE4EC),
          const Color(0xFFE91E63),
        ),
        _buildActivityItem(
          Icons.groups,
          "Quebra-Cabeça em Família",
          "25 min",
          "Raciocínio Lógico",
          const Color(0xFFE3F2FD),
          const Color(0xFF2196F3),
        ),
        _buildActivityItem(
          Icons.content_cut,
          "Recorte e Colagem",
          "30 min",
          "Habilidades Motoras Finas",
          const Color(0xFFE8F5E9),
          const Color(0xFF4CAF50),
        ),
      ],
    );
  }

  Widget _buildActivityItem(
    IconData icon,
    String title,
    String duration,
    String category,
    Color bgColor,
    Color iconColor,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDarkMode ? const Color(0xFF2D2D44) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: isDarkMode ? iconColor.withOpacity(0.2) : bgColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: iconColor, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: isDarkMode ? Colors.white : Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      duration,
                      style: TextStyle(
                        fontSize: 12,
                        color: isDarkMode ? Colors.white60 : Colors.grey[600],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        category,
                        style: TextStyle(
                          fontSize: 12,
                          color: isDarkMode ? Colors.white60 : Colors.grey[600],
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMotivationalCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDarkMode
              ? [const Color(0xFF3D2E4F), const Color(0xFF2D2D44)]
              : [const Color(0xFFFCE4EC), const Color(0xFFE1BEE7)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.favorite,
              color: Color(0xFFE91E63),
              size: 28,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            '"Pequenos momentos de brincadeira constroem grandes memórias."',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              fontStyle: FontStyle.italic,
              color: isDarkMode ? Colors.white : Colors.black87,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Cada atividade que você realiza com seu filho fortalece o vínculo entre vocês e contribui para o desenvolvimento integral dele. Continue criando esses momentos especiais juntos.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              color: isDarkMode ? Colors.white70 : Colors.black87,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 20),
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('✨', style: TextStyle(fontSize: 24)),
              SizedBox(width: 8),
              Text('💚', style: TextStyle(fontSize: 24)),
              SizedBox(width: 8),
              Text('⭐', style: TextStyle(fontSize: 24)),
            ],
          ),
        ],
      ),
    );
  }
}
