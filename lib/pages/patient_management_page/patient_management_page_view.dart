import 'package:app_twins/pages/login_page/login_page_router.dart';
import 'package:app_twins/pages/patient_management_page/patient_management_page_service.dart';
import 'package:app_twins/pages/patient_management_page/widgets/patient_management_filters.dart';
import 'package:app_twins/pages/patient_management_page/widgets/patient_management_pagination.dart';
import 'package:app_twins/pages/patient_management_page/widgets/patient_management_patient_card.dart';
import 'package:app_twins/services/service.dart';
import 'package:flutter/material.dart';

class PatientManagementPageView extends StatefulWidget {
  const PatientManagementPageView({super.key});

  @override
  State<PatientManagementPageView> createState() =>
      _PatientManagementPageViewState();
}

class _PatientManagementPageViewState extends State<PatientManagementPageView> {
  final PatientManagementPageService _service = PatientManagementPageService();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController _searchController = TextEditingController();

  static const int _pageSize = 10;

  bool _isLoading = true;
  String? _errorMessage;
  List<PatientManagementPatient> _allPatients = const [];

  String _searchTerm = '';
  String _selectedAgeRange = 'all';
  String _selectedEngagement = 'all';
  int _currentPage = 1;

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
        _allPatients = data.patients;
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
      setState(() => _errorMessage = 'Erro ao carregar pacientes.');
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filteredPatients();
    final totalPages = _totalPages(filtered.length);
    final currentPage = _currentPage.clamp(1, totalPages);
    final visiblePatients = _pageSlice(filtered, currentPage);

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: const Color(0xFFF9FAFB),
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
        child: _buildBody(
          visiblePatients: visiblePatients,
          totalPages: totalPages,
          currentPage: currentPage,
        ),
      ),
    );
  }

  Widget _buildBody({
    required List<PatientManagementPatient> visiblePatients,
    required int totalPages,
    required int currentPage,
  }) {
    if (_isLoading && _allPatients.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_errorMessage != null && _allPatients.isEmpty) {
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

    final filteredCount = _filteredPatients().length;

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
      children: [
        const Text(
          'Gestao de Pacientes',
          style: TextStyle(
            color: Color(0xFF101828),
            fontWeight: FontWeight.w600,
            fontSize: 24,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Acompanhe o progresso de todos os pacientes ativos',
          style: TextStyle(
            color: Color(0xFF4A5565),
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 32),
        PatientManagementFilters(
          searchController: _searchController,
          onSearchChanged: (value) {
            setState(() {
              _searchTerm = value;
              _currentPage = 1;
            });
          },
          selectedAgeRange: _selectedAgeRange,
          onAgeRangeChanged: (value) {
            setState(() {
              _selectedAgeRange = value;
              _currentPage = 1;
            });
          },
          selectedEngagement: _selectedEngagement,
          onEngagementChanged: (value) {
            setState(() {
              _selectedEngagement = value;
              _currentPage = 1;
            });
          },
        ),
        const SizedBox(height: 24),
        if (filteredCount == 0)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: const Color(0xFFFFFFFF),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFE5E7EB)),
            ),
            child: const Text(
              'Nenhum paciente encontrado com os filtros atuais.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Color(0xFF6B7280)),
            ),
          )
        else
          Column(
            children: [
              for (var i = 0; i < visiblePatients.length; i++) ...[
                PatientManagementPatientCard(patient: visiblePatients[i]),
                if (i < visiblePatients.length - 1) const SizedBox(height: 12),
              ],
            ],
          ),
        const SizedBox(height: 12),
        PatientManagementPagination(
          currentPage: currentPage,
          totalPages: totalPages,
          onPrev: () {
            setState(() {
              if (_currentPage > 1) _currentPage -= 1;
            });
          },
          onNext: () {
            setState(() {
              if (_currentPage < totalPages) _currentPage += 1;
            });
          },
        ),
      ],
    );
  }

  List<PatientManagementPatient> _filteredPatients() {
    return _allPatients.where((patient) {
      final searchOk = _searchTerm.trim().isEmpty ||
          patient.name.toLowerCase().contains(_searchTerm.trim().toLowerCase());

      final ageOk = _selectedAgeRange == 'all' ||
          patient.ageRangeCode.trim() == _selectedAgeRange;

      final engagementOk = _selectedEngagement == 'all' ||
          _engagementFilterValue(patient.engagementLevel) == _selectedEngagement;

      return searchOk && ageOk && engagementOk;
    }).toList();
  }

  int _totalPages(int itemCount) {
    if (itemCount <= 0) return 1;
    return (itemCount / _pageSize).ceil();
  }

  List<PatientManagementPatient> _pageSlice(
    List<PatientManagementPatient> items,
    int page,
  ) {
    if (items.isEmpty) return const [];

    final safePage = page.clamp(1, _totalPages(items.length));
    final start = (safePage - 1) * _pageSize;
    var end = start + _pageSize;
    if (end > items.length) end = items.length;

    return items.sublist(start, end);
  }

  String _engagementFilterValue(PatientEngagementLevel level) {
    if (level == PatientEngagementLevel.high) return 'high';
    if (level == PatientEngagementLevel.medium) return 'medium';
    return 'low';
  }
}
