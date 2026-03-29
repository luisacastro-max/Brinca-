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
}
