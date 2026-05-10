import 'package:app_twins/pages/patient_management_page/patient_management_page_view.dart';
import 'package:flutter/material.dart';

class PatientManagementPageRouter {
  static Route<void> route() {
    return MaterialPageRoute<void>(
      builder: (_) => const PatientManagementPageView(),
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
