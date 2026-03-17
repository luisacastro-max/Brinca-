import 'package:app_twins/pages/registration_page/registration_page_view.dart';
import 'package:flutter/material.dart';

class RegistrationPageRouter {
  static Route<void> route() {
    return MaterialPageRoute<void>(
      builder: (_) => const RegistrationPageView(),
    );
  }

  static Future<void> go(BuildContext context) {
    return Navigator.of(context).push(route());
  }
}
