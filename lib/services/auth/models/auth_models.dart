class BackendUser {
  final String id;
  final String name;
  final String email;
  final String userType;
  final bool isPremium;
  final String? premiumActivatedAt;
  final String? premiumPlanCode;

  const BackendUser({
    required this.id,
    required this.name,
    required this.email,
    required this.userType,
    required this.isPremium,
    this.premiumActivatedAt,
    this.premiumPlanCode,
  });

  factory BackendUser.fromJson(Map<String, dynamic> json) {
    return BackendUser(
      id: (json['id'] ?? json['_id'] ?? '').toString(),
      name: (json['name'] ?? '').toString(),
      email: (json['email'] ?? '').toString(),
      userType: (json['userType']).toString().toUpperCase(),
      isPremium: _asBool(json['isPremium']),
      premiumActivatedAt: _asNullableString(json['premiumActivatedAt']),
      premiumPlanCode: _asNullableString(json['premiumPlanCode']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'userType': userType,
      'isPremium': isPremium,
      'premiumActivatedAt': premiumActivatedAt,
      'premiumPlanCode': premiumPlanCode,
    };
  }

  static bool _asBool(dynamic value) {
    if (value is bool) return value;
    if (value is num) return value != 0;

    final normalized = (value ?? '').toString().trim().toLowerCase();
    return normalized == 'true' || normalized == '1' || normalized == 'yes';
  }

  static String? _asNullableString(dynamic value) {
    final text = (value ?? '').toString().trim();
    return text.isEmpty ? null : text;
  }
}

class AuthSession {
  final String token;
  final BackendUser user;

  const AuthSession({
    required this.token,
    required this.user,
  });

  factory AuthSession.fromJson(Map<String, dynamic> json) {
    final user = Map<String, dynamic>.from(json['user'] as Map? ?? {});
    return AuthSession(
      token: (json['token'] ?? '').toString(),
      user: BackendUser.fromJson(user),
    );
  }
}
