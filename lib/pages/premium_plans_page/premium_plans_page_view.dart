import 'package:app_twins/pages/premium_plans_page/premium_plans_page_service.dart';
import 'package:app_twins/pages/premium_plans_page/widgets/premium_plan_card.dart';
import 'package:app_twins/services/service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

class PremiumPlansPageView extends StatefulWidget {
  const PremiumPlansPageView({super.key});

  @override
  State<PremiumPlansPageView> createState() => _PremiumPlansPageViewState();
}

class _PremiumPlansPageViewState extends State<PremiumPlansPageView> {
  final PremiumPlansPageService _service = PremiumPlansPageService();

  bool _isLoading = true;
  String? _errorMessage;
  List<PremiumPlanItem> _plans = const <PremiumPlanItem>[];
  String? _processingPlanId;

  @override
  void initState() {
    super.initState();
    _loadPlans();
  }

  Future<void> _loadPlans() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final plans = await _service.loadPlans();
      if (!mounted) return;

      setState(() {
        _plans = plans;
      });
    } on ServiceException catch (e) {
      if (!mounted) return;
      setState(() => _errorMessage = e.message);
    } catch (_) {
      if (!mounted) return;
      setState(() => _errorMessage = 'Erro ao carregar planos de assinatura.');
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _handlePlanAction(PremiumPlanItem plan) async {
    if (plan.ctaType != 'checkout') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Nosso time comercial entrara em contato em breve.'),
        ),
      );
      return;
    }

    setState(() => _processingPlanId = plan.id);

    try {
      await _service.checkoutPlan(plan);
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Pagamento concluido com sucesso.'),
        ),
      );
    } on StripeException catch (e) {
      if (!mounted) return;
      final message = e.error.localizedMessage ?? 'Pagamento cancelado.';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    } on ServiceException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message)),
      );
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Nao foi possivel processar o pagamento.')),
      );
    } finally {
      if (mounted) {
        setState(() => _processingPlanId = null);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F4F7),
      appBar: AppBar(
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
      ),
      body: RefreshIndicator(
        onRefresh: _loadPlans,
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
          children: [
            const Icon(
              Icons.favorite_border,
              color: Color(0xFF98A2B3),
              size: 24,
            ),
            const SizedBox(height: 12),
            const Text(
              'Escolha o plano ideal para sua familia ou instituicao',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 32 / 1.65,
                height: 1.3,
                fontWeight: FontWeight.w700,
                color: Color(0xFF101828),
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Desenvolvemos solucoes personalizadas e acessiveis para reducao de tempo de tela, com atividades personalizadas e acompanhamento especializado.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                height: 1.45,
                color: Color(0xFF667085),
              ),
            ),
            const SizedBox(height: 18),
            _buildContent(),
          ],
        ),
      ),
    );
  }

  Widget _buildContent() {
    if (_isLoading && _plans.isEmpty) {
      return const Padding(
        padding: EdgeInsets.only(top: 20),
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (_errorMessage != null && _plans.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Text(
              _errorMessage!,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Color(0xFFB42318)),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _loadPlans,
              child: const Text('Tentar novamente'),
            ),
          ],
        ),
      );
    }

    if (_plans.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 20),
        child: Text(
          'Nenhum plano disponivel no momento.',
          textAlign: TextAlign.center,
          style: TextStyle(color: Color(0xFF667085)),
        ),
      );
    }

    return Column(
      children: [
        for (var i = 0; i < _plans.length; i++) ...[
          PremiumPlanCard(
            plan: _plans[i],
            isLoading: _processingPlanId == _plans[i].id,
            onPressed: () => _handlePlanAction(_plans[i]),
            icon: _iconForPlan(_plans[i].code),
            iconBackground: _iconBgForPlan(_plans[i].code),
            iconColor: _iconColorForPlan(_plans[i].code),
            accentBorder: _borderColorForPlan(_plans[i].code),
            buttonGradient: _buttonGradientForPlan(_plans[i]),
            buttonBorderGradient: _buttonBorderGradientForPlan(_plans[i]),
          ),
          if (i < _plans.length - 1) const SizedBox(height: 14),
        ],
      ],
    );
  }

  IconData _iconForPlan(String code) {
    if (code == 'premium-familiar') return Icons.family_restroom_outlined;
    if (code == 'profissional') return Icons.groups_2_outlined;
    if (code == 'institucional') return Icons.corporate_fare_outlined;
    return Icons.workspace_premium_outlined;
  }

  Color _iconBgForPlan(String code) {
    if (code == 'premium-familiar') return const Color(0xFFFFFFFF);
    if (code == 'profissional') return const Color(0xFFDDF7F6);
    if (code == 'institucional') return const Color(0xFFE7ECFF);
    return const Color(0xFFEFF4FC);
  }

  Color _iconColorForPlan(String code) {
    if (code == 'premium-familiar') return const Color(0xFF1BAAD5);
    if (code == 'profissional') return const Color(0xFF0AA0A8);
    if (code == 'institucional') return const Color(0xFF2467F5);
    return const Color(0xFF3B82F6);
  }

  Color _borderColorForPlan(String code) {
    if (code == 'premium-familiar') return const Color(0xFFA2F4FD);
    if (code == 'profissional') return const Color(0xFFF3F4F6);
    if (code == 'institucional') return const Color(0xFFF3F4F6);
    return const Color(0xFFD0D5DD);
  }

  List<Color>? _buttonGradientForPlan(PremiumPlanItem plan) {
    if (plan.ctaType != 'checkout') return null;
    return const [Color(0xFFFB64B6), Color(0xFF00D3F3)];
  }

  List<Color>? _buttonBorderGradientForPlan(PremiumPlanItem plan) {
    if (plan.ctaType != 'checkout') return null;
    return const [Color(0xFFFDA5D5), Color(0xFF53EAFD), Color(0xFF8EC5FF)];
  }
}
