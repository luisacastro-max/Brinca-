class ChildModel {
  String? id;
  String name;
  String ageRange;
  String dailyTime;
  List<String> objectives;
  List<String> interests;

  ChildModel({
    this.id,
    required this.name,
    required this.ageRange,
    required this.dailyTime,
    required this.objectives,
    required this.interests,
  });

  // Converte o objeto Dart para um Map (JSON) para enviar ao MongoDB
  Map<String, dynamic> toJson() {
    return {
      'nome': name,
      'idade_range': ageRange,
      'tempo_diario_minutos': dailyTime,
      'objetivos': objectives,
      'interesses': interests,
    };
  }

  // Cria um objeto Dart a partir de um Map vindo do banco
  factory ChildModel.fromJson(Map<String, dynamic> json) {
    return ChildModel(
      name: json['nome'] ?? '',
      ageRange: json['idade_range'] ?? '',
      dailyTime: json['tempo_diario_minutos'] ?? '',
      objectives: List<String>.from(json['objetivos'] ?? []),
      interests: List<String>.from(json['interesses'] ?? []),
    );
  }
}
