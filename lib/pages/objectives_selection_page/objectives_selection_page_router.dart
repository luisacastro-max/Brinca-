import 'package:app_twins/pages/objectives_selection_page/objectives_selection_page_view.dart';
import 'package:flutter/material.dart';

class ObjectivesSelectionPageRouter {
  static Route<void> route() {
    return MaterialPageRoute<void>(
      builder: (_) => const ObjectivesSelectionPageView(),
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
