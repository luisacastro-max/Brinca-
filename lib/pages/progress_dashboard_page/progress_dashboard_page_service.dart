import 'package:app_twins/services/service.dart';

enum ProgressDashboardAccent { purple, pink, blue, green, orange }

class ProgressDashboardChildOption {
  const ProgressDashboardChildOption({
    required this.id,
    required this.name,
    required this.ageLabel,
    required this.initial,
  });

  final String id;
  final String name;
  final String ageLabel;
  final String initial;
}

class ProgressDashboardPageData {
  const ProgressDashboardPageData({
    required this.children,
    required this.selectedChildId,
    required this.dashboard,
  });

  final List<ProgressDashboardChildOption> children;
  final String? selectedChildId;
  final ProgressDashboardViewData dashboard;
}

class ProgressDashboardAchievementData {
  const ProgressDashboardAchievementData({
    required this.label,
    required this.accent,
  });

  final String label;
  final ProgressDashboardAccent accent;
}

class ProgressDashboardAreaData {
  const ProgressDashboardAreaData({required this.label, required this.accent});

  final String label;
  final ProgressDashboardAccent accent;
}

class ProgressDashboardActivityData {
  const ProgressDashboardActivityData({
    required this.title,
    required this.durationLabel,
    required this.categoryLabel,
    required this.accent,
    required this.finishedAt,
  });

  final String title;
  final String durationLabel;
  final String categoryLabel;
  final ProgressDashboardAccent accent;
  final DateTime finishedAt;
}

class ProgressDashboardViewData {
  const ProgressDashboardViewData({
    required this.hasChild,
    required this.childName,
    required this.totalOfflineMinutesThisWeek,
    required this.completedActivitiesThisWeek,
    required this.consecutiveDaysThisWeek,
    required this.congratulationMessage,
    required this.supportMessage,
    required this.achievements,
    required this.areas,
    required this.activities,
  });

  final bool hasChild;
  final String childName;
  final int totalOfflineMinutesThisWeek;
  final int completedActivitiesThisWeek;
  final int consecutiveDaysThisWeek;
  final String congratulationMessage;
  final String supportMessage;
  final List<ProgressDashboardAchievementData> achievements;
  final List<ProgressDashboardAreaData> areas;
  final List<ProgressDashboardActivityData> activities;

  String get totalOfflineShortLabel =>
      _formatMinutes(totalOfflineMinutesThisWeek);

  String get totalOfflineLongLabel =>
      _formatMinutesLong(totalOfflineMinutesThisWeek);

  static String _formatMinutes(int minutes) {
    final safeMinutes = minutes < 0 ? 0 : minutes;
    final hours = safeMinutes ~/ 60;
    final remainingMinutes = safeMinutes % 60;

    if (hours > 0 && remainingMinutes > 0) {
      return '${hours}h ${remainingMinutes}min';
    }
    if (hours > 0) {
      return '${hours}h';
    }
    return '${remainingMinutes}min';
  }

  static String _formatMinutesLong(int minutes) {
    final safeMinutes = minutes < 0 ? 0 : minutes;
    final hours = safeMinutes ~/ 60;
    final remainingMinutes = safeMinutes % 60;

    if (hours > 0 && remainingMinutes > 0) {
      final hourLabel = hours == 1 ? 'hora' : 'horas';
      final minuteLabel = remainingMinutes == 1 ? 'minuto' : 'minutos';
      return '$hours $hourLabel e $remainingMinutes $minuteLabel';
    }
    if (hours > 0) {
      return '$hours ${hours == 1 ? 'hora' : 'horas'}';
    }
    return '$remainingMinutes ${remainingMinutes == 1 ? 'minuto' : 'minutos'}';
  }
}

class ProgressDashboardPageService {
  ProgressDashboardPageService({
    ChildrenApi? childrenApi,
    CompletedActivitiesApi? completedActivitiesApi,
  }) : _childrenApi = childrenApi ?? ServiceSdk.instance.children,
       _completedActivitiesApi =
           completedActivitiesApi ?? ServiceSdk.instance.completedActivities;

