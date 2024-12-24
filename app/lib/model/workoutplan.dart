import 'package:app/model/movement.dart';

/// A WorkoutPlan consists of multiple movements. It does not contain information on instances in which the 
/// workout was actually performed. For performance information see the workout class.
class WorkoutPlan {
  String name;
  String description;
  int durationInMinutes;
  String category;
  String split;
  var movements = <Movement>[];

  /// Initialize an empty workout plan with basic general information
  WorkoutPlan({
    required this.name,
    required this.description,
    required this.durationInMinutes,
    required this.category,
    required this.split
  });

  /// Add a new movement to the plan
  addMovement(Movement movement) {
    movements.add(movement);
  }
}