import 'package:app_twins/model/onboarding_child_model.dart';
import 'package:app_twins/pages/premium_plans_page/premium_plans_page_view.dart';
import 'package:flutter/material.dart';

class PremiumPlansPageRouter {
  static Route<void> route({
    List<OnboardingChildModel>? pendingChildrenDrafts,
  }) {
    return MaterialPageRoute<void>(
      builder: (_) => PremiumPlansPageView(
        pendingChildrenDrafts: pendingChildrenDrafts,
      ),
    );
  }

  static Future<void> go(
    BuildContext context, {
    List<OnboardingChildModel>? pendingChildrenDrafts,
  }) {
    return Navigator.of(context).push(
      route(pendingChildrenDrafts: pendingChildrenDrafts),
    );
  }

  static Future<void> goReplacement(
    BuildContext context, {
    List<OnboardingChildModel>? pendingChildrenDrafts,
  }) {
    return Navigator.of(context).pushReplacement(
      route(pendingChildrenDrafts: pendingChildrenDrafts),
    );
  }
}
