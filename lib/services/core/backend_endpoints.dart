class BackendEndpoints {

  static const String authRegister = '/api/auth/register';
  static const String authLogin = '/api/auth/login';

  static const String users = '/api/users';

  static const String children = '/api/children';

  static const String activities = '/api/activities';
  static String activityById(String id) => '/api/activities/$id';
  static String activitiesRecommended(String childId) =>
      '/api/activities/recommended/$childId';

  static const String plans = '/api/plans';
  static String planById(String id) => '/api/plans/$id';
}
