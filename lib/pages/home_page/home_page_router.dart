import 'package:app_twins/pages/home_page/home_page_view.dart';
import 'package:flutter/material.dart';

class HomePageRouter {
  static Route<void> route() {
    return MaterialPageRoute<void>(builder: (_) => const HomePageView());
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
