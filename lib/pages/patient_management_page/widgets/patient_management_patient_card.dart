import 'package:app_twins/pages/patient_management_page/patient_management_page_service.dart';
import 'package:flutter/material.dart';

class PatientManagementPatientCard extends StatelessWidget {
  const PatientManagementPatientCard({
    super.key,
    required this.patient,
  });

  final PatientManagementPatient patient;

  @override
  Widget build(BuildContext context) {
    final engagementStyle = _engagementStyle(patient.engagementLevel);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFFFF),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 30,
                backgroundColor: const Color(0xFF33A8E8),
                child: Text(
                  patient.initials,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            patient.name,
                            style: const TextStyle(
                              color: Color(0xFF101828),
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        Text(
                          '(${patient.ageLabel})',
                          style: const TextStyle(
                            color: Color(0xFF6A7282),
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: engagementStyle.background,
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                engagementStyle.icon,
                                size: 12,
                                color: engagementStyle.foreground,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                patient.engagementLabel,
                                style: TextStyle(
                                  color: engagementStyle.foreground,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 3),
                    Text(
                      patient.therapistLabel,
                      style: const TextStyle(
                        color: Color(0xFF4A5565),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _MetricBox(
                  title: 'Atividades',
                  value: '${patient.activitiesThisWeek} esta semana',
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _MetricBox(
                  title: 'Tempo Offline',
                  value: '${patient.offlineHoursThisWeek.toStringAsFixed(1)}h',
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _MetricBox(
                  title: 'Ultima Atividade',
                  value: patient.lastActivityLabel,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  _EngagementStyle _engagementStyle(PatientEngagementLevel level) {
    if (level == PatientEngagementLevel.high) {
      return const _EngagementStyle(
        background: Color(0xFFDCFCE7),
        foreground: Color(0xFF16A34A),
        icon: Icons.trending_up,
      );
    }

    if (level == PatientEngagementLevel.medium) {
      return const _EngagementStyle(
        background: Color(0xFFFFEDD5),
        foreground: Color(0xFFEA580C),
        icon: Icons.trending_flat,
      );
    }

    return const _EngagementStyle(
      background: Color(0xFFFEE2E2),
      foreground: Color(0xFFDC2626),
      icon: Icons.radio_button_checked,
    );
  }
}

class _MetricBox extends StatelessWidget {
  const _MetricBox({
    required this.title,
    required this.value,
  });

  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Color(0xFF4A5565),
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            value,
            style: const TextStyle(
              color: Color(0xFF101828),
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _EngagementStyle {
  const _EngagementStyle({
    required this.background,
    required this.foreground,
    required this.icon,
  });

  final Color background;
  final Color foreground;
  final IconData icon;
}
