import 'package:app_twins/pages/activities_page/activities_page_view.dart';
import 'package:flutter/material.dart';

class ActivitiesPageRouter {
  static Route<void> route({required String activityId}) {
    return MaterialPageRoute<void>(
      builder: (_) => ActivitiesPageView(activityId: activityId),
    );
  }

  static Future<void> go(BuildContext context, {required String activityId}) {
    return Navigator.of(context).push(route(activityId: activityId));
  }
}
