import 'package:app_twins/services/service.dart';

class ClinicRecentActivityItem {
  const ClinicRecentActivityItem({
    required this.childName,
    required this.childAgeLabel,
    required this.activityTitle,
    required this.completedLabel,
    this.statusLabel = 'Concluida',
  });

  final String childName;
  final String childAgeLabel;
  final String activityTitle;
  final String completedLabel;
  final String statusLabel;
}

class ClinicAttentionItem {
  const ClinicAttentionItem({
    required this.childName,
    required this.ageLabel,
    required this.message,
    required this.priority,
  });

  final String childName;
  final String ageLabel;
  final String message;
  final ClinicAttentionPriority priority;
}

enum ClinicAttentionPriority { high, medium }

class ClinicMetricData {
  const ClinicMetricData({
    required activePatients,
    required completedThisWeek,
    required averageOfflineHours,
    required engagementRate,
    required activePatientsDelta,
    required completedPerChildDelta,
    required averageOfflineHoursDelta,
    required engagementRateDelta,
  }) : _activePatients = activePatients,
       _completedThisWeek = completedThisWeek,
       _averageOfflineHours = averageOfflineHours,
       _engagementRate = engagementRate,
       _activePatientsDelta = activePatientsDelta,
       _completedPerChildDelta = completedPerChildDelta,
       _averageOfflineHoursDelta = averageOfflineHoursDelta,
       _engagementRateDelta = engagementRateDelta;

  final int? _activePatients;
  final int? _completedThisWeek;
  final double? _averageOfflineHours;
  final int? _engagementRate;
  final int? _activePatientsDelta;
  final int? _completedPerChildDelta;
  final int? _averageOfflineHoursDelta;
  final int? _engagementRateDelta;

  int get activePatients => _activePatients ?? 0;
  int get completedThisWeek => _completedThisWeek ?? 0;
  double get averageOfflineHours => _averageOfflineHours ?? 0.0;
  int get engagementRate => _engagementRate ?? 0;
  int get activePatientsDelta => _activePatientsDelta ?? 0;
  int get completedPerChildDelta => _completedPerChildDelta ?? 0;
  int get averageOfflineHoursDelta => _averageOfflineHoursDelta ?? 0;
  int get engagementRateDelta => _engagementRateDelta ?? 0;
}

class ClinicHomePageData {
  const ClinicHomePageData({
    required this.metric,
    required this.recentActivities,
    required this.attentionItems,
  });

  final ClinicMetricData metric;
  final List<ClinicRecentActivityItem> recentActivities;
  final List<ClinicAttentionItem> attentionItems;
}

class ClinicHomePageService {
  ClinicHomePageService({
    ChildrenApi? childrenApi,
    CompletedActivitiesApi? completedActivitiesApi,
  }) : _childrenApi = childrenApi ?? ServiceSdk.instance.children,
       _completedActivitiesApi =
           completedActivitiesApi ?? ServiceSdk.instance.completedActivities;

  final ChildrenApi _childrenApi;
  final CompletedActivitiesApi _completedActivitiesApi;

