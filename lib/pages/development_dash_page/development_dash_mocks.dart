enum DevelopmentDashMockScenario {
  manyActivities,
  distributedWeeks,
  singleWeekOnly,
  mixedCategories,
  lowConsistency,
}

extension DevelopmentDashMockScenarioLabel on DevelopmentDashMockScenario {
  String get label {
    switch (this) {
      case DevelopmentDashMockScenario.manyActivities:
        return 'Muitas atividades';
      case DevelopmentDashMockScenario.distributedWeeks:
        return 'Semanas diferentes';
      case DevelopmentDashMockScenario.singleWeekOnly:
        return 'Apenas uma semana';
      case DevelopmentDashMockScenario.mixedCategories:
        return 'Categorias diferentes';
      case DevelopmentDashMockScenario.lowConsistency:
        return 'Baixa consistencia';
    }
  }
}

class DevelopmentDashMocks {
  static const String childAId = 'mock-child-a';
  static const String childBId = 'mock-child-b';

  static List<Map<String, dynamic>> children() {
    return const <Map<String, dynamic>>[
      {
        '_id': childAId,
        'name': 'Maria',
        'ageRange': '7-9',
      },
      {
        '_id': childBId,
        'name': 'Lucas',
        'ageRange': '4-6',
      },
    ];
  }

  static List<Map<String, dynamic>> completedRecords({
    required String childId,
    required DevelopmentDashMockScenario scenario,
  }) {
    final now = DateTime.now();

    switch (scenario) {
      case DevelopmentDashMockScenario.manyActivities:
        return _manyActivities(now, childId);
      case DevelopmentDashMockScenario.distributedWeeks:
        return _distributedWeeks(now, childId);
      case DevelopmentDashMockScenario.singleWeekOnly:
        return _singleWeekOnly(now, childId);
      case DevelopmentDashMockScenario.mixedCategories:
        return _mixedCategories(now, childId);
      case DevelopmentDashMockScenario.lowConsistency:
        return _lowConsistency(now, childId);
    }
  }

  static List<Map<String, dynamic>> _manyActivities(
    DateTime now,
    String childId,
  ) {
    return <Map<String, dynamic>>[
      _record(
        id: 'ca-1',
        childId: childId,
        now: now,
        daysAgo: 1,
        durationMinutes: 40,
        title: 'Jogo de equilibrio',
        goals: const ['Coordenacao motora'],
        objectives: const ['Motor'],
      ),
      _record(
        id: 'ca-2',
        childId: childId,
        now: now,
        daysAgo: 2,
        durationMinutes: 35,
        title: 'Teatro de sombras',
        goals: const ['Criatividade'],
        objectives: const ['Criativo'],
      ),
      _record(
        id: 'ca-3',
        childId: childId,
        now: now,
        daysAgo: 4,
        durationMinutes: 30,
        title: 'Leitura em dupla',
        goals: const ['Linguagem'],
        objectives: const ['Cognitivo'],
      ),
      _record(
        id: 'ca-4',
        childId: childId,
        now: now,
        daysAgo: 6,
        durationMinutes: 25,
        title: 'Circuito com almofadas',
        goals: const ['Coordenacao motora'],
        objectives: const ['Motor'],
      ),
      _record(
        id: 'ca-5',
        childId: childId,
        now: now,
        daysAgo: 8,
        durationMinutes: 45,
        title: 'Roda de historias',
        goals: const ['Socializacao'],
        objectives: const ['Social'],
      ),
      _record(
        id: 'ca-6',
        childId: childId,
        now: now,
        daysAgo: 10,
        durationMinutes: 32,
        title: 'Caca ao tesouro',
        goals: const ['Concentracao'],
        objectives: const ['Cognitivo'],
      ),
      _record(
        id: 'ca-7',
        childId: childId,
        now: now,
        daysAgo: 15,
        durationMinutes: 30,
        title: 'Danca guiada',
        goals: const ['Danca'],
        objectives: const ['Criativo'],
      ),
      _record(
        id: 'ca-8',
        childId: childId,
        now: now,
        daysAgo: 18,
        durationMinutes: 20,
        title: 'Respiracao divertida',
        goals: const ['Autonomia'],
        objectives: const ['Emocional'],
      ),
      _record(
        id: 'ca-9',
        childId: childId,
        now: now,
        daysAgo: 22,
        durationMinutes: 50,
        title: 'Montagem com blocos',
        goals: const ['Pensamento logico'],
        objectives: const ['Cognitivo'],
      ),
      _record(
        id: 'ca-10',
        childId: childId,
        now: now,
        daysAgo: 27,
        durationMinutes: 28,
        title: 'Jogo cooperativo',
        goals: const ['Socializacao'],
        objectives: const ['Social'],
      ),
    ];
  }

  static List<Map<String, dynamic>> _distributedWeeks(
    DateTime now,
    String childId,
  ) {
    return <Map<String, dynamic>>[
      _record(
        id: 'dw-1',
        childId: childId,
        now: now,
        daysAgo: 2,
        durationMinutes: 25,
        title: 'Massinha criativa',
        goals: const ['Criatividade'],
        objectives: const ['Criativo'],
      ),
      _record(
        id: 'dw-2',
        childId: childId,
        now: now,
        daysAgo: 8,
        durationMinutes: 30,
        title: 'Corrida de saco',
        goals: const ['Coordenacao motora'],
        objectives: const ['Motor'],
      ),
      _record(
        id: 'dw-3',
        childId: childId,
        now: now,
        daysAgo: 15,
        durationMinutes: 35,
        title: 'Mimica em familia',
        goals: const ['Socializacao'],
        objectives: const ['Social'],
      ),
      _record(
        id: 'dw-4',
        childId: childId,
        now: now,
        daysAgo: 23,
        durationMinutes: 26,
        title: 'Desenho de sentimentos',
        goals: const ['Autonomia'],
        objectives: const ['Emocional'],
      ),
      _record(
        id: 'dw-5',
        childId: childId,
        now: now,
        daysAgo: 29,
        durationMinutes: 38,
        title: 'Quebra cabeca',
        goals: const ['Pensamento logico'],
        objectives: const ['Cognitivo'],
      ),
    ];
  }

