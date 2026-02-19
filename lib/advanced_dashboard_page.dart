import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class AdvancedDashboardPage extends StatefulWidget {
  const AdvancedDashboardPage({super.key});

  @override
  State<AdvancedDashboardPage> createState() => _AdvancedDashboardPageState();
}

class _AdvancedDashboardPageState extends State<AdvancedDashboardPage> {
  bool isDarkMode = false;
  String selectedPeriod = "Última semana";
  String selectedChild = "Sofia";
  String selectedChildAge = "5 anos";
  String selectedChildInitial = "S";

  final List<Map<String, String>> children = [
    {"name": "Sofia", "age": "5 anos", "initial": "S"},
    {"name": "Pedro", "age": "3 anos", "initial": "P"},
    {"name": "Maria", "age": "7 anos", "initial": "M"},
  ];

  void _showChildSelector() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: isDarkMode ? const Color(0xFF2D2D44) : Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Selecione a criança",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: isDarkMode ? Colors.white : Colors.black87,
              ),
            ),
            const SizedBox(height: 20),
            ...children.map((child) {
              return ListTile(
                leading: Container(
                  width: 40,
                  height: 40,
                  decoration: const BoxDecoration(
                    color: Color(0xFFE1BEE7),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      child["initial"]!,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Color(0xFF9C27B0),
                      ),
                    ),
                  ),
                ),
                title: Text(
                  child["name"]!,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: isDarkMode ? Colors.white : Colors.black87,
                  ),
                ),
                subtitle: Text(
                  child["age"]!,
                  style: TextStyle(
                    fontSize: 12,
                    color: isDarkMode ? Colors.white60 : Colors.grey[600],
                  ),
                ),
                onTap: () {
                  setState(() {
                    selectedChild = child["name"]!;
                    selectedChildAge = child["age"]!;
                    selectedChildInitial = child["initial"]!;
                  });
                  Navigator.pop(context);
                },
              );
            }).toList(),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: isDarkMode ? const Color(0xFF1A1A2E) : const Color(0xFFF8F9FA),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const SizedBox(height: 24),
              _buildFiltersAndActions(),
              const SizedBox(height: 24),
              _buildSummaryCards(),
              const SizedBox(height: 24),
              _buildOfflineTimeChart(),
              const SizedBox(height: 24),
              _buildActivitiesChart(),
              const SizedBox(height: 24),
              _buildDevelopmentDistribution(),
              const SizedBox(height: 24),
              _buildPerformanceByArea(),
              const SizedBox(height: 24),
              _buildInsightsCard(),
              const SizedBox(height: 24),
              _buildDetailedHistory(),
              const SizedBox(height: 24),
              _buildProfessionalNotes(),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Dashboard de Desenvolvimento",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                  color: isDarkMode ? Colors.white : Colors.black87,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                "Acompanhamento completo e analítico",
                style: TextStyle(
                  fontSize: 14,
                  color: isDarkMode ? Colors.white60 : Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
        GestureDetector(
          onTap: () {
            setState(() {
              isDarkMode = !isDarkMode;
            });
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
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
                  "Modo\nEscuro",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 10,
                    color: isDarkMode ? Colors.white : Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFiltersAndActions() {
    return Column(
      children: [
        // Seletor de criança (CLICÁVEL)
        GestureDetector(
          onTap: _showChildSelector,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: isDarkMode ? const Color(0xFF2D2D44) : Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: isDarkMode ? const Color(0xFF3D3D5C) : Colors.grey[300]!),
            ),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: const BoxDecoration(
                    color: Color(0xFFE1BEE7),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      selectedChildInitial,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Color(0xFF9C27B0),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    "$selectedChild ($selectedChildAge)",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: isDarkMode ? Colors.white : Colors.black87,
                    ),
                  ),
                ),
                Icon(Icons.keyboard_arrow_down, color: isDarkMode ? Colors.white60 : Colors.grey[600]),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: isDarkMode ? const Color(0xFF2D2D44) : Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: isDarkMode ? const Color(0xFF3D3D5C) : Colors.grey[300]!),
                ),
                child: Row(
                  children: [
                    Icon(Icons.calendar_today, size: 16, color: isDarkMode ? Colors.white60 : Colors.grey[600]),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        selectedPeriod,
                        style: TextStyle(
                          fontSize: 14,
                          color: isDarkMode ? Colors.white : Colors.black87,
                        ),
                      ),
                    ),
                    Icon(Icons.keyboard_arrow_down, color: isDarkMode ? Colors.white60 : Colors.grey[600]),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 12),
            _buildActionButton(Icons.file_download, Colors.grey[700]!),
            const SizedBox(width: 8),
            _buildActionButton(Icons.share, const Color(0xFF9C27B0)),
          ],
        ),
      ],
    );
  }

  Widget _buildActionButton(IconData icon, Color color) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: isDarkMode ? const Color(0xFF2D2D44) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: isDarkMode ? const Color(0xFF3D3D5C) : Colors.grey[300]!),
      ),
      child: Icon(icon, color: color, size: 20),
    );
  }

  Widget _buildSummaryCards() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildSummaryCard(
                Icons.access_time,
                "Tempo Offline Total",
                "8h 30min",
                "+12%",
                true,
                const Color(0xFFE3F2FD),
                const Color(0xFF2196F3),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildSummaryCard(
                Icons.check_circle,
                "Atividades Concluídas",
                "12",
                "+8%",
                true,
                const Color(0xFFE8F5E9),
                const Color(0xFF4CAF50),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildSummaryCard(
                Icons.trending_up,
                "Média Diária",
                "1.2h",
                "+5%",
                true,
                const Color(0xFFE1BEE7),
                const Color(0xFF9C27B0),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildSummaryCard(
                Icons.adjust,
                "Score de Consistência",
                "71%",
                "Bom",
                false,
                const Color(0xFFFFE0B2),
                const Color(0xFFFF9800),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSummaryCard(
    IconData icon,
    String label,
    String value,
    String comparison,
    bool isPositive,
    Color bgColor,
    Color iconColor,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
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
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: isDarkMode ? iconColor.withOpacity(0.2) : bgColor,
              borderRadius: BorderRadius.circular(12),
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
              fontSize: 24,
              color: isDarkMode ? Colors.white : Colors.black87,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            "${isPositive ? '' : ''}$comparison vs período anterior",
            style: TextStyle(
              fontSize: 11,
              color: isPositive ? Colors.green : (comparison == "Bom" ? Colors.red : Colors.grey),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOfflineTimeChart() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDarkMode ? const Color(0xFF2D2D44) : Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Evolução do Tempo Offline",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: isDarkMode ? Colors.white : Colors.black87,
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 200,
            child: LineChart(
              LineChartData(
                gridData: FlGridData(show: true, drawVerticalLine: false),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 40,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          value.toStringAsFixed(2),
                          style: TextStyle(fontSize: 10, color: isDarkMode ? Colors.white60 : Colors.grey),
                        );
                      },
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        const days = ['Seg', 'Ter', 'Qua', 'Qui', 'Sex', 'Sáb', 'Dom'];
                        if (value.toInt() >= 0 && value.toInt() < days.length) {
                          return Text(
                            days[value.toInt()],
                            style: TextStyle(fontSize: 10, color: isDarkMode ? Colors.white60 : Colors.grey),
                          );
                        }
                        return const Text('');
                      },
                    ),
                  ),
                  topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),
                borderData: FlBorderData(show: false),
                lineBarsData: [
                  LineChartBarData(
                    spots: [
                      FlSpot(0, 1.1),
                      FlSpot(1, 0.9),
                      FlSpot(2, 1.65),
                      FlSpot(3, 1.5),
                      FlSpot(4, 2.2),
                      FlSpot(5, 2.7),
                      FlSpot(6, 2.1),
                    ],
                    isCurved: true,
                    color: const Color(0xFF9C27B0),
                    barWidth: 3,
                    dotData: FlDotData(show: true),
                    belowBarData: BarAreaData(show: false),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActivitiesChart() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDarkMode ? const Color(0xFF2D2D44) : Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Atividades Realizadas",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: isDarkMode ? Colors.white : Colors.black87,
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 200,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                gridData: FlGridData(show: true, drawVerticalLine: false),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 40,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          value.toInt().toString(),
                          style: TextStyle(fontSize: 10, color: isDarkMode ? Colors.white60 : Colors.grey),
                        );
                      },
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        const days = ['Seg', 'Ter', 'Qua', 'Qui', 'Sex', 'Sáb', 'Dom'];
                        if (value.toInt() >= 0 && value.toInt() < days.length) {
                          return Text(
                            days[value.toInt()],
                            style: TextStyle(fontSize: 10, color: isDarkMode ? Colors.white60 : Colors.grey),
                          );
                        }
                        return const Text('');
                      },
                    ),
                  ),
                  topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),
                borderData: FlBorderData(show: false),
                barGroups: [
                  BarChartGroupData(x: 0, barRods: [BarChartRodData(toY: 2, color: const Color(0xFF4CAF50), width: 16)]),
                  BarChartGroupData(x: 1, barRods: [BarChartRodData(toY: 1, color: const Color(0xFF4CAF50), width: 16)]),
                  BarChartGroupData(x: 2, barRods: [BarChartRodData(toY: 3, color: const Color(0xFF4CAF50), width: 16)]),
                  BarChartGroupData(x: 3, barRods: [BarChartRodData(toY: 2, color: const Color(0xFF4CAF50), width: 16)]),
                  BarChartGroupData(x: 4, barRods: [BarChartRodData(toY: 2, color: const Color(0xFF4CAF50), width: 16)]),
                  BarChartGroupData(x: 5, barRods: [BarChartRodData(toY: 3, color: const Color(0xFF4CAF50), width: 16)]),
                  BarChartGroupData(x: 6, barRods: [BarChartRodData(toY: 2, color: const Color(0xFF4CAF50), width: 16)]),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDevelopmentDistribution() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDarkMode ? const Color(0xFF2D2D44) : Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Distribuição por Áreas de Desenvolvimento",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: isDarkMode ? Colors.white : Colors.black87,
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 200,
            child: PieChart(
              PieChartData(
                sectionsSpace: 2,
                centerSpaceRadius: 60,
                sections: [
                  PieChartSectionData(
                    value: 28,
                    color: const Color(0xFF9C27B0),
                    title: '28%',
                    radius: 50,
                    titleStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  PieChartSectionData(
                    value: 22,
                    color: const Color(0xFFE91E63),
                    title: '22%',
                    radius: 50,
                    titleStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  PieChartSectionData(
                    value: 20,
                    color: const Color(0xFF4CAF50),
                    title: '20%',
                    radius: 50,
                    titleStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  PieChartSectionData(
                    value: 18,
                    color: const Color(0xFF2196F3),
                    title: '18%',
                    radius: 50,
                    titleStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  PieChartSectionData(
                    value: 12,
                    color: const Color(0xFFFF9800),
                    title: '12%',
                    radius: 50,
                    titleStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          _buildLegendItem(const Color(0xFF9C27B0), "Motor", "28%"),
          _buildLegendItem(const Color(0xFFE91E63), "Emocional", "22%"),
          _buildLegendItem(const Color(0xFF4CAF50), "Social", "20%"),
          _buildLegendItem(const Color(0xFF2196F3), "Cognitivo", "18%"),
          _buildLegendItem(const Color(0xFFFF9800), "Criativo", "12%"),
        ],
      ),
    );
  }

  Widget _buildLegendItem(Color color, String label, String percentage) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Container(
            width: 16,
            height: 16,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14,
                color: isDarkMode ? Colors.white : Colors.black87,
              ),
            ),
          ),
          Text(
            percentage,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: isDarkMode ? Colors.white : Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPerformanceByArea() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDarkMode ? const Color(0xFF2D2D44) : Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  "Performance por Área de Desenvolvimento",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: isDarkMode ? Colors.white : Colors.black87,
                  ),
                ),
              ),
              _buildLegendDot(const Color(0xFF9C27B0), "Ponto Forte"),
              const SizedBox(width: 8),
              _buildLegendDot(const Color(0xFFFF9800), "Para Estimular"),
            ],
          ),
          const SizedBox(height: 24),
          _buildProgressBar(
            Icons.emoji_events,
            "Habilidades Motoras",
            85,
            const Color(0xFF9C27B0),
            isInclusive: true,
            isStrong: true,
          ),
          const SizedBox(height: 16),
          _buildProgressBar(
            Icons.favorite,
            "Desenvolvimento Emocional",
            78,
            const Color(0xFFE91E63),
            isInclusive: false,
            isStrong: false,
          ),
          const SizedBox(height: 16),
          _buildProgressBar(
            Icons.groups,
            "Socialização",
            72,
            const Color(0xFF4CAF50),
            isInclusive: true,
            isStrong: false,
          ),
          const SizedBox(height: 16),
          _buildProgressBar(
            Icons.psychology,
            "Desenvolvimento Cognitivo",
            68,
            const Color(0xFF2196F3),
            isInclusive: false,
            isStrong: false,
          ),
          const SizedBox(height: 16),
          _buildProgressBar(
            Icons.palette,
            "Criatividade",
            58,
            const Color(0xFFFF9800),
            isInclusive: true,
            isStrong: false,
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDarkMode ? const Color(0xFF3D3D5C) : const Color(0xFFF5F5F5),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Análise: ",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                    color: isDarkMode ? Colors.white : Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "A área de Habilidades Motoras está muito bem desenvolvida (85%). Recomendamos incluir mais atividades focadas em Criatividade para manter o desenvolvimento mais equilibrado.",
                  style: TextStyle(
                    fontSize: 12,
                    color: isDarkMode ? Colors.white70 : Colors.grey[700],
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLegendDot(Color color, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.circle, color: color, size: 8),
        const SizedBox(width: 4),
        Text(
          text,
          style: TextStyle(
            fontSize: 10,
            color: isDarkMode ? Colors.white70 : Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildProgressBar(
    IconData icon,
    String label,
    int percentage,
    Color color,
    {required bool isInclusive,
    required bool isStrong}
  ) {
    return Column(
      children: [
        Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: color, size: 18),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: isDarkMode ? Colors.white : Colors.black87,
                ),
              ),
            ),
            if (isInclusive)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0xFFE3F2FD),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.verified, size: 10, color: Colors.blue[700]),
                    const SizedBox(width: 4),
                    Text(
                      "Inclusivo",
                      style: TextStyle(fontSize: 9, color: Colors.blue[700]),
                    ),
                  ],
                ),
              ),
            const SizedBox(width: 8),
            if (isStrong)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF3E0),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.star, size: 10, color: Colors.orange[700]),
                    const SizedBox(width: 4),
                    Text(
                      "Ponto Forte",
                      style: TextStyle(fontSize: 9, color: Colors.orange[700]),
                    ),
                  ],
                ),
              ),
            const SizedBox(width: 8),
            Text(
              "$percentage%",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: isDarkMode ? Colors.white : Colors.black87,
              ),
            ),
            const SizedBox(width: 4),
            Icon(Icons.trending_up, size: 14, color: Colors.green),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: LinearProgressIndicator(
            value: percentage / 100,
            backgroundColor: isDarkMode ? const Color(0xFF3D3D5C) : Colors.grey[200],
            valueColor: AlwaysStoppedAnimation<Color>(color),
            minHeight: 8,
          ),
        ),
      ],
    );
  }

  Widget _buildInsightsCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFE1BEE7), Color(0xFFE3F2FD)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.lightbulb, color: Color(0xFF9C27B0), size: 24),
              const SizedBox(width: 8),
              Text(
                "Insights e Padrões",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: isDarkMode ? Colors.white : Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildInsightItem("Maior engajamento em atividades de movimento", Icons.directions_run),
          _buildInsightItem("Melhor desempenho em períodos da manhã", Icons.wb_sunny),
          _buildInsightItem("Atividades com menor esforço de substituição de tela", Icons.screen_lock_portrait),
        ],
      ),
    );
  }

  Widget _buildInsightItem(String text, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, size: 18, color: const Color(0xFF9C27B0)),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 13,
                color: isDarkMode ? Colors.white : Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailedHistory() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDarkMode ? const Color(0xFF2D2D44) : Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Histórico Detalhado de Atividades",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: isDarkMode ? Colors.white : Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "8 atividades registradas",
                    style: TextStyle(
                      fontSize: 12,
                      color: isDarkMode ? Colors.white60 : Colors.grey[600],
                    ),
                  ),
                ],
              ),
              TextButton.icon(
                onPressed: () {},
                icon: Icon(Icons.filter_list, size: 16, color: isDarkMode ? Colors.white : Colors.black87),
                label: Text(
                  "Filtrar",
                  style: TextStyle(color: isDarkMode ? Colors.white : Colors.black87),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildHistoryHeader(),
          const Divider(height: 20),
          _buildHistoryRow("Circuito de Obstáculos", "28/01/2026", "35 min"),
          _buildHistoryRow("Pintura com Dedos", "27/01/2026", "30 min"),
          _buildHistoryRow("Exploração ao Ar Livre", "26/01/2026", "45 min"),
          _buildHistoryRow("Contação de Histórias", "25/01/2026", "20 min"),
          _buildHistoryRow("Música e Movimento", "24/01/2026", "30 min"),
          _buildHistoryRow("Quebra-Cabeça em Família", "23/01/2026", "25 min"),
          _buildHistoryRow("Caça ao Tesouro Sensorial", "22/01/2026", "25 min"),
          _buildHistoryRow("Recorte e Colagem", "21/01/2026", "30 min"),
        ],
      ),
    );
  }

  Widget _buildHistoryHeader() {
    return Row(
      children: [
        Expanded(
          flex: 3,
          child: Text(
            "ATIVIDADE",
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: isDarkMode ? Colors.white60 : Colors.grey[600],
            ),
          ),
        ),
        Expanded(
          flex: 2,
          child: Text(
            "DATA",
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: isDarkMode ? Colors.white60 : Colors.grey[600],
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: Text(
            "DURAÇÃO",
            textAlign: TextAlign.right,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: isDarkMode ? Colors.white60 : Colors.grey[600],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHistoryRow(String activity, String date, String duration) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(
              activity,
              style: TextStyle(
                fontSize: 13,
                color: isDarkMode ? Colors.white : Colors.black87,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              date,
              style: TextStyle(
                fontSize: 13,
                color: isDarkMode ? Colors.white70 : Colors.grey[600],
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              duration,
              textAlign: TextAlign.right,
              style: TextStyle(
                fontSize: 13,
                color: isDarkMode ? Colors.white70 : Colors.grey[600],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfessionalNotes() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDarkMode ? const Color(0xFF2D2D44) : Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.notes, color: Color(0xFF9C27B0), size: 24),
                  const SizedBox(width: 8),
                  Text(
                    "Notas & Observações Profissionais",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: isDarkMode ? Colors.white : Colors.black87,
                    ),
                  ),
                ],
              ),
              Container(
                width: 40,
                height: 40,
                decoration: const BoxDecoration(
                  color: Color(0xFF9C27B0),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.add, color: Colors.white, size: 20),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            "Acompanhamento colaborativo de Sofia",
            style: TextStyle(
              fontSize: 12,
              color: isDarkMode ? Colors.white60 : Colors.grey[600],
            ),
          ),
          const SizedBox(height: 20),
          _buildProfessionalNote(
            "Dra. Ana Carolina",
            "Terapeuta Ocupacional",
            "20/01/2026",
            "Sofia demonstra excelente evolução nas atividades motoras finas. Recomendo manter a frequência de atividades artísticas, especialmente pintura e colagem. Observei maior concentração e controle dos movimentos.",
          ),
          const SizedBox(height: 16),
          _buildProfessionalNote(
            "Paula Souza",
            "Mãe",
            "15/01/2026",
            "Percebi que a Sofia tem muito mais disposição para brincar ao ar livre nas manhãs. Ela fica mais calma e focada após o dia quando iniciamos com atividades físicas. Vou tentar fortalecer essa rotina.",
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDarkMode ? const Color(0xFF3D3D5C) : const Color(0xFFF5F5F5),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const Icon(Icons.info_outline, color: Color(0xFF2196F3), size: 20),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    "Dicas para famílias: Pais, terapeutas e educadores compartilhem observações sobre o desenvolvimento da criança de forma colaborativa. Ideal para clínicas e escolas que acompanham múltiplas crianças.",
                    style: TextStyle(
                      fontSize: 11,
                      color: isDarkMode ? Colors.white70 : Colors.grey[700],
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfessionalNote(String name, String role, String date, String note) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDarkMode ? const Color(0xFF3D3D5C) : const Color(0xFFFAFAFA),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: isDarkMode ? const Color(0xFF4D4D6C) : Colors.grey[300]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: const BoxDecoration(
                  color: Color(0xFFE1BEE7),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.person, color: Color(0xFF9C27B0), size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: isDarkMode ? Colors.white : Colors.black87,
                      ),
                    ),
                    Text(
                      role,
                      style: TextStyle(
                        fontSize: 12,
                        color: isDarkMode ? Colors.white60 : Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                date,
                style: TextStyle(
                  fontSize: 11,
                  color: isDarkMode ? Colors.white60 : Colors.grey[600],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            note,
            style: TextStyle(
              fontSize: 13,
              color: isDarkMode ? Colors.white70 : Colors.grey[700],
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}