class OnboardingChildModel {
  OnboardingChildModel({
    this.name = '',
    this.ageOptionIndex,
    this.timeOptionIndex,
    List<String>? developmentGoals,
    List<String>? interests,
  }) : developmentGoals = developmentGoals ?? <String>[],
       interests = interests ?? <String>[];

  String name;
  int? ageOptionIndex;
  int? timeOptionIndex;
  List<String> developmentGoals;
  List<String> interests;

  OnboardingChildModel copyWith({
    String? name,
    int? ageOptionIndex,
    int? timeOptionIndex,
    List<String>? developmentGoals,
    List<String>? interests,
    bool clearAgeOptionIndex = false,
    bool clearTimeOptionIndex = false,
  }) {
    return OnboardingChildModel(
      name: name ?? this.name,
      ageOptionIndex: clearAgeOptionIndex
          ? null
          : (ageOptionIndex ?? this.ageOptionIndex),
      timeOptionIndex: clearTimeOptionIndex
          ? null
          : (timeOptionIndex ?? this.timeOptionIndex),
      developmentGoals:
          developmentGoals ?? List<String>.from(this.developmentGoals),
      interests: interests ?? List<String>.from(this.interests),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'ageOptionIndex': ageOptionIndex,
      'timeOptionIndex': timeOptionIndex,
      'developmentGoals': List<String>.from(developmentGoals),
      'interests': List<String>.from(interests),
    };
  }

  factory OnboardingChildModel.fromJson(Map<String, dynamic> json) {
    return OnboardingChildModel(
      name: (json['name'] ?? '').toString(),
      ageOptionIndex: json['ageOptionIndex'] as int?,
      timeOptionIndex: json['timeOptionIndex'] as int?,
      developmentGoals: (json['developmentGoals'] as List<dynamic>? ?? const [])
          .map((item) => item.toString())
          .toList(),
      interests: (json['interests'] as List<dynamic>? ?? const [])
          .map((item) => item.toString())
          .toList(),
    );
  }
}
