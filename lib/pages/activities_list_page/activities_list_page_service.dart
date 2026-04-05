import 'package:app_twins/services/service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ActivityListItem {
  ActivityListItem({
    required this.id,
    required this.title,
    required this.description,
    required this.durationLabel,
    required this.ageRange,
    required this.difficulty,
    required this.isNeurodivergenceValid,
    required this.isFree,
  });

  final String id;
  final String title;
  final String description;
  final String durationLabel;
  final String ageRange;
  final String difficulty;
  final bool isNeurodivergenceValid;
  final bool isFree;
}

class ActivitiesListPageData {
  const ActivitiesListPageData({
    required this.activities,
    required this.savedActivityIds,
  });

  final List<ActivityListItem> activities;
  final Set<String> savedActivityIds;
}

class ActivitiesListPageService {
  ActivitiesListPageService({ActivitiesApi? activitiesApi})
    : _activitiesApi = activitiesApi ?? ServiceSdk.instance.activities;

  final ActivitiesApi _activitiesApi;
  static const String _savedIdsKey = 'saved_activity_ids';

  Future<ActivitiesListPageData> loadPageData() async {
    final activitiesJson = await _activitiesApi.getActivities();
    final savedIds = await loadSavedActivityIds();

    final items = activitiesJson.map(_mapFromApi).toList();
    return ActivitiesListPageData(activities: items, savedActivityIds: savedIds);
  }

  Future<Set<String>> loadSavedActivityIds() async {
    final prefs = await SharedPreferences.getInstance();
    final ids = prefs.getStringList(_savedIdsKey) ?? const <String>[];
    return ids.toSet();
  }

  Future<Set<String>> toggleSaved(String activityId) async {
    final prefs = await SharedPreferences.getInstance();
    final current = await loadSavedActivityIds();

    if (current.contains(activityId)) {
      current.remove(activityId);
    } else {
      current.add(activityId);
    }

    await prefs.setStringList(_savedIdsKey, current.toList());
    return current;
  }

  ActivityListItem _mapFromApi(Map<String, dynamic> json) {
    final id = (json['_id'] ?? json['id'] ?? '').toString();
    final title = (json['title'] ?? 'Atividade sem titulo').toString();
    final description = (json['description'] ?? '').toString();

    final duration = _parseDuration(json['durationMinutes']);
    final durationLabel = '$duration min';

    final ageRange = (json['ageRange'] ?? 'Nao informado').toString();
    final difficulty = (json['difficulty'] ?? 'Nao informado').toString();

    final isNeurodivergenceValid = _asBool(json['neurodivergenceValidated']);

    final isFree = _asBool(json['isFree']);

    return ActivityListItem(
      id: id,
      title: title,
      description: description,
      durationLabel: durationLabel,
      ageRange: ageRange,
      difficulty: difficulty,
      isNeurodivergenceValid: isNeurodivergenceValid,
      isFree: isFree,
    );
  }

  int _parseDuration(dynamic value) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.tryParse(value?.toString() ?? '') ?? 0;
  }

  bool _asBool(dynamic value) {
    if (value is bool) return value;
    if (value is num) return value != 0;
    final text = (value ?? '').toString().toLowerCase().trim();
    return text == 'true' || text == '1' || text == 'yes';
  }
}
