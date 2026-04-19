class BackendEndpoints {
  static const String authRegister = '/api/auth/register';
  static const String authLogin = '/api/auth/login';

  static const String users = '/api/users';

  static const String children = '/api/children';

  static const String activities = '/api/activities';
  static const String activitiesByIds = '/api/activities/by-ids';
  static String activityById(String id) => '/api/activities/$id';
  static String activitiesRecommended(String childId) =>
      '/api/activities/recommended/$childId';

  static const String plans = '/api/plans';
  static String planById(String id) => '/api/plans/$id';

  static const String completedActivities = '/api/completed-activities';
  static const String completedActivitiesStart =
      '/api/completed-activities/start';
  static const String completedActivitiesComplete =
      '/api/completed-activities/complete';
  static String completedActivitiesByChild(String childId) =>
      '/api/completed-activities/$childId/completed';
}