  static List<Map<String, dynamic>> _singleWeekOnly(
    DateTime now,
    String childId,
  ) {
    return <Map<String, dynamic>>[
      _record(
        id: 'sw-1',
        childId: childId,
        now: now,
        daysAgo: 1,
        durationMinutes: 22,
        title: 'Canto com palmas',
        goals: const ['Musica'],
        objectives: const ['Criativo'],
      ),
      _record(
        id: 'sw-2',
        childId: childId,
        now: now,
        daysAgo: 3,
        durationMinutes: 18,
        title: 'Boliche caseiro',
        goals: const ['Coordenacao motora'],
        objectives: const ['Motor'],
      ),
      _record(
        id: 'sw-3',
        childId: childId,
        now: now,
        daysAgo: 5,
        durationMinutes: 24,
        title: 'Historia inventada',
        goals: const ['Linguagem'],
        objectives: const ['Cognitivo'],
      ),
    ];
  }

  static List<Map<String, dynamic>> _mixedCategories(
    DateTime now,
    String childId,
  ) {
    return <Map<String, dynamic>>[
      _record(
        id: 'mc-1',
        childId: childId,
        now: now,
        daysAgo: 1,
        durationMinutes: 20,
        title: 'Pista de obstaculos',
        goals: const ['Coordenacao motora'],
        objectives: const ['Motor'],
      ),
      _record(
        id: 'mc-2',
        childId: childId,
        now: now,
        daysAgo: 2,
        durationMinutes: 25,
        title: 'Jogo da empatia',
        goals: const ['Autonomia emocional'],
        objectives: const ['Emocional'],
      ),
      _record(
        id: 'mc-3',
        childId: childId,
        now: now,
        daysAgo: 4,
        durationMinutes: 22,
        title: 'Brincadeira em dupla',
        goals: const ['Socializacao'],
        objectives: const ['Social'],
      ),
      _record(
        id: 'mc-4',
        childId: childId,
        now: now,
        daysAgo: 6,
        durationMinutes: 28,
        title: 'Jogo de memoria',
        goals: const ['Concentracao'],
        objectives: const ['Cognitivo'],
      ),
      _record(
        id: 'mc-5',
        childId: childId,
        now: now,
        daysAgo: 9,
        durationMinutes: 30,
        title: 'Pintura livre',
        goals: const ['Criatividade'],
        objectives: const ['Criativo'],
      ),
    ];
  }

  static List<Map<String, dynamic>> _lowConsistency(
    DateTime now,
    String childId,
  ) {
    return <Map<String, dynamic>>[
      _record(
        id: 'lc-1',
        childId: childId,
        now: now,
        daysAgo: 2,
        durationMinutes: 15,
        title: 'Atividade curta atual',
        goals: const ['Coordenacao motora'],
        objectives: const ['Motor'],
      ),
      _record(
        id: 'lc-2',
        childId: childId,
        now: now,
        daysAgo: 16,
        durationMinutes: 35,
        title: 'Periodo anterior 1',
        goals: const ['Linguagem'],
        objectives: const ['Cognitivo'],
      ),
      _record(
        id: 'lc-3',
        childId: childId,
        now: now,
        daysAgo: 18,
        durationMinutes: 32,
        title: 'Periodo anterior 2',
        goals: const ['Socializacao'],
        objectives: const ['Social'],
      ),
      _record(
        id: 'lc-4',
        childId: childId,
        now: now,
        daysAgo: 20,
        durationMinutes: 28,
        title: 'Periodo anterior 3',
        goals: const ['Autonomia'],
        objectives: const ['Emocional'],
      ),
      _record(
        id: 'lc-5',
        childId: childId,
        now: now,
        daysAgo: 22,
        durationMinutes: 30,
        title: 'Periodo anterior 4',
        goals: const ['Criatividade'],
        objectives: const ['Criativo'],
      ),
      _record(
        id: 'lc-6',
        childId: childId,
        now: now,
        daysAgo: 24,
        durationMinutes: 40,
        title: 'Periodo anterior 5',
        goals: const ['Pensamento logico'],
        objectives: const ['Cognitivo'],
      ),
    ];
  }

  static Map<String, dynamic> _record({
    required String id,
    required String childId,
    required DateTime now,
    required int daysAgo,
    required int durationMinutes,
    required String title,
    required List<String> goals,
    required List<String> objectives,
  }) {
    final finishedAt = now.subtract(Duration(days: daysAgo));
    final createdAt = finishedAt.subtract(Duration(minutes: durationMinutes));

    return <String, dynamic>{
      '_id': id,
      'child': childId,
      'is_completed': true,
      'createdAt': createdAt.toIso8601String(),
      'finishedAt': finishedAt.toIso8601String(),
      'activity': <String, dynamic>{
        '_id': 'activity-$id',
        'title': title,
        'developmentGoals': goals,
        'objectives': objectives,
      },
    };
  }
}
