import 'package:app_twins/pages/recommend_page_page/recommend_page_page_view.dart';
import 'package:flutter/material.dart';

class RecommendPageRouter {
  static Route<void> route() {
    return MaterialPageRoute<void>(
      builder: (_) => const RecommendPagePageView(),
    );
  }

  static Future<void> go(BuildContext context) {
    return Navigator.of(context).push(route());
  }

  static Future<void> goReplacement(BuildContext context) {
    return Navigator.of(context).pushReplacement(route());
  }

  static void goBack(BuildContext context) {
    Navigator.of(context).pop();
  }
}
