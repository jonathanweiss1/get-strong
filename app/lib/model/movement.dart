import 'dart:core';

/// A movement is a building block for a workout plan. It does not contain information about an instance
/// at which the movement was actually performed. For performance information consider the Exercise class.
class Movement {
  String name;
  int? sets;
  int? reps;
  String? repUnit;
  num? weight;
  String? weightUnit;
  int breakTimeSeconds;
  String muscleGroup;
  var equipment = <String>[];

  Movement(
      {required this.name,
      this.sets,
      this.reps,
      this.repUnit,
      this.weight,
      this.weightUnit,
      required this.breakTimeSeconds,
      required this.muscleGroup,
      required this.equipment});

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'sets': sets,
      'reps': reps,
      'repUnit': repUnit,
      'weight': weight,
      'weightUnit': weightUnit,
      'breakTimeSeconds': breakTimeSeconds,
      'muscleGroup': muscleGroup,
      'equipment': equipment
    };
  }

  Movement.fromMap(Map<String, dynamic> map) 
    : name = map['name'], 
      sets = map['sets'],
      reps = map['reps'],
      repUnit = map['repUnit'],
      weight = map['weight'],
      weightUnit = map['weightUnit'],
      breakTimeSeconds = map['breakTimeSeconds'],
      muscleGroup = map['muscleGroup'],
      equipment = List<String>.from(map['equipment'] as List);
}
