import 'package:app_twins/pages/registration_page/registration_page_view.dart';
import 'package:flutter/material.dart';

class RegistrationPageRouter {
  static Route<void> route({required String userType}) {
    return MaterialPageRoute<void>(
      builder: (_) => RegistrationPageView(userType: userType),
    );
  }

  static Future<void> go(BuildContext context, {required String userType}) {
    return Navigator.of(context).push(route(userType: userType));
  }
}
