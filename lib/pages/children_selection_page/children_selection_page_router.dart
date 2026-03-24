import 'package:app_twins/pages/child_details_page/child_details_page_router.dart';
import 'package:app_twins/pages/children_selection_page/children_selection_page_view.dart';
import 'package:flutter/material.dart';

class ChildrenSelectionPageRouter {
  static Route<void> route() {
    return MaterialPageRoute<void>(
      builder: (_) => const ChildrenSelectionPageView(),
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

  static Future<void> goToChildDetails({
    required BuildContext context,
    required int quantidadeTotal,
  }) {
    return ChildDetailsPageRouter.go(
      context: context,
      quantidadeTotal: quantidadeTotal,
      indiceAtual: 1,
    );
  }
}
