import 'package:app_twins/model/onboarding_child_model.dart';
import 'package:app_twins/services/service.dart';

class ObjectivesSelectionPageService {
  ObjectivesSelectionPageService({ChildrenApi? childrenApi})
    : _childrenApi = childrenApi ?? ServiceSdk.instance.children;

  final ChildrenApi _childrenApi;

  Future<void> createChildren(List<OnboardingChildModel> childrenDrafts) async {
    for (final child in childrenDrafts) {
      if (child.name.trim().isEmpty ||
          child.ageOptionIndex == null ||
          child.timeOptionIndex == null) {
        throw const ServiceException(
          statusCode: 400,
          message: 'Dados obrigatorios de uma ou mais criancas estao incompletos.',
        );
      }

      await _childrenApi.createChild(
        name: child.name.trim(),
        ageRange: _mapAgeToBackend(child.ageOptionIndex!),
        dailyTime: _mapTimeToBackend(child.timeOptionIndex!),
        interests: child.interests,
        developmentGoals: child.developmentGoals,
      );
    }
  }

  String _mapAgeToBackend(int ageOptionIndex) {
    if (ageOptionIndex <= 2) return '0-3';
    if (ageOptionIndex <= 5) return '4-6';
    return '7-9';
  }

  int _mapTimeToBackend(int timeOptionIndex) {
    const mappedTimes = [15, 30, 45, 60, 60];
    if (timeOptionIndex < 0 || timeOptionIndex >= mappedTimes.length) {
      return 30;
    }
    return mappedTimes[timeOptionIndex];
  }
}
