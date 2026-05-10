import 'package:app_twins/pages/login_page/login_page_router.dart';
import 'package:app_twins/pages/recommend_page_page/recommend_page_page_service.dart';
import 'package:app_twins/pages/recommend_page_page/widgets/recommend_activity_card.dart';
import 'package:app_twins/pages/recommend_page_page/widgets/recommend_filters_panel.dart';
import 'package:app_twins/pages/recommend_page_page/widgets/recommend_patient_picker_dialog.dart';
import 'package:app_twins/services/service.dart';
import 'package:flutter/material.dart';

class RecommendPagePageView extends StatefulWidget {
  const RecommendPagePageView({super.key});

  @override
  State<RecommendPagePageView> createState() => _RecommendPagePageViewState();
}

class _RecommendPagePageViewState extends State<RecommendPagePageView> {
  final RecommendPagePageService _service = RecommendPagePageService();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController _searchController = TextEditingController();

  bool _isLoading = true;
  String? _errorMessage;

  List<RecommendActivityItem> _allActivities = const [];
  List<RecommendPatientOption> _patients = const [];
  List<String> _objectiveFilters = const [];

  String _searchTerm = '';
  Set<String> _selectedObjectives = <String>{};

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final data = await _service.loadData();
      if (!mounted) return;

      setState(() {
        _allActivities = data.activities;
        _patients = data.patients;
        _objectiveFilters = data.objectiveFilters;
      });
    } on ServiceException catch (e) {
      if (!mounted) return;

      if (e.statusCode == 401 || e.statusCode == 403) {
        await Navigator.of(
          context,
        ).pushAndRemoveUntil(LoginPageRouter.route(), (_) => false);
        return;
      }

      setState(() => _errorMessage = e.message);
    } catch (_) {
      if (!mounted) return;
      setState(() => _errorMessage = 'Erro ao carregar atividades recomendadas.');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final visibleActivities = _filteredActivities();

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: const Color(0xFFF3F4F6),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFFFFF),
        elevation: 0,
        centerTitle: true,
        shape: const Border(
          bottom: BorderSide(color: Color(0xFFE5E9F0), width: 1),
        ),
        leadingWidth: 98,
        leading: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back, color: Color(0xFF3A4558)),
              onPressed: () => Navigator.of(context).maybePop(),
            ),
          ],
        ),
        title: const Text(
          'Brinca+',
          style: TextStyle(
            color: Color(0xFF101828),
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _load,
        child: _buildBody(visibleActivities),
      ),
    );
  }

  Widget _buildBody(List<RecommendActivityItem> visibleActivities) {
    if (_isLoading && _allActivities.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_errorMessage != null && _allActivities.isEmpty) {
      return ListView(
        children: [
          const SizedBox(height: 90),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
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
        ],
      );
    }

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
      children: [
        const Text(
          'Recomendar Atividades',
          style: TextStyle(
            color: Color(0xFF101828),
            fontWeight: FontWeight.w600,
            fontSize: 24,
          ),
        ),
        const SizedBox(height: 6),
        const Text(
          'Selecione atividades personalizadas para seus pacientes',
          style: TextStyle(
            color: Color(0xFF4A5565),
            fontSize: 16,
            height: 1.3,
          ),
        ),
        const SizedBox(height: 32),
        RecommendFiltersPanel(
          searchController: _searchController,
          onSearchChanged: (value) {
            setState(() => _searchTerm = value);
          },
          selectedObjectives: _selectedObjectives,
          onObjectivesChanged: (values) {
            setState(() => _selectedObjectives = values);
          },
          onClearObjectives: () => setState(() => _selectedObjectives = <String>{}),
          availableObjectives: _objectiveFilters,
        ),
        const SizedBox(height: 32),
        if (visibleActivities.isEmpty)
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: const Color(0xFFFFFFFF),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFE5E7EB)),
            ),
            child: const Text(
              'Nenhuma atividade encontrada para os filtros atuais.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Color(0xFF6B7280)),
            ),
          )
        else
          Column(
            children: [
              for (var i = 0; i < visibleActivities.length; i++) ...[
                RecommendActivityCard(
                  item: visibleActivities[i],
                  onTap: () => _onSelectActivity(visibleActivities[i]),
                ),
                if (i < visibleActivities.length - 1)
                  const SizedBox(height: 16),
              ],
            ],
          ),
      ],
    );
  }

  Future<void> _onSelectActivity(RecommendActivityItem item) async {
    if (_patients.isEmpty) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Nenhum paciente encontrado para recomendar atividade.'),
        ),
      );
      return;
    }

    final selected = await showDialog<RecommendPatientOption>(
      context: context,
      builder: (_) => RecommendPatientPickerDialog(
        patients: _patients,
        activityTitle: item.title,
      ),
    );

    if (!mounted || selected == null) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Atividade "${item.title}" recomendada para ${selected.name}.',
        ),
      ),
    );
  }

  List<RecommendActivityItem> _filteredActivities() {
    return _allActivities.where((item) {
      final searchOk = _searchTerm.trim().isEmpty ||
          item.title.toLowerCase().contains(_searchTerm.trim().toLowerCase());

      final objectiveOk = _selectedObjectives.isEmpty ||
          item.developmentGoals.any((goal) {
            final normalizedGoal = goal.trim().toLowerCase();
            for (final selected in _selectedObjectives) {
              if (normalizedGoal == selected.trim().toLowerCase()) {
                return true;
              }
            }
            return false;
          });

      return searchOk && objectiveOk;
    }).toList();
  }
}