  final ChildrenApi _childrenApi;
  final CompletedActivitiesApi _completedActivitiesApi;

  Future<ProgressDashboardPageData> loadPageData({
    String? selectedChildId,
  }) async {
    final children = await _childrenApi.getChildren();
    final childOptions = children.map(_mapChild).toList();

    if (childOptions.isEmpty) {
      return const ProgressDashboardPageData(
        children: <ProgressDashboardChildOption>[],
        selectedChildId: null,
        dashboard: ProgressDashboardViewData(
          hasChild: false,
          childName: '',
          totalOfflineMinutesThisWeek: 0,
          completedActivitiesThisWeek: 0,
          consecutiveDaysThisWeek: 0,
          congratulationMessage:
              'Cadastre uma crianca para acompanhar o progresso semanal.',
          supportMessage:
              'Assim que houver uma crianca vinculada, este painel passa a mostrar o resumo real das atividades concluidas.',
          achievements: <ProgressDashboardAchievementData>[],
          areas: <ProgressDashboardAreaData>[],
          activities: <ProgressDashboardActivityData>[],
        ),
      );
    }

    final selectedChild = childOptions.firstWhere(
      (child) => child.id == selectedChildId,
      orElse: () => childOptions.first,
    );
    final selectedChildJson = children.firstWhere(
      (child) =>
          (child['_id'] ?? child['id'] ?? '').toString().trim() ==
          selectedChild.id,
      orElse: () => children.first,
    );
    final dashboardChild = _dashboardChildFromJson(selectedChildJson);

    final completedRecords = await _completedActivitiesApi.getCompletedByChild(
      selectedChild.id,
    );

    final currentWeekStart = _startOfCurrentWeek();
    final currentWeekRecords =
        completedRecords.where((record) {
          final finishedAt = _finishedAt(record);
          return finishedAt != null && !finishedAt.isBefore(currentWeekStart);
        }).toList()..sort(
          (left, right) =>
              (_finishedAt(right) ?? DateTime.fromMillisecondsSinceEpoch(0))
                  .compareTo(
                    _finishedAt(left) ?? DateTime.fromMillisecondsSinceEpoch(0),
                  ),
        );

    final completedActivitiesThisWeek = currentWeekRecords.length;
    final totalOfflineMinutesThisWeek = currentWeekRecords.fold<int>(
      0,
      (sum, record) => sum + _offlineMinutes(record),
    );

    final uniqueDays = currentWeekRecords
        .map((record) => _dateKey(_finishedAt(record)!))
        .toSet()
        .length;

    return ProgressDashboardPageData(
      children: childOptions,
      selectedChildId: selectedChild.id,
      dashboard: ProgressDashboardViewData(
        hasChild: true,
        childName: selectedChild.name,
        totalOfflineMinutesThisWeek: totalOfflineMinutesThisWeek,
        completedActivitiesThisWeek: completedActivitiesThisWeek,
        consecutiveDaysThisWeek: uniqueDays,
        congratulationMessage: _buildCongratulationMessage(
          childName: selectedChild.name,
          completedActivities: completedActivitiesThisWeek,
          totalOfflineMinutes: totalOfflineMinutesThisWeek,
        ),
        supportMessage: _buildSupportMessage(
          completedActivities: completedActivitiesThisWeek,
          totalOfflineMinutes: totalOfflineMinutesThisWeek,
        ),
        achievements: _buildAchievements(
          child: dashboardChild,
          completedActivities: completedActivitiesThisWeek,
          totalOfflineMinutes: totalOfflineMinutesThisWeek,
          activeDays: uniqueDays,
        ),
        areas: _buildAreas(
          currentWeekRecords: currentWeekRecords,
          child: dashboardChild,
        ),
        activities: _buildActivities(currentWeekRecords: currentWeekRecords),
      ),
    );
  }

