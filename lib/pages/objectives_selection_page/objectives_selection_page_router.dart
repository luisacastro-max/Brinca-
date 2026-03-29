import 'package:app_twins/pages/objectives_selection_page/objectives_selection_page_view.dart';
import 'package:app_twins/model/onboarding_child_model.dart';
import 'package:flutter/material.dart';

class ObjectivesSelectionPageRouter {
  static Route<void> route({
    required List<OnboardingChildModel> childrenDrafts,
    required int currentChildIndex,
  }) {
    return MaterialPageRoute<void>(
      builder: (_) => ObjectivesSelectionPageView(
        childrenDrafts: childrenDrafts,
        currentChildIndex: currentChildIndex,
      ),
    );
  }

  static Future<void> go(
    BuildContext context, {
    required List<OnboardingChildModel> childrenDrafts,
    required int currentChildIndex,
  }) {
    return Navigator.of(context).push(
      route(
        childrenDrafts: childrenDrafts,
        currentChildIndex: currentChildIndex,
      ),
    );
  }

  static Future<void> goReplacement(
    BuildContext context, {
    required List<OnboardingChildModel> childrenDrafts,
    required int currentChildIndex,
  }) {
    return Navigator.of(context).pushReplacement(
      route(
        childrenDrafts: childrenDrafts,
        currentChildIndex: currentChildIndex,
      ),
    );
  }

  static void goBack(BuildContext context) {
    Navigator.of(context).pop();
  }
}
