import 'package:app_twins/pages/clinic_home_page/clinic_home_page_view.dart';
import 'package:app_twins/pages/home_page/home_page_view.dart';
import 'package:app_twins/pages/login_page/login_page_view.dart';
import 'package:app_twins/pages/user_type_choice_page/user_type_choice_page_view.dart';
import 'package:app_twins/services/core/backend_session_store.dart';
import 'package:app_twins/services/core/service_exception.dart';
import 'package:app_twins/services/service.dart';
import 'package:flutter/material.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Twins APP',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const AppSessionGate(),
    );
  }
}

class AppSessionGate extends StatefulWidget {
  const AppSessionGate({super.key});

  @override
  State<AppSessionGate> createState() => _AppSessionGateState();
}

class _AppSessionGateState extends State<AppSessionGate> {
  late final Future<_SessionGateResult> _sessionFuture;

  @override
  void initState() {
    super.initState();
    _sessionFuture = _resolveSession();
  }

  Future<_SessionGateResult> _resolveSession() async {
    final auth = ServiceSdk.instance.auth;
    final hasToken = await auth.isAuthenticated();
    if (!hasToken) {
      return const _SessionGateResult.noSession();
    }

    try {
      final profile = await ServiceSdk.instance.users.getCurrentUserProfile();
      if (profile == null) {
        await auth.logout();
        return const _SessionGateResult.invalidToken();
      }

      await BackendSessionStore.instance.saveUser(profile);
      return _SessionGateResult.valid(
        BackendUser.fromJson(profile),
      );
    } on ServiceException catch (e) {
      if (e.statusCode == 401 || e.statusCode == 403) {
        await auth.logout();
        return const _SessionGateResult.invalidToken();
      }

      final fallbackUser = await auth.getCurrentUser();
      if (fallbackUser != null && fallbackUser.id.trim().isNotEmpty) {
        return _SessionGateResult.valid(fallbackUser);
      }

      return const _SessionGateResult.noSession();
    } catch (_) {
      await auth.logout();
      return const _SessionGateResult.invalidToken();
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<_SessionGateResult>(
      future: _sessionFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final result = snapshot.data ?? const _SessionGateResult.noSession();
        final user = result.user;

        if (result.redirectToLogin) {
          return const LoginPageView();
        }

        if (user != null) {
          final userType = user.userType.trim().toUpperCase();
          if (userType == 'CLINIC') {
            return const ClinicHomePageView();
          }
          return const HomePageView();
        }

        return const UserTypeChoicePageView();
      },
    );
  }
}

class _SessionGateResult {
  const _SessionGateResult({
    required this.user,
    required this.redirectToLogin,
  });

  const _SessionGateResult.valid(BackendUser value)
    : user = value,
      redirectToLogin = false;

  const _SessionGateResult.noSession()
    : user = null,
      redirectToLogin = false;

  const _SessionGateResult.invalidToken()
    : user = null,
      redirectToLogin = true;

  final BackendUser? user;
  final bool redirectToLogin;
}
