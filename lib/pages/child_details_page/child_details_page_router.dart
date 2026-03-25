import 'package:app_twins/pages/objectives_selection_page/objectives_selection_page_router.dart';
import 'package:app_twins/pages/child_details_page/child_details_page_view.dart';
import 'package:flutter/material.dart';

class ChildDetailsPageRouter {
  static Route<void> route({
    required int quantidadeTotal,
    required int indiceAtual,
  }) {
    return MaterialPageRoute<void>(
      builder: (_) => ChildDetailsPageView(
        quantidadeTotal: quantidadeTotal,
        indiceAtual: indiceAtual,
      ),
    );
  }

  static Future<void> go({
    required BuildContext context,
    required int quantidadeTotal,
    required int indiceAtual,
  }) {
    return Navigator.of(context).push(
      route(quantidadeTotal: quantidadeTotal, indiceAtual: indiceAtual),
    );
  }

  static void goBack(BuildContext context) {
    Navigator.of(context).pop();
  }

  static Future<void> goToNextChild({
    required BuildContext context,
    required int quantidadeTotal,
    required int indiceAtual,
  }) {
    return go(
      context: context,
      quantidadeTotal: quantidadeTotal,
      indiceAtual: indiceAtual + 1,
    );
  }

  static Future<void> goToObjectivesSelection(BuildContext context) {
    return ObjectivesSelectionPageRouter.go(context);
  }
}
