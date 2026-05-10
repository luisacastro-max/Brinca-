import 'package:app_twins/services/service.dart';

class RecommendActivityItem {
  const RecommendActivityItem({
    required this.id,
    required this.title,
    required this.description,
    required this.durationLabel,
    required this.ageRangeLabel,
    required this.developmentGoals,
    required this.isInclusive,
    required this.isLowCost,
    required this.isQuick,
  });

  final String id;
  final String title;
  final String description;
  final String durationLabel;
  final String ageRangeLabel;
  final List<String> developmentGoals;
  final bool isInclusive;
  final bool isLowCost;
  final bool isQuick;
}

class RecommendPageData {
  const RecommendPageData({
    required this.activities,
    required this.objectiveFilters,
    required this.patients,
    required this.userName,
  });

  final List<RecommendActivityItem> activities;
  final List<String> objectiveFilters;
  final List<RecommendPatientOption> patients;
  final String userName;
}

class RecommendPatientOption {
  const RecommendPatientOption({
    required this.id,
    required this.name,
    required this.initials,
    required this.ageRangeLabel,
  });

  final String id;
  final String name;
  final String initials;
  final String ageRangeLabel;
}

class RecommendPagePageService {
  RecommendPagePageService({
    ActivitiesApi? activitiesApi,
    AuthApi? authApi,
    ChildrenApi? childrenApi,
  }) : _activitiesApi = activitiesApi ?? ServiceSdk.instance.activities,
       _authApi = authApi ?? ServiceSdk.instance.auth,
       _childrenApi = childrenApi ?? ServiceSdk.instance.children;

  final ActivitiesApi _activitiesApi;
  final AuthApi _authApi;
  final ChildrenApi _childrenApi;

  Future<RecommendPageData> loadData() async {
    final user = await _authApi.getCurrentUser();
    final userName = (user?.name ?? '').toString().trim();

    final activitiesJson = await _activitiesApi.getActivities();
    final childrenJson = await _childrenApi.getChildren();

    final items = activitiesJson
        .map(_mapActivity)
        .whereType<RecommendActivityItem>()
        .toList();

    final filtersSet = <String>{};
    for (final item in items) {
      for (final goal in item.developmentGoals) {
        final cleaned = goal.trim();
        if (cleaned.isNotEmpty) {
          filtersSet.add(cleaned);
        }
      }
    }

    final objectiveFilters = filtersSet.toList()
      ..sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase()));

    final patients = childrenJson
        .map(_mapPatient)
        .whereType<RecommendPatientOption>()
        .toList()
      ..sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));

    return RecommendPageData(
      activities: items,
      objectiveFilters: objectiveFilters,
      patients: patients,
      userName: userName,
    );
  }

  RecommendPatientOption? _mapPatient(Map<String, dynamic> json) {
    final id = (json['_id'] ?? json['id'] ?? '').toString().trim();
    if (id.isEmpty) return null;

    final name = (json['name'] ?? 'Paciente').toString().trim();
    final ageRange = (json['ageRange'] ?? '').toString().trim();

    return RecommendPatientOption(
      id: id,
      name: name.isEmpty ? 'Paciente' : name,
      initials: _initials(name),
      ageRangeLabel: _formatAgeRange(ageRange),
    );
  }

  RecommendActivityItem? _mapActivity(Map<String, dynamic> json) {
    final id = (json['_id'] ?? json['id'] ?? '').toString().trim();
    if (id.isEmpty) return null;

    final title = (json['title'] ?? 'Atividade').toString().trim();
    final description = (json['description'] ?? '').toString().trim();

    final durationLabelRaw = (json['durationLabel'] ?? '').toString().trim();
    final ageLabelRaw = (json['ageLabel'] ?? '').toString().trim();
    final areaLabelRaw = (json['areaLabel'] ?? '').toString().trim();

    final durationMinutes = _asInt(json['durationMinutes']);
    final ageRange = (json['ageRange'] ?? '').toString().trim();

    final goals = _deriveGoals(
      developmentGoals: json['developmentGoals'],
      areaLabel: areaLabelRaw,
    );

    final hasInclusiveField = json.containsKey('isInclusive');
    final hasNeuroValidField = json.containsKey('isNeurodivergentValid');
    final hasNeuroField = json.containsKey('neurodivergenceValidated');
    final isInclusive = hasInclusiveField
        ? _asBool(json['isInclusive'])
        : hasNeuroValidField
            ? _asBool(json['isNeurodivergentValid'])
            : (hasNeuroField ? _asBool(json['neurodivergenceValidated']) : true);

    final isFree = _asBool(json['isFree']);
    final hasIsPremium = json.containsKey('isPremium');
    final isPremium = _asBool(json['isPremium']);
    final isLowCost = hasIsPremium ? (isFree || !isPremium) : isFree;

    final durationLabel = durationLabelRaw.isNotEmpty
        ? durationLabelRaw
        : durationMinutes > 0
            ? '${durationMinutes.toString()} min'
            : 'Duracao N/A';

    final isQuick = durationMinutes > 0
        ? durationMinutes < 20
        : _looksQuickDuration(durationLabel);

    final ageRangeLabel = ageLabelRaw.isNotEmpty
        ? ageLabelRaw
        : _formatAgeRange(ageRange);

    return RecommendActivityItem(
      id: id,
      title: title.isEmpty ? 'Atividade' : title,
      description: description.isEmpty ? 'Sem descricao.' : description,
      durationLabel: durationLabel,
      ageRangeLabel: ageRangeLabel,
      developmentGoals: goals,
      isInclusive: isInclusive,
      isLowCost: isLowCost,
      isQuick: isQuick,
    );
  }

  List<String> _deriveGoals({
    required dynamic developmentGoals,
    required String areaLabel,
  }) {
    final goals = _asStringList(developmentGoals);
    if (goals.isNotEmpty) return goals;

    if (areaLabel.trim().isNotEmpty) {
      return <String>[areaLabel.trim()];
    }

    return const <String>[];
  }

  bool _looksQuickDuration(String label) {
    final numbers = RegExp(r'\d+').allMatches(label).map((m) {
      return int.tryParse(m.group(0) ?? '') ?? 0;
    }).where((value) => value > 0).toList();

    if (numbers.isEmpty) return false;
    final shortest = numbers.reduce((a, b) => a < b ? a : b);
    return shortest < 20;
  }

  List<String> _asStringList(dynamic value) {
    if (value is List) {
      return value
          .map((item) => item.toString().trim())
          .where((item) => item.isNotEmpty)
          .toList();
    }
    return const <String>[];
  }

  bool _asBool(dynamic value) {
    if (value is bool) return value;
    if (value is num) return value != 0;

    final text = (value ?? '').toString().trim().toLowerCase();
    return text == 'true' || text == '1' || text == 'yes';
  }

  int _asInt(dynamic value) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.tryParse(value?.toString() ?? '') ?? 0;
  }

  String _formatAgeRange(String ageRange) {
    if (ageRange.isEmpty) return 'Idade N/A';
    if (ageRange.contains('-')) return '$ageRange anos';
    return '$ageRange anos';
  }

  String _initials(String name) {
    final parts = name
        .trim()
        .split(RegExp(r'\s+'))
        .where((item) => item.isNotEmpty)
        .toList();

    if (parts.isEmpty) return '??';
    if (parts.length == 1) return parts.first.substring(0, 1).toUpperCase();

    return '${parts.first.substring(0, 1)}${parts.last.substring(0, 1)}'
        .toUpperCase();
  }
}
