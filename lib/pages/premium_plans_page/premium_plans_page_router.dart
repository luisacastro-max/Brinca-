import 'package:app_twins/pages/premium_plans_page/premium_plans_page_view.dart';
import 'package:flutter/material.dart';

class PremiumPlansPageRouter {
  static Route<void> route() {
    return MaterialPageRoute<void>(
      builder: (_) => const PremiumPlansPageView(),
    );
  }

  static Future<void> go(BuildContext context) {
    return Navigator.of(context).push(route());
  }

  static Future<void> goReplacement(BuildContext context) {
    return Navigator.of(context).pushReplacement(route());
  }
}
