import 'package:app_twins/pages/children_list_page/children_list_page_view.dart';
import 'package:flutter/material.dart';

class ChildrenListPageRouter {
  static Route<void> route() {
    return MaterialPageRoute<void>(
      builder: (_) => const ChildrenListPageView(),
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

  static void goBack(BuildContext context) {
    Navigator.of(context).pop();
  }
}
