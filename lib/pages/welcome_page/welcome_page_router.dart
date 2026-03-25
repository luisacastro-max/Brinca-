import 'package:app_twins/pages/children_selection_page/children_selection_page_view.dart';
import 'package:app_twins/pages/welcome_page/welcome_page_view.dart';
import 'package:flutter/material.dart';

class WelcomePageRouter {
  static Route<void> route() {
    return MaterialPageRoute<void>(
      builder: (_) => const WelcomePageView(),
    );
  }

  static Future<void> go(BuildContext context) {
    return Navigator.of(context).push(route());
  }

  static Future<void> goReplacement(BuildContext context) {
    return Navigator.of(context).pushReplacement(route());
  }

  static Future<void> goToChildrenSelection(BuildContext context) {
    return Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => const ChildrenSelectionPageView(),
      ),
    );
  }
}