  Future<ClinicHomePageData> loadData() async {
    final children = await _childrenApi.getChildren();

    final normalizedChildren = children
        .map((child) => _ChildInfo.fromJson(child))
        .where((child) => child.id.isNotEmpty)
        .toList();

    final completedByChild = <String, List<Map<String, dynamic>>>{};

    for (final child in normalizedChildren) {
      try {
        final completed = await _completedActivitiesApi.getCompletedByChild(
          child.id,
        );
        completedByChild[child.id] = completed;
      } on ServiceException {
        completedByChild[child.id] = const <Map<String, dynamic>>[];
      }
    }

    final now = DateTime.now();
    final startOfCurrentWeek = DateTime(
      now.year,
      now.month,
      now.day,
    ).subtract(Duration(days: now.weekday - 1));
    final startOfPreviousWeek = startOfCurrentWeek.subtract(
      const Duration(days: 7),
    );
    final endOfPreviousWeek = startOfCurrentWeek;

    var completedThisWeek = 0;
    var completedPreviousWeek = 0;

    final activeThisWeek = <String>{};
    final activePreviousWeek = <String>{};

    var totalDurationMinutesThisWeek = 0;
    var totalDurationMinutesPreviousWeek = 0;
    var completedWithDurationThisWeek = 0;
    var completedWithDurationPreviousWeek = 0;

    final allCompletedItems = <_CompletedInfo>[];

    for (final child in normalizedChildren) {
      final childCompleted = completedByChild[child.id] ?? const [];
      for (final item in childCompleted) {
        final completedInfo = _CompletedInfo.fromJson(item, child: child);
        allCompletedItems.add(completedInfo);

        final finishedAt = completedInfo.finishedAt;
        if (finishedAt == null) continue;

        if (!finishedAt.isBefore(startOfCurrentWeek)) {
          completedThisWeek += 1;
          activeThisWeek.add(child.id);

          if (completedInfo.durationMinutes != null) {
            totalDurationMinutesThisWeek += completedInfo.durationMinutes!;
            completedWithDurationThisWeek += 1;
          }
        } else if (!finishedAt.isBefore(startOfPreviousWeek) &&
            finishedAt.isBefore(endOfPreviousWeek)) {
          completedPreviousWeek += 1;
          activePreviousWeek.add(child.id);

          if (completedInfo.durationMinutes != null) {
            totalDurationMinutesPreviousWeek += completedInfo.durationMinutes!;
            completedWithDurationPreviousWeek += 1;
          }
        }
      }
    }

    final averageOfflineHours = completedWithDurationThisWeek == 0
        ? 0.0
        : (totalDurationMinutesThisWeek / completedWithDurationThisWeek) / 60.0;
    final averageOfflineHoursPreviousWeek = completedWithDurationPreviousWeek == 0
        ? 0.0
        : (totalDurationMinutesPreviousWeek / completedWithDurationPreviousWeek) /
              60.0;

    final totalChildren = normalizedChildren.length;
    final completedPerChildThisWeek = totalChildren == 0
        ? 0.0
        : completedThisWeek / totalChildren;
    final completedPerChildPreviousWeek = totalChildren == 0
        ? 0.0
        : completedPreviousWeek / totalChildren;

    final activePatients = activeThisWeek.length;
    final activePatientsPreviousWeek = activePreviousWeek.length;

    final engagementRate = totalChildren == 0
        ? 0
        : ((activePatients / totalChildren) * 100).round();
    final engagementRatePreviousWeek = totalChildren == 0
        ? 0
        : ((activePatientsPreviousWeek / totalChildren) * 100).round();

    final activePatientsDelta = _calculateDeltaPercent(
      current: activePatients.toDouble(),
      previous: activePatientsPreviousWeek.toDouble(),
    );
    final completedPerChildDelta = _calculateDeltaPercent(
      current: completedPerChildThisWeek,
      previous: completedPerChildPreviousWeek,
    );
    final averageOfflineHoursDelta = _calculateDeltaPercent(
      current: averageOfflineHours,
      previous: averageOfflineHoursPreviousWeek,
    );
    final engagementRateDelta = _calculateDeltaPercent(
      current: engagementRate.toDouble(),
      previous: engagementRatePreviousWeek.toDouble(),
    );

    allCompletedItems.sort((a, b) {
      final ad = a.finishedAt ?? DateTime.fromMillisecondsSinceEpoch(0);
      final bd = b.finishedAt ?? DateTime.fromMillisecondsSinceEpoch(0);
      return bd.compareTo(ad);
    });

    final recentActivities = allCompletedItems.take(4).map((item) {
      return ClinicRecentActivityItem(
        childName: item.child.name,
        childAgeLabel: item.child.ageLabel,
        activityTitle: item.activityTitle,
        completedLabel: _toRelativeLabel(item.finishedAt),
      );
    }).toList();

    final attentionItems = _buildAttentionItems(
      children: normalizedChildren,
      completedByChild: completedByChild,
      now: now,
    );

    return ClinicHomePageData(
      metric: ClinicMetricData(
        activePatients: activePatients,
        completedThisWeek: completedThisWeek,
        averageOfflineHours: averageOfflineHours,
        engagementRate: engagementRate,
        activePatientsDelta: activePatientsDelta,
        completedPerChildDelta: completedPerChildDelta,
        averageOfflineHoursDelta: averageOfflineHoursDelta,
        engagementRateDelta: engagementRateDelta,
      ),
      recentActivities: recentActivities,
      attentionItems: attentionItems,
    );
  }

  int _calculateDeltaPercent({
    required double current,
    required double previous,
  }) {
    if (current == 0 && previous == 0) return 0;
    if (previous == 0) return current > 0 ? 100 : 0;

    final delta = ((current - previous) / previous) * 100;
    return delta.round();
  }

