import 'package:app/model/exercise.dart';
import 'package:app/model/workoutplan.dart';

/// A Workout is the instance in which a specific WorkoutPlan is actually carried out.
/// It contains a list of Exercises which save the achieved reps and weights for each movement in the WorkoutPlan
class Workout {
  final exercises = <Exercise>[];
  final WorkoutPlan workoutplan;

  /// Initializes the list of exercises with the default values for each movement
  Workout(this.workoutplan) {
    for (var movement in workoutplan.movements) {
      exercises.add(Exercise(movement));
    }
  }

  /// Update the number of reps or the weight for a specific set for the movement at position idx in the current Workout.
  void updateSet({required int idx, required int set, int? reps, num? weight}) {
    if (reps != null) {
      exercises[idx].updateReps(set, reps);
    }
    if (weight != null) {
      exercises[idx].updateWeight(set, weight);
    }
  }

  /// return reps for exercise at idx and set (set is 1-based index)
  int getReps(int idx, int set) {
    return exercises[idx].getReps(set);
  }

  /// return weight for exercise at idx and set (set is 1-based index)
  num getWeight(int idx, int set) {
    return exercises[idx].getWeight(set);
  }

  /// return the number of sets for movement at idx
  int getNumOfSets(int idx) {
    return exercises[idx].getNumOfSets();
  }
}
