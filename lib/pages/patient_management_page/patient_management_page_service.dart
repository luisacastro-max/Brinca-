import 'package:app_twins/services/service.dart';

enum PatientEngagementLevel { high, medium, low }

class PatientManagementPatient {
  const PatientManagementPatient({
    required this.id,
    required this.initials,
    required this.name,
    required this.ageLabel,
    required this.ageRangeCode,
    required this.engagementLabel,
    required this.engagementLevel,
    required this.activitiesThisWeek,
    required this.offlineHoursThisWeek,
    required this.lastActivityLabel,
    required this.therapistLabel,
  });

  final String id;
  final String initials;
  final String name;
  final String ageLabel;
  final String ageRangeCode;
  final String engagementLabel;
  final PatientEngagementLevel engagementLevel;
  final int activitiesThisWeek;
  final double offlineHoursThisWeek;
  final String lastActivityLabel;
  final String therapistLabel;
}

class PatientManagementPageData {
  const PatientManagementPageData({
    required this.patients,
    required this.clinicName,
  });

  final List<PatientManagementPatient> patients;
  final String clinicName;
}

class PatientManagementPageService {
  PatientManagementPageService({
    ChildrenApi? childrenApi,
    CompletedActivitiesApi? completedActivitiesApi,
    AuthApi? authApi,
  }) : _childrenApi = childrenApi ?? ServiceSdk.instance.children,
       _completedActivitiesApi =
           completedActivitiesApi ?? ServiceSdk.instance.completedActivities,
       _authApi = authApi ?? ServiceSdk.instance.auth;

  final ChildrenApi _childrenApi;
  final CompletedActivitiesApi _completedActivitiesApi;
  final AuthApi _authApi;

  Future<PatientManagementPageData> loadData() async {
    final currentUser = await _authApi.getCurrentUser();
    final clinicName = _safeClinicName(currentUser?.name);

    final children = await _childrenApi.getChildren();
    final now = DateTime.now();
    final startOfCurrentWeek = DateTime(
      now.year,
      now.month,
      now.day,
    ).subtract(Duration(days: now.weekday - 1));

    final patients = <PatientManagementPatient>[];

    for (final child in children) {
      final id = (child['_id'] ?? child['id'] ?? '').toString().trim();
      if (id.isEmpty) continue;

      final name = (child['name'] ?? 'Paciente').toString().trim();
      final ageRangeCode = (child['ageRange'] ?? '').toString().trim();
      final ageLabel = _ageLabelFromRange(ageRangeCode);

      List<Map<String, dynamic>> completed = const [];
      try {
        completed = await _completedActivitiesApi.getCompletedByChild(id);
      } on ServiceException {
        completed = const [];
      }

      var activitiesThisWeek = 0;
      var totalMinutesThisWeek = 0;
      DateTime? lastCompletedAt;

      for (final item in completed) {
        final finishedAt = _parseDate(item['finishedAt'] ?? item['createdAt']);
        if (finishedAt == null) continue;

        if (lastCompletedAt == null || finishedAt.isAfter(lastCompletedAt)) {
          lastCompletedAt = finishedAt;
        }

        if (finishedAt.isBefore(startOfCurrentWeek)) {
          continue;
        }

        final isCompleted = _isCompleted(item);
        if (!isCompleted) continue;

        activitiesThisWeek += 1;

        final startedAt = _parseDate(item['createdAt']);
        if (startedAt != null && !finishedAt.isBefore(startedAt)) {
          totalMinutesThisWeek += finishedAt.difference(startedAt).inMinutes;
        }
      }

      final offlineHoursThisWeek = totalMinutesThisWeek / 60.0;
      final engagement = _engagementFor(activitiesThisWeek);

      patients.add(
        PatientManagementPatient(
          id: id,
          initials: _initials(name),
          name: name,
          ageLabel: ageLabel,
          ageRangeCode: ageRangeCode,
          engagementLabel: _engagementLabel(engagement),
          engagementLevel: engagement,
          activitiesThisWeek: activitiesThisWeek,
          offlineHoursThisWeek: offlineHoursThisWeek,
          lastActivityLabel: _relativeTime(lastCompletedAt, now),
          therapistLabel: 'Terapeuta: $clinicName',
        ),
      );
    }

    patients.sort((a, b) {
      if (a.activitiesThisWeek != b.activitiesThisWeek) {
        return b.activitiesThisWeek.compareTo(a.activitiesThisWeek);
      }
      return a.name.toLowerCase().compareTo(b.name.toLowerCase());
    });

    return PatientManagementPageData(
      patients: patients,
      clinicName: clinicName,
    );
  }

  String _safeClinicName(String? name) {
    final value = (name ?? '').trim();
    if (value.isEmpty) return 'Profissional Responsavel';
    return value;
  }

  DateTime? _parseDate(dynamic raw) {
    if (raw == null) return null;
    return DateTime.tryParse(raw.toString());
  }

  bool _isCompleted(Map<String, dynamic> json) {
    final completed = json['is_completed'] ?? json['isCompleted'];
    if (completed is bool) return completed;
    if (completed is num) return completed != 0;
    if (completed is String) {
      final value = completed.trim().toLowerCase();
      return value == 'true' || value == '1';
    }

    return json['finishedAt'] != null;
  }

  PatientEngagementLevel _engagementFor(int activitiesThisWeek) {
    if (activitiesThisWeek >= 4) return PatientEngagementLevel.high;
    if (activitiesThisWeek >= 2) return PatientEngagementLevel.medium;
    return PatientEngagementLevel.low;
  }

  String _engagementLabel(PatientEngagementLevel level) {
    if (level == PatientEngagementLevel.high) return 'Alto';
    if (level == PatientEngagementLevel.medium) return 'Medio';
    return 'Baixo';
  }

  String _ageLabelFromRange(String ageRangeCode) {
    if (ageRangeCode.contains('-')) {
      final parts = ageRangeCode.split('-');
      if (parts.length == 2) {
        return '${parts[1].trim()} anos';
      }
    }

    if (ageRangeCode.isNotEmpty) return '$ageRangeCode anos';
    return 'N/A';
  }

  String _relativeTime(DateTime? date, DateTime now) {
    if (date == null) return 'Sem atividade';

    final diff = now.difference(date);
    if (diff.inMinutes < 1) return 'Agora';
    if (diff.inHours < 1) return '${diff.inMinutes}m atras';
    if (diff.inDays < 1) return '${diff.inHours}h atras';
    return '${diff.inDays}d atras';
  }

  String _initials(String name) {
    final parts = name
        .trim()
        .split(RegExp(r'\s+'))
        .where((item) => item.isNotEmpty)
        .toList();

    if (parts.isEmpty) return '??';
    if (parts.length == 1) {
      return parts.first.substring(0, 1).toUpperCase();
    }

    return '${parts.first.substring(0, 1)}${parts.last.substring(0, 1)}'
        .toUpperCase();
  }
}
