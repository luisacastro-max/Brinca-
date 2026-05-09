class BackendUser {
  final String id;
  final String name;
  final String email;
  final String userType;

  const BackendUser({
    required this.id,
    required this.name,
    required this.email,
    required this.userType,
  });

  factory BackendUser.fromJson(Map<String, dynamic> json) {
    return BackendUser(
      id: (json['id'] ?? json['_id'] ?? '').toString(),
      name: (json['name'] ?? '').toString(),
      email: (json['email'] ?? '').toString(),
      userType: (json['userType']).toString().toUpperCase(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'userType': userType,
    };
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
