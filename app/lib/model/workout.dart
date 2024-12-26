import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_strong/model/exercise.dart';
import 'package:get_strong/model/workoutplan.dart';
import 'package:get_strong/utils/dates.dart';

/// A Workout is the instance in which a specific WorkoutPlan is actually carried out.
/// It contains a list of Exercises which save the achieved reps and weights for each movement in the WorkoutPlan
class Workout {
  final exercises = <Exercise>[];
  final WorkoutPlan workoutplan;
  var lastFinishedExercise = -1;
  var date = currentDate();
  var workoutFinished = false;
  String? workoutId;  // null means the workout has no equivalent in the database.

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

  void finishNextExercise() {
    lastFinishedExercise++;
    if (lastFinishedExercise == exercises.length) {
      workoutFinished = true;
    }
  }

  Map<String, dynamic> toMap() {
    return {
      'exercises': exercises.map((exercise) => exercise.toMap()).toList(),
      'lastFinishedExercise': lastFinishedExercise,
      'date': date,
      'workoutFinished': workoutFinished,
      'workoutId': workoutId
    };
  }

  Workout.fromMap(Map<String, dynamic> map, this.workoutplan) {
    for (var exercise in map['exercises']) {
      exercises.add(Exercise.fromMap(exercise));
    }
    lastFinishedExercise = map['lastFinishedExercise'];
    date = (map['date'] as Timestamp).toDate();
    workoutFinished = map['workoutFinished'];
    workoutId = map['workoutId'];
  }
}
