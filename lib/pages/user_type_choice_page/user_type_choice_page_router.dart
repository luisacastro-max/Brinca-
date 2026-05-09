import 'package:app_twins/pages/user_type_choice_page/user_type_choice_page_view.dart';
import 'package:flutter/material.dart';

class UserTypeChoicePageRouter {
  static Route<void> route() {
    return MaterialPageRoute<void>(
      builder: (_) => const UserTypeChoicePageView(),
    );
  }

  static Future<void> go(BuildContext context) {
    return Navigator.of(context).push(route());
  }

  static Future<void> goReplacement(BuildContext context) {
    return Navigator.of(context).pushReplacement(route());
  }
}
