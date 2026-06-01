import 'package:flutter/material.dart';

class UserTypeChoiceOption {
  const UserTypeChoiceOption({
    required this.code,
    required this.title,
    required this.description,
    required this.icon,
    required this.registrationUserType,
  });

  final String code;
  final String title;
  final String description;
  final IconData icon;
  final String registrationUserType;
}

class UserTypeChoicePageService {
  const UserTypeChoicePageService();

  List<UserTypeChoiceOption> getOptions() {
    return const <UserTypeChoiceOption>[
      UserTypeChoiceOption(
        code: 'PARENT',
        title: 'Responsável',
        description: 'Para pais e responsáveis acompanharem o desenvolvimento da criança',
        icon: Icons.family_restroom,
        registrationUserType: 'PARENT',
      ),
      UserTypeChoiceOption(
        code: 'CLINIC',
        title: 'Clínica',
        description: 'Para profissionais acompanharem pacientes e indicarem atividades',
        icon: Icons.psychology,
        registrationUserType: 'CLINIC',
      ),
      UserTypeChoiceOption(
        code: 'INSTITUTION',
        title: 'Instituição',
        description: 'Para escolas e organizações aplicarem atividades em grupo',
        icon: Icons.account_balance,
        registrationUserType: 'CLINIC',
      ),
    ];
  }

  String registrationTypeFor(UserTypeChoiceOption option) {
    final normalized = option.registrationUserType.trim().toUpperCase();
    if (normalized == 'PARENT' || normalized == 'CLINIC') {
      return normalized;
    }

    throw StateError('registrationUserType inválido para cadastro.');
  }
}
