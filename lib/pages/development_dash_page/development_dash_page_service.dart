import 'package:app_twins/services/service.dart';

import 'development_dash_mocks.dart';

class DevelopmentChildOption {
  const DevelopmentChildOption({
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

enum DevelopmentDashPeriod { lastWeek, lastTwoWeeks, lastMonth }

class DevelopmentActivityHistoryItem {
  const DevelopmentActivityHistoryItem({
    required this.title,
    required this.finishedAt,
    required this.durationMinutes,
  });

  final String title;
  final DateTime finishedAt;
  final int durationMinutes;
}

class DevelopmentDashData {
  const DevelopmentDashData({
    required this.totalOfflineMinutes,
    required this.completedActivities,
    required int consistencyScore,
    required String consistencyLabel,
    required this.dailyAverageHours,
    required this.totalDeltaPercent,
    required this.completedDeltaPercent,
    required this.averageDeltaPercent,
    required this.offlineByWeek,
    required this.activitiesByWeek,
    required this.distributionByArea,
    required this.historyItems,
  }) : _consistencyScore = consistencyScore,
       _consistencyLabel = consistencyLabel;

  final int totalOfflineMinutes;
  final int completedActivities;
  final int? _consistencyScore;
  final String? _consistencyLabel;
  final num dailyAverageHours;

  final int totalDeltaPercent;
  final int completedDeltaPercent;
  final int averageDeltaPercent;

  final List<double> offlineByWeek;
  final List<int> activitiesByWeek;
  final Map<String, double> distributionByArea;
  final List<DevelopmentActivityHistoryItem> historyItems;

  int get consistencyScore => _consistencyScore ?? 0;
  String get consistencyLabel => _consistencyLabel ?? 'Baixo';
}

class DevelopmentDashPageService {
  DevelopmentDashPageService({
    ChildrenApi? childrenApi,
    CompletedActivitiesApi? completedActivitiesApi,
    bool useMocks = true,
  }) : _childrenApi = childrenApi ?? ServiceSdk.instance.children,
       _completedActivitiesApi =
           completedActivitiesApi ?? ServiceSdk.instance.completedActivities,
       _useMocks = useMocks;

  final ChildrenApi _childrenApi;
  final CompletedActivitiesApi _completedActivitiesApi;
  final bool _useMocks;

  List<DevelopmentDashMockScenario> availableMockScenarios() {
    return DevelopmentDashMockScenario.values;
  }

  Future<List<DevelopmentChildOption>> loadChildren() async {
    final children = _useMocks
        ? DevelopmentDashMocks.children()
        : await _childrenApi.getChildren();

    return children
        .map((item) {
          final name = (item['name'] ?? 'Crianca').toString();
          final ageRange = (item['ageRange'] ?? 'Sem idade').toString();

          return DevelopmentChildOption(
            id: (item['_id'] ?? item['id'] ?? '').toString(),
            name: name,
            ageLabel: _ageRangeLabel(ageRange),
            initial: name.isEmpty ? 'C' : name.substring(0, 1).toUpperCase(),
          );
        })
        .where((child) => child.id.isNotEmpty)
        .toList();
  }

  Future<DevelopmentDashData> loadDashboard({
    required String childId,
    required DevelopmentDashPeriod period,
    DevelopmentDashMockScenario scenario =
        DevelopmentDashMockScenario.manyActivities,
  }) async {
    final completedRecords = _useMocks
        ? DevelopmentDashMocks.completedRecords(
            childId: childId,
            scenario: scenario,
          )
        : await _completedActivitiesApi.getCompletedByChild(childId);

    if (completedRecords.isEmpty) return _emptyData(period);

    final now = DateTime.now();
    final periodDays = _daysByPeriod(period);
    final currentStart = now.subtract(Duration(days: periodDays));
    final previousStart = currentStart.subtract(Duration(days: periodDays));
    final previousEnd = currentStart.subtract(const Duration(milliseconds: 1));

    final currentRecords = completedRecords
        .where((item) => _isWithin(_completedAt(item), currentStart, now))
        .toList();
    final previousRecords = completedRecords
        .where(
          (item) => _isWithin(_completedAt(item), previousStart, previousEnd),
        )
        .toList();

    final currentTotalMinutes = currentRecords.fold<int>(
      0,
      (sum, item) => sum + _offlineMinutes(item),
    );
    final currentCompleted = currentRecords.length;
    final currentDailyAverage = periodDays == 0
        ? 0.0
        : (currentTotalMinutes / 60) / periodDays;

    final previousTotalMinutes = previousRecords.fold<int>(
      0,
      (sum, item) => sum + _offlineMinutes(item),
    );
    final previousCompleted = previousRecords.length;
    final previousDailyAverage = periodDays == 0
        ? 0.0
        : (previousTotalMinutes / 60) / periodDays;
    final consistencyScore = _calculateConsistencyScore(
      currentCompleted,
      previousCompleted,
    );

    final weeks = _weeksByPeriod(period);
    final offlineByWeek = List<double>.filled(weeks, 0);
    final activitiesByWeek = List<int>.filled(weeks, 0);
    final areaCounters = <String, int>{
      'Motor': 0,
      'Emocional': 0,
      'Social': 0,
      'Cognitivo': 0,
      'Criativo': 0,
    };

    for (final record in currentRecords) {
      final bucket = _weekBucketIndex(
        _completedAt(record),
        currentStart,
        weeks,
      );
      offlineByWeek[bucket] += _offlineMinutes(record);
      activitiesByWeek[bucket] += 1;

      for (final area in _areasFromCompletedRecord(record)) {
        if (areaCounters.containsKey(area)) {
          areaCounters[area] = (areaCounters[area] ?? 0) + 1;
        }
      }
    }

    final distributionByArea = _toPercentages(areaCounters);
    final historyItems = currentRecords
        .map(
          (record) => DevelopmentActivityHistoryItem(
            title: _activityTitle(record),
            finishedAt: _completedAt(record),
            durationMinutes: _offlineMinutes(record),
          ),
        )
        .toList()
      ..sort((a, b) => b.finishedAt.compareTo(a.finishedAt));

    return DevelopmentDashData(
      totalOfflineMinutes: currentTotalMinutes,
      completedActivities: currentCompleted,
      consistencyScore: consistencyScore,
      consistencyLabel: _consistencyLabel(consistencyScore),
      dailyAverageHours: currentDailyAverage,
      totalDeltaPercent: _calculateDelta(
        current: currentTotalMinutes.toDouble(),
        previous: previousTotalMinutes.toDouble(),
      ),
      completedDeltaPercent: _calculateDelta(
        current: currentCompleted.toDouble(),
        previous: previousCompleted.toDouble(),
      ),
      averageDeltaPercent: _calculateDelta(
        current: currentDailyAverage,
        previous: previousDailyAverage,
      ),
      offlineByWeek: offlineByWeek,
      activitiesByWeek: activitiesByWeek,
      distributionByArea: distributionByArea,
      historyItems: historyItems,
    );
  }

  DevelopmentDashData _emptyData(DevelopmentDashPeriod period) {
    final weeks = _weeksByPeriod(period);
    return DevelopmentDashData(
      totalOfflineMinutes: 0,
      completedActivities: 0,
      consistencyScore: 0,
      consistencyLabel: 'Baixo',
      dailyAverageHours: 0,
      totalDeltaPercent: 0,
      completedDeltaPercent: 0,
      averageDeltaPercent: 0,
      offlineByWeek: List<double>.filled(weeks, 0),
      activitiesByWeek: List<int>.filled(weeks, 0),
      distributionByArea: const {
        'Motor': 0,
        'Emocional': 0,
        'Social': 0,
        'Cognitivo': 0,
        'Criativo': 0,
      },
      historyItems: const <DevelopmentActivityHistoryItem>[],
    );
  }

  DateTime _completedAt(Map<String, dynamic> completedRecord) {
    return _parseDate(completedRecord['finishedAt']) ??
        _parseDate(completedRecord['createdAt']) ??
        DateTime.fromMillisecondsSinceEpoch(0);
  }

  DateTime? _parseDate(dynamic raw) {
    if (raw == null) return null;
    if (raw is DateTime) return raw;
    if (raw is String && raw.trim().isNotEmpty) {
      return DateTime.tryParse(raw.trim());
    }
    return null;
  }

  int _offlineMinutes(Map<String, dynamic> completedRecord) {
    final createdAt = _parseDate(completedRecord['createdAt']);
    final finishedAt = _parseDate(completedRecord['finishedAt']);
    if (createdAt == null || finishedAt == null) return 0;
    if (finishedAt.isBefore(createdAt)) return 0;

    final diffMinutes = finishedAt.difference(createdAt).inMinutes;
    return diffMinutes < 0 ? 0 : diffMinutes;
  }

  Set<String> _areasFromCompletedRecord(Map<String, dynamic> completedRecord) {
    final activity = completedRecord['activity'];
    if (activity is! Map) return const <String>{};

    final activityMap = Map<String, dynamic>.from(activity);
    final areas = <String>{};

    final goals = activityMap['developmentGoals'];
    if (goals is List) {
      for (final goal in goals) {
        final area = _areaFromText(goal.toString());
        if (area != null) {
          areas.add(area);
        }
      }
    }

    if (areas.isEmpty) {
      final objectives = activityMap['objectives'];
      if (objectives is List) {
        for (final objective in objectives) {
          final area = _areaFromText(objective.toString());
          if (area != null) {
            areas.add(area);
          }
        }
      }
    }

    return areas;
  }

  String _activityTitle(Map<String, dynamic> completedRecord) {
    final activity = completedRecord['activity'];
    if (activity is! Map) return 'Atividade';

    final title = activity['title'];
    if (title is String && title.trim().isNotEmpty) {
      return title.trim();
    }

    return 'Atividade';
  }

  String? _areaFromText(String text) {
    final normalized = text.toLowerCase();
    if (normalized.contains('motor')) return 'Motor';
    if (normalized.contains('emoc') || normalized.contains('autonom')) {
      return 'Emocional';
    }
    if (normalized.contains('social')) return 'Social';
    if (normalized.contains('logic') ||
        normalized.contains('logi') ||
        normalized.contains('cogn') ||
        normalized.contains('lingua') ||
        normalized.contains('concentr')) {
      return 'Cognitivo';
    }
    if (normalized.contains('cri') ||
        normalized.contains('arte') ||
        normalized.contains('musica') ||
        normalized.contains('danca')) {
      return 'Criativo';
    }

    return null;
  }

  bool _isWithin(DateTime date, DateTime start, DateTime end) {
    return !date.isBefore(start) && !date.isAfter(end);
  }

  int _weekBucketIndex(DateTime date, DateTime periodStart, int weeks) {
    if (weeks <= 1) return 0;

    final elapsedDays = date.difference(periodStart).inDays;
    final rawIndex = elapsedDays ~/ 7;
    if (rawIndex < 0) return 0;
    if (rawIndex >= weeks) return weeks - 1;
    return rawIndex;
  }

  int _calculateDelta({required double current, required double previous}) {
    return _comparisonScore(current: current, previous: previous);
  }

  int _calculateConsistencyScore(int currentCompleted, int previousCompleted) {
    return _comparisonScore(
      current: currentCompleted.toDouble(),
      previous: previousCompleted.toDouble(),
    );
  }

  int _comparisonScore({required double current, required double previous}) {
    if (current == 0 && previous == 0) return 50;

    final average = (current + previous) / 2;
    if (average == 0) {
      return current > 0 ? 100 : 50;
    }

    final normalized = ((current - previous) / average).clamp(-1.0, 1.0);
    final score = (normalized + 1) * 50;
    return score.round();
  }

  String _consistencyLabel(int score) {
    if (score >= 85) return 'Excelente';
    if (score >= 70) return 'Bom';
    if (score >= 50) return 'Regular';
    return 'Baixo';
  }

  int _weeksByPeriod(DevelopmentDashPeriod period) {
    switch (period) {
      case DevelopmentDashPeriod.lastWeek:
        return 1;
      case DevelopmentDashPeriod.lastTwoWeeks:
        return 2;
      case DevelopmentDashPeriod.lastMonth:
        return 4;
    }
  }

  int _daysByPeriod(DevelopmentDashPeriod period) {
    switch (period) {
      case DevelopmentDashPeriod.lastWeek:
        return 7;
      case DevelopmentDashPeriod.lastTwoWeeks:
        return 14;
      case DevelopmentDashPeriod.lastMonth:
        return 30;
    }
  }

  Map<String, double> _toPercentages(Map<String, int> counters) {
    final total = counters.values.fold<int>(0, (sum, value) => sum + value);
    if (total == 0) {
      return {
        'Motor': 0,
        'Emocional': 0,
        'Social': 0,
        'Cognitivo': 0,
        'Criativo': 0,
      };
    }

    return counters.map((key, value) {
      final percent = (value * 100) / total;
      return MapEntry(key, percent);
    });
  }

  String _ageRangeLabel(String ageRange) {
    final normalized = ageRange.trim();
    if (normalized == '0-3') return '0-3 anos';
    if (normalized == '4-6') return '4-6 anos';
    if (normalized == '7-9') return '7-9 anos';
    if (normalized == '10-12') return '10-12 anos';
    return '$normalized anos';
  }
}
