import 'package:app_twins/pages/activities_page/activities_page_service.dart';
import 'package:app_twins/pages/activities_page/widgets/activity_details_header.dart';
import 'package:app_twins/pages/activities_page/widgets/activity_info_grid.dart';
import 'package:app_twins/pages/activities_page/widgets/activity_primary_button.dart';
import 'package:app_twins/pages/activities_page/widgets/adaptations_section.dart';
import 'package:app_twins/pages/activities_page/widgets/bullet_list_section.dart';
import 'package:app_twins/pages/activities_page/widgets/neurodivergence_card.dart';
import 'package:app_twins/pages/activities_page/widgets/steps_section.dart';
import 'package:flutter/material.dart';

class ActivitiesPageView extends StatefulWidget {
  const ActivitiesPageView({super.key, required this.activityId});

  final String activityId;

  @override
  State<ActivitiesPageView> createState() => _ActivitiesPageViewState();
}

class _ActivitiesPageViewState extends State<ActivitiesPageView> {
  final ActivitiesPageService _service = ActivitiesPageService();

  bool _isLoading = true;
  String? _errorMessage;
  ActivityDetailsModel? _details;
  ActivityProgressState _progressState = ActivityProgressState.notStarted;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final details = ActivityDetailsModel(
        id: '1',
        title: 'Caça ao Tesouro Sensorial',
        description:
            'Esconda objetos com texturas e aromas diferentes pela casa para os pequenos encontrarem usando apenas o tato e olfato.',
        isFree: true,
        durationLabel: '20-30 min',
        ageLabel: '3-5 anos',
        areaLabel: 'Habilidades Motoras',
        difficulty: 'Fácil',
        isNeurodivergentValid: true,
        neuroDescription:
            'Esta atividade é adequada para crianças neurodivergentes, pois permite adaptações e estimula diferentes áreas de desenvolvimento.',
        whyImportant: [
          'Desenvolve a percepção tátil e o reconhecimento de texturas',
          'Estimula a concentração e atenção aos detalhes',
          'Promove a exploração sensorial de forma lúdica',
          'Reduz dependência de estímulos visuais digitais',
        ],
        materials: [
          'Objetos de diferentes texturas (esponja, tecido, papel, plástico). Alternativa: Itens domésticos variados',
          'Venda ou lenço para cobrir os olhos. Alternativa: Pedir que a criança feche os olhos',
          'Cesta ou caixa para guardar os objetos',
        ],
        steps: [
          'Selecione 5-8 objetos de texturas variadas pela casa. Dica: Escolha itens seguros e de tamanhos adequados para a idade.',
          'Esconda os objetos em locais acessíveis do ambiente.',
          'Vende os olhos da criança ou peça para fechá-los.',
          'Guie a criança pela casa e incentive-a a explorar com as mãos. Dica: Use linguagem descritiva: Sente algo macio? Áspero? Liso?',
          'Quando encontrar um objeto, peça para descrever a textura antes de ver.',
          'Após todas as descobertas, conversem sobre as sensações experimentadas.',
        ],
        adaptations: [
          'Para crianças mais novas (2-3 anos): Use apenas 3-4 objetos grandes e texturas bem distintas. Mantenha os olhos abertos e foque na exploração tátil.',
          'Para crianças neurodivergentes: Permita que vejam os objetos primeiro. Respeite se não quiserem vendar os olhos. Foque no prazer da descoberta, não na competição.',
          'Para grupos: Cada criança pode esconder objetos para as outras encontrarem, desenvolvendo cooperação e revezamento.',
        ],
        adultTips: [
          'Observe quais texturas a criança prefere ou evita, isso pode indicar sensibilidades sensoriais',
          'Não force a criança a tocar algo que ela demonstre desconforto',
          'Celebre cada descoberta com entusiasmo genuíno',
          'Use a atividade para expandir vocabulário sensorial',
        ],
      );

