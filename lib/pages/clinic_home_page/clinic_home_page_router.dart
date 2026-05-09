import 'package:app_twins/pages/clinic_home_page/clinic_home_page_view.dart';
import 'package:flutter/material.dart';

class ClinicHomePageRouter {
  static Route<void> route() {
    return MaterialPageRoute<void>(
      builder: (_) => const ClinicHomePageView(),
    );
  }

  static Future<void> go(BuildContext context) {
    return Navigator.of(context).push(route());
  }

  static Future<void> goReplacement(BuildContext context) {
    return Navigator.of(context).pushReplacement(route());
  }

  static Future<void> goAndClearStack(BuildContext context) {
    return Navigator.of(context).pushAndRemoveUntil(route(), (_) => false);
  }
}
