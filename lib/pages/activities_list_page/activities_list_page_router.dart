import 'package:app_twins/pages/activities_list_page/activities_list_page_view.dart';
import 'package:flutter/material.dart';

class ActivitiesListPageRouter {
  static Route<void> route() {
    return MaterialPageRoute<void>(builder: (_) => const ActivitiesListPageView());
  }

  static Future<void> go(BuildContext context) {
    return Navigator.of(context).push(route());
  }

  static Future<void> goReplacement(BuildContext context) {
    return Navigator.of(context).pushReplacement(route());
  }
}
