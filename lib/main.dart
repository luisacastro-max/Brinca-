import 'package:app_twins/pages/home_page/home_page_view.dart';
import 'package:app_twins/pages/login_page/login_page_view.dart';
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
  late final Future<bool> _hasSessionFuture;

  @override
  void initState() {
    super.initState();
    _hasSessionFuture = _hasValidSession();
  }

  Future<bool> _hasValidSession() async {
    final auth = ServiceSdk.instance.auth;
    final hasToken = await auth.isAuthenticated();
    if (!hasToken) return false;

    final currentUser = await auth.getCurrentUser();
    return currentUser != null && currentUser.id.trim().isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _hasSessionFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.data == true) {
          return const HomePageView();
        }

        return const LoginPageView();
      },
    );
  }
}
