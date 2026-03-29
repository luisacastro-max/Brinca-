import 'package:app_twins/pages/objectives_selection_page/objectives_selection_page_router.dart';
import 'package:app_twins/pages/child_details_page/child_details_page_view.dart';
import 'package:app_twins/model/onboarding_child_model.dart';
import 'package:flutter/material.dart';

class ChildDetailsPageRouter {
  static Route<void> route({
    required int quantidadeTotal,
    required int indiceAtual,
    required List<OnboardingChildModel> childrenDrafts,
  }) {
    return MaterialPageRoute<void>(
      builder: (_) => ChildDetailsPageView(
        quantidadeTotal: quantidadeTotal,
        indiceAtual: indiceAtual,
        childrenDrafts: childrenDrafts,
      ),
    );
  }

  static Future<void> go({
    required BuildContext context,
    required int quantidadeTotal,
    required int indiceAtual,
    required List<OnboardingChildModel> childrenDrafts,
  }) {
    return Navigator.of(context).push(
      route(
        quantidadeTotal: quantidadeTotal,
        indiceAtual: indiceAtual,
        childrenDrafts: childrenDrafts,
      ),
    );
  }

  static void goBack(BuildContext context) {
    Navigator.of(context).pop();
  }

  static Future<void> goToNextChild({
    required BuildContext context,
    required int quantidadeTotal,
    required int indiceAtual,
    required List<OnboardingChildModel> childrenDrafts,
  }) {
    return go(
      context: context,
      quantidadeTotal: quantidadeTotal,
      indiceAtual: indiceAtual + 1,
      childrenDrafts: childrenDrafts,
    );
  }

  static Future<void> goToObjectivesSelection({
    required BuildContext context,
    required List<OnboardingChildModel> childrenDrafts,
  }) {
    return ObjectivesSelectionPageRouter.go(
      context,
      childrenDrafts: childrenDrafts,
      currentChildIndex: 0,
    );
  }
}
