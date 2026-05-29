import 'package:app_twins/pages/progress_dashboard_page/progress_dashboard_page_view.dart';
import 'package:flutter/material.dart';

class ProgressDashboardPageRouter {
  static Route<void> route() {
    return MaterialPageRoute<void>(
      builder: (_) => const ProgressDashboardPageView(),
    );
  }

  static Future<void> go(BuildContext context) {
    return Navigator.of(context).push(route());
  }

  static Future<void> goReplacement(BuildContext context) {
    return Navigator.of(context).pushReplacement(route());
  }
}
