import 'package:app_twins/pages/login_page/login_page_view.dart';
import 'package:flutter/material.dart';

class LoginPageRouter {
  static Route<void> route() {
    return MaterialPageRoute<void>(
      builder: (_) => const LoginPageView(),
    );
  }

  static Future<void> go(BuildContext context) {
    return Navigator.of(context).push(route());
  }

  static Future<void> goReplacement(BuildContext context) {
    return Navigator.of(context).pushReplacement(route());
  }
}