  ProgressDashboardChildOption _mapChild(Map<String, dynamic> json) {
    final name = (json['name'] ?? 'Crianca').toString().trim();
    final safeName = name.isEmpty ? 'Crianca' : name;

    return ProgressDashboardChildOption(
      id: (json['_id'] ?? json['id'] ?? '').toString().trim(),
      name: safeName,
      ageLabel: _ageRangeLabel((json['ageRange'] ?? '').toString()),
      initial: safeName.substring(0, 1).toUpperCase(),
    );
  }

  _DashboardChild _dashboardChildFromJson(Map<String, dynamic> json) {
    final name = (json['name'] ?? 'Crianca').toString().trim();
    return _DashboardChild(
      id: (json['_id'] ?? json['id'] ?? '').toString().trim(),
      name: name.isEmpty ? 'Crianca' : name,
      dailyTime: _asInt(json['dailyTime']),
      developmentGoals: _stringList(json['developmentGoals']),
    );
  }

  List<ProgressDashboardAchievementData> _buildAchievements({
    required _DashboardChild child,
    required int completedActivities,
    required int totalOfflineMinutes,
    required int activeDays,
  }) {
    final achievements = <ProgressDashboardAchievementData>[];

    achievements.add(
      ProgressDashboardAchievementData(
        label: activeDays > 0
            ? '$activeDays dias sem telas'
            : 'Semana iniciando',
        accent: ProgressDashboardAccent.orange,
      ),
    );

    final targetMinutes = child.dailyTime <= 0 ? 0 : child.dailyTime * 3;
    final routineEstablished =
        completedActivities >= 3 ||
        (targetMinutes > 0 && totalOfflineMinutes >= targetMinutes);

    achievements.add(
      ProgressDashboardAchievementData(
        label: routineEstablished
            ? 'Rotina estabelecida'
            : 'Constancia em andamento',
        accent: ProgressDashboardAccent.green,
      ),
    );

    return achievements;
  }

  List<ProgressDashboardAreaData> _buildAreas({
    required List<Map<String, dynamic>> currentWeekRecords,
    required _DashboardChild child,
  }) {
    final counters = <String, int>{};

    for (final record in currentWeekRecords) {
      final label = _activityArea(record);
      if (label.isEmpty) continue;
      counters[label] = (counters[label] ?? 0) + 1;
    }

    if (counters.isEmpty) {
      return child.developmentGoals
          .map(
            (goal) => ProgressDashboardAreaData(
              label: goal,
              accent: _accentForLabel(goal),
            ),
          )
          .take(4)
          .toList();
    }

    final entries = counters.entries.toList()
      ..sort((left, right) => right.value.compareTo(left.value));

    return entries
        .take(4)
        .map(
          (entry) => ProgressDashboardAreaData(
            label: entry.key,
            accent: _accentForLabel(entry.key),
          ),
        )
        .toList();
  }

  List<ProgressDashboardActivityData> _buildActivities({
    required List<Map<String, dynamic>> currentWeekRecords,
  }) {
    return currentWeekRecords
        .map((record) {
          final finishedAt = _finishedAt(record);
          if (finishedAt == null) return null;

          final activity = _activityJson(record);
          final title = (activity['title'] ?? 'Atividade offline')
              .toString()
              .trim();
          final area = _activityArea(record);
          final parsedMinutes = _offlineMinutes(record);

          return ProgressDashboardActivityData(
            title: title.isEmpty ? 'Atividade offline' : title,
            durationLabel: ProgressDashboardViewData._formatMinutes(
              parsedMinutes,
            ),
            categoryLabel: area.isEmpty ? 'Atividade offline' : area,
            accent: _accentForLabel(area),
            finishedAt: finishedAt,
          );
        })
        .whereType<ProgressDashboardActivityData>()
        .take(9)
        .toList();
  }

  String _buildCongratulationMessage({
    required String childName,
    required int completedActivities,
    required int totalOfflineMinutes,
  }) {
    if (completedActivities == 0) {
      return '$childName ainda nao concluiu atividades nesta semana.';
    }

    final activitiesLabel = completedActivities == 1
        ? 'atividade'
        : 'atividades';
    return '$childName completou $completedActivities $activitiesLabel esta semana e passou ${ProgressDashboardViewData._formatMinutesLong(totalOfflineMinutes)} longe das telas.';
  }

