import 'package:app_twins/pages/activities_list_page/activities_list_page_router.dart';
import 'package:app_twins/pages/development_dash_page/development_dash_page_router.dart';
import 'package:app_twins/pages/home_page/home_page_service.dart';
import 'package:app_twins/pages/home_page/widgets/home_action_card.dart';
import 'package:app_twins/pages/home_page/widgets/home_drawer_header.dart';
import 'package:app_twins/pages/home_page/widgets/home_drawer_item.dart';
import 'package:app_twins/pages/home_page/widgets/home_week_summary_card.dart';
import 'package:app_twins/pages/login_page/login_page_router.dart';
import 'package:app_twins/progress_dashboard_page.dart';
import 'package:flutter/material.dart';

import '../../services/core/service_exception.dart';

class HomePageView extends StatefulWidget {
  const HomePageView({super.key});

  @override
  State<HomePageView> createState() => _HomePageViewState();
}

class _HomePageViewState extends State<HomePageView> {
  final HomePageService _service = HomePageService();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  bool _isLoading = true;
  String? _errorMessage;
  HomePageViewData? _data;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final data = await _service.loadData();
      if (!mounted) return;
      setState(() => _data = data);
    } on ServiceException catch (e) {
      if (!mounted) return;

      if (e.statusCode == 401 || e.statusCode == 403) {
        await Navigator.of(
          context,
        ).pushAndRemoveUntil(LoginPageRouter.route(), (_) => false);
        return;
      }

      setState(() => _errorMessage = e.message);
    } catch (e) {
      if (!mounted) return;
      setState(() => _errorMessage = 'Erro ao carregar home: $e');
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _logout() async {
    await _service.logout();
    if (!mounted) return;
    await Navigator.of(
      context,
    ).pushAndRemoveUntil(LoginPageRouter.route(), (_) => false);
  }

  @override
  Widget build(BuildContext context) {
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
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Color(0xFF3A4558), size: 24),
          onPressed: () => _scaffoldKey.currentState?.openDrawer(),
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
      drawer: _buildDrawer(),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_errorMessage != null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(_errorMessage!),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _loadData,
              child: const Text('Tentar novamente'),
            ),
          ],
        ),
      );
    }

    final data = _data;
    if (data == null) return const SizedBox.shrink();

    return ListView(
      padding: const EdgeInsets.fromLTRB(18, 36, 18, 18),
      children: [
        const Text(
          'Bem-vinda de volta!',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w700,
            color: Color(0xFF101828),
          ),
        ),
        const SizedBox(height: 4),
        const Text(
          'Veja o progresso da sua familia',
          style: TextStyle(fontSize: 14, color: Color(0xFF5A6578)),
        ),
        const SizedBox(height: 28),
        HomeActionCard(
          icon: Icons.auto_awesome_outlined,
          iconColors: const [Color(0xFFA76EE7), Color(0xFF5DB5EA)],
          title: 'Atividades',
          subtitle: 'Explore atividades offline para seus filhos',
          onTap: () {
            ActivitiesListPageRouter.go(context);
          },
        ),
        const SizedBox(height: 14),
        HomeActionCard(
          icon: Icons.bar_chart_outlined,
          iconColors: const [Color(0xFF3AAEF0), Color(0xFF41C7E4)],
          title: 'Desenvolvimento',
          subtitle: 'Acompanhe o progresso detalhado',
          onTap: () {
            DevelopmentDashPageRouter.go(context);
          },
        ),
        const SizedBox(height: 14),
        HomeActionCard(
          icon: Icons.trending_up,
          iconColors: const [Color(0xFFC975F0), Color(0xFFFF89B4)],
          title: 'Progresso Semanal',
          subtitle: 'Veja o resumo da semana',
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const ProgressDashboardPage()),
            );
          },
        ),
        const SizedBox(height: 14),
        HomeWeekSummaryCard(
          completedActivitiesThisWeek: data.completedActivitiesThisWeek,
        ),
      ],
    );
  }

  Widget _buildDrawer() {
    final data = _data;
    final userName = data?.userName ?? 'Usuario';
    final userInitial = data?.userInitial ?? 'U';
    final planLabel = data?.planLabel ?? 'Plano Gratuito';

    return SizedBox(
      child: Drawer(
        backgroundColor: const Color(0xFFFFFFFF),
        surfaceTintColor: Colors.transparent,
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFFCE7F3), Color(0xFFCEFAFE)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(18, 12, 10, 10),
                  child: Row(
                    children: [
                      const Expanded(
                        child: Text(
                          'Brinca+',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF1E2738),
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: const Icon(
                          Icons.close,
                          color: Color(0xFF3B4659),
                          size: 20,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              HomeDrawerHeader(
                userName: userName,
                userInitial: userInitial,
                planLabel: planLabel,
              ),
              const SizedBox(height: 10),
              HomeDrawerItem(
                icon: Icons.home_outlined,
                label: 'Inicio',
                selected: true,
                onTap: () => Navigator.of(context).pop(),
              ),
              HomeDrawerItem(
                icon: Icons.monitor_heart_outlined,
                label: 'Atividades',
                onTap: () {
                  Navigator.of(context).pop();
                  ActivitiesListPageRouter.go(context);
                },
              ),
              HomeDrawerItem(
                icon: Icons.query_stats_outlined,
                label: 'Relatorio de Desenvolvimento',
                onTap: () {
                  Navigator.of(context).pop();
                  DevelopmentDashPageRouter.go(context);
                },
              ),
              HomeDrawerItem(
                icon: Icons.insert_chart_outlined,
                label: 'Progresso Semanal',
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const ProgressDashboardPage(),
                    ),
                  );
                },
              ),
              HomeDrawerItem(
                icon: Icons.credit_card_outlined,
                label: 'Planos e Assinatura',
                onTap: () {
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Tela em desenvolvimento.')),
                  );
                },
              ),
              HomeDrawerItem(
                icon: Icons.people_alt_outlined,
                label: 'Configuracao Inicial',
                onTap: () {
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Tela em desenvolvimento.')),
                  );
                },
              ),
              HomeDrawerItem(
                icon: Icons.settings_outlined,
                label: 'Configuracoes',
                onTap: () {
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Tela em desenvolvimento.')),
                  );
                },
              ),
              const Spacer(),
              const Divider(height: 1),
              const SizedBox(height: 8),
              HomeDrawerItem(
                icon: Icons.logout_outlined,
                label: 'Sair',
                danger: true,
                onTap: () async {
                  Navigator.of(context).pop();
                  await _logout();
                },
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }
}
