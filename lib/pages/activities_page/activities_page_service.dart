import 'package:app_twins/services/service.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum ActivityProgressState { notStarted, started, completed }

class ActivityDetailsModel {
  const ActivityDetailsModel({
    required this.id,
    required this.title,
    required this.description,
    required this.isFree,
    required this.durationLabel,
    required this.ageLabel,
    required this.areaLabel,
    required this.difficulty,
    required this.isNeurodivergentValid,
    required this.neuroDescription,
    required this.whyImportant,
    required this.materials,
    required this.steps,
    required this.adaptations,
    required this.adultTips,
  });

  final String id;
  final String title;
  final String description;
  final bool isFree;

  final String durationLabel;
  final String ageLabel;
  final String areaLabel;
  final String difficulty;

  final bool isNeurodivergentValid;
  final String neuroDescription;

  final List<String> whyImportant;
  final List<String> materials;
  final List<String> steps;
  final List<String> adaptations;
  final List<String> adultTips;
}

class ActivitiesPageService {
  ActivitiesPageService({ActivitiesApi? activitiesApi})
    : _activitiesApi = activitiesApi ?? ServiceSdk.instance.activities;

  final ActivitiesApi _activitiesApi;

  static const String _startedIdsKey = 'started_activity_ids';
  static const String _completedIdsKey = 'completed_activity_ids';

  Future<ActivityDetailsModel> loadActivity(String activityId) async {
    final json = await _activitiesApi.getActivityById(activityId);

    final goals = _asStringList(json['developmentGoals']);
    final objectives = _asStringList(json['objectives']);

    final whyImportant = _firstFilled([
      _asStringList(json['benefits']),
      _asStringList(json['whyImportant']),
      objectives,
    ]);

    final materials = _firstFilled([
      _asStringList(json['materials']),
      _asStringList(json['requiredMaterials']),
    ]);

    final steps = _firstFilled([
      _asStringList(json['steps']),
      _asStringList(json['stepByStep']),
      _splitLines(json['instructions']),
    ]);

    final adaptations = _firstFilled([
      _asStringList(json['adaptations']),
      _asStringList(json['alternatives']),
      _asStringList(json['adaptationsAndAlternatives']),
    ]);

    final adultTips = _firstFilled([
      _asStringList(json['adultTips']),
      _asStringList(json['tipsForAdults']),
      _asStringList(json['tips']),
    ]);

    final durationMinutes = _asInt(json['durationMinutes']);
    final ageRange = (json['ageRange'] ?? '').toString();

    return ActivityDetailsModel(
      id: (json['_id'] ?? json['id'] ?? '').toString(),
      title: (json['title'] ?? 'Atividade').toString(),
      description: (json['description'] ?? 'Sem descricao.').toString(),
      isFree: _asBool(json['isFree']),
      durationLabel: durationMinutes <= 0
          ? 'Nao informado'
          : '$durationMinutes min',
      ageLabel: _formatAgeRange(ageRange),
      areaLabel: goals.isEmpty ? 'Nao informado' : goals.first,
      difficulty: (json['difficulty'] ?? 'Nao informado').toString(),
      isNeurodivergentValid: _asBool(json['neurodivergenceValidated']),
      neuroDescription:
          (json['neurodivergenceDescription'] ??
                  'Sem observacoes especificas para neurodivergencia.')
              .toString(),
      whyImportant: whyImportant,
      materials: materials,
      steps: steps,
      adaptations: adaptations,
      adultTips: adultTips,
    );
  }

  Future<ActivityProgressState> loadProgressState(String activityId) async {
    final prefs = await SharedPreferences.getInstance();
    final completedIds = (prefs.getStringList(_completedIdsKey) ?? const <String>[]).toSet();
    if (completedIds.contains(activityId)) {
      return ActivityProgressState.completed;
    }

    final startedIds = (prefs.getStringList(_startedIdsKey) ?? const <String>[]).toSet();
    if (startedIds.contains(activityId)) {
      return ActivityProgressState.started;
    }

    return ActivityProgressState.notStarted;
  }

  Future<ActivityProgressState> advanceProgress(
    String activityId,
    ActivityProgressState current,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    final startedIds = (prefs.getStringList(_startedIdsKey) ?? const <String>[])
        .toSet();
    final completedIds =
        (prefs.getStringList(_completedIdsKey) ?? const <String>[]).toSet();

    if (current == ActivityProgressState.notStarted) {
      startedIds.add(activityId);
      await prefs.setStringList(_startedIdsKey, startedIds.toList());
      return ActivityProgressState.started;
    }

    if (current == ActivityProgressState.started) {
      startedIds.remove(activityId);
      completedIds.add(activityId);
      await prefs.setStringList(_startedIdsKey, startedIds.toList());
      await prefs.setStringList(_completedIdsKey, completedIds.toList());
      return ActivityProgressState.completed;
    }

    return ActivityProgressState.completed;
  }

  List<String> _asStringList(dynamic value) {
    if (value is List) {
      return value
          .map((item) => item.toString().trim())
          .where((item) => item.isNotEmpty)
          .toList();
    }

    if (value is String && value.trim().isNotEmpty) {
      return <String>[value.trim()];
    }

    return const <String>[];
  }

  List<String> _splitLines(dynamic value) {
    if (value is! String || value.trim().isEmpty) return const <String>[];
    return value
        .split('\n')
        .map((line) => line.trim())
        .where((line) => line.isNotEmpty)
        .toList();
  }

  List<String> _firstFilled(List<List<String>> candidates) {
    for (final list in candidates) {
      if (list.isNotEmpty) return list;
    }
    return const <String>[];
  }

  int _asInt(dynamic value) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.tryParse(value?.toString() ?? '') ?? 0;
  }

  bool _asBool(dynamic value) {
    if (value is bool) return value;
    if (value is num) return value != 0;

    final normalized = (value ?? '').toString().trim().toLowerCase();
    return normalized == 'true' ||
        normalized == '1' ||
        normalized == 'yes' ||
        normalized == 'sim';
  }

  String _formatAgeRange(String value) {
    if (value.contains('-')) {
      final parts = value.split('-');
      if (parts.length == 2) {
        return '${parts[0]}-${parts[1]} anos';
      }
    }

    return value.trim().isEmpty ? 'Nao informado' : value;
  }
}
