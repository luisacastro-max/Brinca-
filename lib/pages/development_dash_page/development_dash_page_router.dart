import 'package:app_twins/pages/development_dash_page/development_dash_page_view.dart';
import 'package:flutter/material.dart';

class DevelopmentDashPageRouter {
  static Route<void> route() {
    return MaterialPageRoute<void>(
      builder: (_) => const DevelopmentDashPageView(),
    );
  }

  static Future<void> go(BuildContext context) {
    return Navigator.of(context).push(route());
  }

  static Future<void> goReplacement(BuildContext context) {
    return Navigator.of(context).pushReplacement(route());
  }
}
