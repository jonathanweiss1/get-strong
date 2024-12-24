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
}
