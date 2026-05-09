import 'package:app_twins/pages/login_page/login_page_router.dart';
import 'package:app_twins/pages/registration_page/registration_page_router.dart';
import 'package:app_twins/pages/user_type_choice_page/user_type_choice_page_service.dart';
import 'package:app_twins/pages/user_type_choice_page/widgets/user_type_choice_actions.dart';
import 'package:app_twins/pages/user_type_choice_page/widgets/user_type_choice_option_card.dart';
import 'package:flutter/material.dart';

class UserTypeChoicePageView extends StatefulWidget {
  const UserTypeChoicePageView({super.key});

  @override
  State<UserTypeChoicePageView> createState() => _UserTypeChoicePageViewState();
}

class _UserTypeChoicePageViewState extends State<UserTypeChoicePageView> {
  final UserTypeChoicePageService _service = const UserTypeChoicePageService();

  late final List<UserTypeChoiceOption> _options;
  String? _selectedCode;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _options = _service.getOptions();
  }

  Future<void> _onContinue() async {
    UserTypeChoiceOption? selected;
    for (final option in _options) {
      if (option.code == _selectedCode) {
        selected = option;
        break;
      }
    }

    if (selected == null) return;

    setState(() => _isLoading = true);

    try {
      final registrationUserType = _service.registrationTypeFor(selected);
      await RegistrationPageRouter.go(
        context,
        userType: registrationUserType,
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F8),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(14, 20, 14, 12),
          child: Column(
            children: [
              const Text(
                'Brinca+',
                style: TextStyle(
                  fontSize: 35 / 1.6,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF1F2937),
                ),
              ),
              const SizedBox(height: 8),
              Container(
                width: 68,
                height: 68,
                decoration: BoxDecoration(
                  color: const Color(0xFFF8EFE6),
                  shape: BoxShape.circle,
                  border: Border.all(color: const Color(0xFFE6D7C7)),
                ),
                child: const Center(
                  child: Text(
                    '🎨',
                    style: TextStyle(fontSize: 28),
                  ),
                ),
              ),
              const SizedBox(height: 18),
              const Text(
                'Como voce deseja entrar?',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 26 / 1.5,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF1F2937),
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'Escolha o perfil que melhor descreve voce',
                style: TextStyle(fontSize: 13, color: Color(0xFF6B7280)),
              ),
              const SizedBox(height: 14),
              Expanded(
                child: ListView.separated(
                  itemCount: _options.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final option = _options[index];
                    return UserTypeChoiceOptionCard(
                      title: option.title,
                      description: option.description,
                      icon: option.icon,
                      selected: _selectedCode == option.code,
                      onTap: () => setState(() => _selectedCode = option.code),
                    );
                  },
                ),
              ),
              const SizedBox(height: 8),
              UserTypeChoiceActions(
                canContinue: _selectedCode != null,
                isLoading: _isLoading,
                onContinue: _onContinue,
                onLogin: () => LoginPageRouter.go(context),
              ),
              const SizedBox(height: 4),
              const Text(
                'Ao continuar, voce concorda com nossos Termos de Uso e Politica de Privacidade',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 10, color: Color(0xFF9CA3AF)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