  String _buildSupportMessage({
    required int completedActivities,
    required int totalOfflineMinutes,
  }) {
    if (completedActivities == 0 || totalOfflineMinutes == 0) {
      return 'Assim que novas brincadeiras forem concluidas, este painel atualiza o resumo semanal automaticamente.';
    }

    return 'Voce esta criando momentos especiais e contribuindo para o desenvolvimento saudavel do seu filho. Continue assim!';
  }

  DateTime _startOfCurrentWeek() {
    final now = DateTime.now();
    final weekday = now.weekday;
    return DateTime(
      now.year,
      now.month,
      now.day,
    ).subtract(Duration(days: weekday - 1));
  }

  DateTime? _finishedAt(Map<String, dynamic> record) {
    final rawValue = record['finishedAt'] ?? record['createdAt'];
    if (rawValue == null) return null;
    return DateTime.tryParse(rawValue.toString())?.toLocal();
  }

  String _dateKey(DateTime date) =>
      '${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';

  Map<String, dynamic> _activityJson(Map<String, dynamic> record) {
    final activity = record['activity'];
    if (activity is Map<String, dynamic>) return activity;
    if (activity is Map) {
      return activity.map((key, value) => MapEntry(key.toString(), value));
    }
    return const <String, dynamic>{};
  }

  String _activityArea(Map<String, dynamic> record) {
    final activity = _activityJson(record);
    final rawLabel = (activity['areaLabel'] ?? '').toString().trim();
    if (rawLabel.isEmpty) return 'Atividade offline';
    return rawLabel;
  }

  int _offlineMinutes(Map<String, dynamic> record) {
    final createdAt = _parseDate(record['createdAt']);
    final finishedAt = _parseDate(record['finishedAt']);
    if (createdAt == null || finishedAt == null) return 0;
    if (finishedAt.isBefore(createdAt)) return 0;

    final diffMinutes = finishedAt.difference(createdAt).inMinutes;
    return diffMinutes < 0 ? 0 : diffMinutes;
  }

  DateTime? _parseDate(dynamic raw) {
    if (raw == null) return null;
    if (raw is DateTime) return raw;
    if (raw is String && raw.trim().isNotEmpty) {
      return DateTime.tryParse(raw.trim())?.toLocal();
    }
    return null;
  }

  int _asInt(Object? value) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.tryParse(value?.toString() ?? '') ?? 0;
  }

  String _ageRangeLabel(String ageRange) {
    final normalized = ageRange.trim();
    if (normalized == '0-3') return '0-3 anos';
    if (normalized == '4-6') return '4-6 anos';
    if (normalized == '7-9') return '7-9 anos';
    if (normalized == '10-12') return '10-12 anos';
    if (normalized.isEmpty) return 'Sem idade';
    return '$normalized anos';
  }

  List<String> _stringList(Object? value) {
    if (value is! List) return const <String>[];
    return value
        .map((item) => item.toString().trim())
        .where((item) => item.isNotEmpty)
        .toList();
  }

  ProgressDashboardAccent _accentForLabel(String label) {
    final normalized = label.toLowerCase();
    if (normalized.contains('motor') ||
        normalized.contains('coordena') ||
        normalized.contains('constr')) {
      return ProgressDashboardAccent.purple;
    }
    if (normalized.contains('criativ') ||
        normalized.contains('arte') ||
        normalized.contains('faz de conta')) {
      return ProgressDashboardAccent.pink;
    }
    if (normalized.contains('emoc') || normalized.contains('lingu')) {
      return ProgressDashboardAccent.blue;
    }
    if (normalized.contains('social') || normalized.contains('autonom')) {
      return ProgressDashboardAccent.green;
    }
    return ProgressDashboardAccent.orange;
  }
}

class _DashboardChild {
  const _DashboardChild({
    required this.id,
    required this.name,
    required this.dailyTime,
    required this.developmentGoals,
  });

  final String id;
  final String name;
  final int dailyTime;
  final List<String> developmentGoals;
}