  List<ClinicAttentionItem> _buildAttentionItems({
    required List<_ChildInfo> children,
    required Map<String, List<Map<String, dynamic>>> completedByChild,
    required DateTime now,
  }) {
    final candidate = <ClinicAttentionItem>[];

    for (final child in children) {
      final completed = completedByChild[child.id] ?? const [];
      if (completed.isEmpty) {
        candidate.add(
          ClinicAttentionItem(
            childName: child.name,
            ageLabel: child.ageLabel,
            message: 'Sem atividades recentes',
            priority: ClinicAttentionPriority.high,
          ),
        );
        continue;
      }

      DateTime? lastDate;
      for (final item in completed) {
        final parsed = _parseDate(item['finishedAt'] ?? item['createdAt']);
        if (parsed == null) continue;
        if (lastDate == null || parsed.isAfter(lastDate)) {
          lastDate = parsed;
        }
      }

      if (lastDate == null) {
        candidate.add(
          ClinicAttentionItem(
            childName: child.name,
            ageLabel: child.ageLabel,
            message: 'Sem atividades recentes',
            priority: ClinicAttentionPriority.high,
          ),
        );
        continue;
      }

      final days = now.difference(lastDate).inDays;
      if (days >= 5) {
        candidate.add(
          ClinicAttentionItem(
            childName: child.name,
            ageLabel: child.ageLabel,
            message: 'Sem atividades ha $days dias',
            priority: ClinicAttentionPriority.high,
          ),
        );
      } else if (days >= 3) {
        candidate.add(
          ClinicAttentionItem(
            childName: child.name,
            ageLabel: child.ageLabel,
            message: 'Engajamento abaixo da media',
            priority: ClinicAttentionPriority.medium,
          ),
        );
      }
    }

    candidate.sort((a, b) {
      if (a.priority != b.priority) {
        return a.priority == ClinicAttentionPriority.high ? -1 : 1;
      }
      return a.childName.toLowerCase().compareTo(b.childName.toLowerCase());
    });

    return candidate.take(3).toList();
  }

  static DateTime? _parseDate(dynamic value) {
    if (value == null) return null;
    return DateTime.tryParse(value.toString());
  }

  String _toRelativeLabel(DateTime? date) {
    if (date == null) return 'Sem data';

    final now = DateTime.now();
    final diff = now.difference(date);

    if (diff.inMinutes < 1) return 'Agora';
    if (diff.inHours < 1) return '${diff.inMinutes} min atras';
    if (diff.inDays < 1) return '${diff.inHours}h atras';
    return '${diff.inDays}d atras';
  }
}

class _ChildInfo {
  const _ChildInfo({
    required this.id,
    required this.name,
    required this.ageLabel,
    required this.dailyTimeMinutes,
  });

  final String id;
  final String name;
  final String ageLabel;
  final int dailyTimeMinutes;

  factory _ChildInfo.fromJson(Map<String, dynamic> json) {
    final ageRange = (json['ageRange'] ?? '').toString().trim();
    final ageLabel = _ageLabelFromRange(ageRange);

    return _ChildInfo(
      id: (json['_id'] ?? json['id'] ?? '').toString(),
      name: (json['name'] ?? 'Crianca').toString(),
      ageLabel: ageLabel,
      dailyTimeMinutes: _asInt(json['dailyTime']),
    );
  }

  static int _asInt(dynamic value) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.tryParse(value?.toString() ?? '') ?? 0;
  }

  static String _ageLabelFromRange(String ageRange) {
    if (ageRange.contains('-')) {
      final parts = ageRange.split('-');
      if (parts.length == 2) {
        final max = parts[1].trim();
        return '$max anos';
      }
    }

    if (ageRange.isNotEmpty) {
      return '$ageRange anos';
    }

    return 'Idade N/A';
  }
}

class _CompletedInfo {
  const _CompletedInfo({
    required this.child,
    required this.activityTitle,
    required this.finishedAt,
    required this.durationMinutes,
  });

  final _ChildInfo child;
  final String activityTitle;
  final DateTime? finishedAt;
  final int? durationMinutes;

  factory _CompletedInfo.fromJson(
    Map<String, dynamic> json, {
    required _ChildInfo child,
  }) {
    String title = 'Atividade';

    final activity = json['activity'];
    if (activity is Map<String, dynamic>) {
      title = (activity['title'] ?? title).toString();
    }

    final finishedAt = ClinicHomePageService._parseDate(
      json['finishedAt'] ?? json['createdAt'],
    );
    final startedAt = ClinicHomePageService._parseDate(json['createdAt']);
    final completedFlag = _isCompleted(json);

    int? durationMinutes;
    if (completedFlag && startedAt != null && finishedAt != null) {
      final diff = finishedAt.difference(startedAt).inMinutes;
      if (diff >= 0) {
        durationMinutes = diff;
      }
    }

    return _CompletedInfo(
      child: child,
      activityTitle: title,
      finishedAt: finishedAt,
      durationMinutes: durationMinutes,
    );
  }

  static bool _isCompleted(Map<String, dynamic> json) {
    final completed = json['is_completed'] ?? json['isCompleted'];
    if (completed is bool) return completed;
    if (completed is String) {
      final normalized = completed.trim().toLowerCase();
      return normalized == 'true' || normalized == '1';
    }
    if (completed is num) return completed != 0;

    final finishedAt = json['finishedAt'];
    return finishedAt != null;
  }
}
