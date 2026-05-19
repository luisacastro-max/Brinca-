import 'package:app_twins/services/service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ActivityListItem {
  ActivityListItem({
    required this.id,
    required this.title,
    required this.description,
    required this.durationLabel,
    required this.ageLabel,
    required this.areaLabel,
    required this.difficulty,
    required this.isNeurodivergenceValid,
    required this.isFree,
  });

  final String id;
  final String title;
  final String description;
  final String durationLabel;
  final String ageLabel;
  final String areaLabel;
  final String difficulty;
  final bool isNeurodivergenceValid;
  final bool isFree;
}

class ActivitiesListPageData {
  const ActivitiesListPageData({
    required this.activities,
    required this.savedActivityIds,
    required this.isCurrentUserPremium,
  });

  final List<ActivityListItem> activities;
  final Set<String> savedActivityIds;
  final bool isCurrentUserPremium;
}

class ActivitiesListPageService {
  ActivitiesListPageService({
    ActivitiesApi? activitiesApi,
    UsersApi? usersApi,
  }) : _activitiesApi = activitiesApi ?? ServiceSdk.instance.activities,
       _usersApi = usersApi ?? ServiceSdk.instance.users;

  final ActivitiesApi _activitiesApi;
  final UsersApi _usersApi;
  static const String _savedIdsKey = 'saved_activity_ids';

  Future<ActivitiesListPageData> loadPageData() async {
    final activitiesJson = await _activitiesApi.getActivities();
    final savedIds = await loadSavedActivityIds();
    final isCurrentUserPremium = await _loadCurrentUserPremium();

    final items = activitiesJson.map(_mapFromApi).toList();
    return ActivitiesListPageData(
      activities: items,
      savedActivityIds: savedIds,
      isCurrentUserPremium: isCurrentUserPremium,
    );
  }

  Future<bool> _loadCurrentUserPremium() async {
    try {
      final profile = await _usersApi.getCurrentUserProfile();
      return _asBool(profile?['isPremium']);
    } catch (_) {
      return false;
    }
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

    final durationLabel = _readString(
      json,
      keys: const ['durationLabel'],
      fallback: _legacyDurationLabel(json['durationMinutes']),
    );
    final ageLabel = _readString(
      json,
      keys: const ['ageLabel', 'ageRange'],
      fallback: 'Nao informado',
    );
    final areaLabel = _readString(
      json,
      keys: const ['areaLabel'],
      fallback: 'Sem area',
    );
    final difficulty = _readString(
      json,
      keys: const ['difficulty'],
      fallback: 'Nao informado',
    );

    final isNeurodivergenceValid = _asBool(
      json['isNeurodivergentValid'] ?? json['neurodivergenceValidated'],
    );

    final isFree = _asBool(json['isFree']);

    return ActivityListItem(
      id: id,
      title: title,
      description: description,
      durationLabel: durationLabel,
      ageLabel: ageLabel,
      areaLabel: areaLabel,
      difficulty: difficulty,
      isNeurodivergenceValid: isNeurodivergenceValid,
      isFree: isFree,
    );
  }

  String _legacyDurationLabel(dynamic value) {
    final duration = _parseDuration(value);
    return '$duration min';
  }

  String _readString(
    Map<String, dynamic> json, {
    required List<String> keys,
    required String fallback,
  }) {
    for (final key in keys) {
      final value = json[key];
      if (value == null) continue;
      final text = value.toString().trim();
      if (text.isNotEmpty) return text;
    }
    return fallback;
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