      final progress = await _service.loadProgressState(widget.activityId);

      if (!mounted) return;
      setState(() {
        _details = details;
        _progressState = progress;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => _errorMessage = 'Erro ao carregar detalhes da atividade.');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _advanceProgress() async {
    final next = await _service.advanceProgress(widget.activityId, _progressState);
    if (!mounted) return;
    setState(() => _progressState = next);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      body: _buildBody(_details),
    );
  }

  Widget _buildBody(ActivityDetailsModel? details) {
    if (_isLoading) {
      return CustomScrollView(
        slivers: [
          _buildSliverAppBar(),
          const SliverFillRemaining(
            hasScrollBody: false,
            child: Center(child: CircularProgressIndicator()),
          ),
        ],
      );
    }

    if (_errorMessage != null) {
      return CustomScrollView(
        slivers: [
          _buildSliverAppBar(),
          SliverFillRemaining(
            hasScrollBody: false,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      _errorMessage!,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Color(0xFFB42318)),
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: _load,
                      child: const Text('Tentar novamente'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      );
    }

    if (details == null) {
      return CustomScrollView(
        slivers: [
          _buildSliverAppBar(),
          const SliverToBoxAdapter(child: SizedBox.shrink()),
        ],
      );
    }

    return CustomScrollView(
      slivers: [
        _buildSliverAppBar(),
        SliverToBoxAdapter(
          child: SafeArea(
            top: false,
            child: Column(
              children: [
                ActivityDetailsHeader(
                  title: details.title,
                  description: details.description,
                  isFree: details.isFree,
                ),
                Container(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    spacing: 18,
                    children: [
                      ActivityInfoGrid(
                        duration: details.durationLabel,
                        age: details.ageLabel,
                        area: details.areaLabel,
                        difficulty: details.difficulty,
                      ),
                      const SizedBox(height: 12),
                      NeurodivergenceCard(),
                      BulletListSection(
                        title: 'Por que esta atividade importa',
                        items: details.whyImportant,
                        emptyMessage: 'Nenhuma informação disponível.',
                        icon: Icons.lightbulb_outline,
                        backgroundColor: const Color(0xFFF0FDF4),
                        iconColor: const Color(0xFF00A63E),
                      ),
                      BulletListSection(
                        title: 'Materiais Necessarios',
                        items: details.materials,
                        emptyMessage: 'Nenhum material especificado.',
                        icon: Icons.inventory_2_outlined,
                        backgroundColor: Colors.white,
                        iconColor: const Color(0xFFF97316),
                      ),
                      StepsSection(steps: details.steps),
                      AdaptationsSection(
                        title: 'Adaptacoes e alternativas',
                        items: details.adaptations,
                        emptyMessage: 'Nenhuma adaptação especificada.',
                      ),
                      BulletListSection(
                        title: 'Dicas para adultos',
                        items: details.adultTips,
                        emptyMessage: 'Nenhuma dica especificada.',
                        icon: Icons.info_outline,
                        backgroundColor: const Color(0xFFEFF4FC),
                        iconColor: const Color(0xFF3B82F6),
                      ),
                      const SizedBox(height: 14),
                      ActivityPrimaryButton(
                        state: _progressState,
                        onPressed: _advanceProgress,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  SliverAppBar _buildSliverAppBar() {
    return SliverAppBar(
      pinned: false,
      floating: false,
      snap: false,
      backgroundColor: const Color(0xFFFFFFFF),
      elevation: 0,
      centerTitle: true,
      title: const Text(
        'Brinca+',
        style: TextStyle(
          color: Color(0xFF101828),
          fontWeight: FontWeight.w600,
          fontSize: 20,
        ),
      ),
      shape: const Border(
        bottom: BorderSide(color: Color(0xFFE5E9F0), width: 1),
      ),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Color(0xFF3A4558)),
        onPressed: () => Navigator.of(context).pop(),
      ),
    );
  }
}
