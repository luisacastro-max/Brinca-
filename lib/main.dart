import 'package:app_twins/pages/activities_list_page/activities_list_page_view.dart';
import 'package:app_twins/pages/clinic_home_page/clinic_home_page_view.dart';
import 'package:app_twins/pages/home_page/home_page_view.dart';
import 'package:app_twins/pages/user_type_choice_page/user_type_choice_page_view.dart';
import 'package:app_twins/services/service.dart';
import 'package:flutter/material.dart';

import 'pages/activities_page/activities_page_view.dart';
import 'pages/development_dash_page/development_dash_page_view.dart';

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
  late final Future<BackendUser?> _currentUserFuture;

  @override
  void initState() {
    super.initState();
    _currentUserFuture = _loadCurrentUser();
  }

  Future<BackendUser?> _loadCurrentUser() async {
    final auth = ServiceSdk.instance.auth;
    final hasToken = await auth.isAuthenticated();
    if (!hasToken) return null;

    final currentUser = await auth.getCurrentUser();
    if (currentUser == null || currentUser.id.trim().isEmpty) {
      return null;
    }

    return currentUser;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<BackendUser?>(
      future: _currentUserFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final user = snapshot.data;
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
