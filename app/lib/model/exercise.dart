import 'dart:math';

import 'package:get_strong/model/movement.dart';

/// Exercise is the actual instance in which a specific movement is performed multiple times.
class Exercise {
  final Movement movement;
  final reps = <int>[];
  final weights = <num>[];

  /// Initializes the sets and reps with the default values from the given movement.
  Exercise(this.movement) {
    if (movement.sets != null) {
      for (var i = 0; i < (movement.sets ?? 0); i++) {
        reps.add(movement.reps ?? 0);
        weights.add(movement.weight ?? 0);
      }
    }
  }

  /// Update the number of reps for the given set
  /// set: number bigger than 1
  void updateReps(int set, int reps) {
    this.reps[set - 1] = reps;
  }

  /// Update weight for the given set
  /// set: number bigger than 1
  void updateWeight(int set, num weight) {
    weights[set - 1] = weight;
  }

  /// set is a 1-based index
  int getReps(int set) {
    return reps[set-1];
  }

  /// set is a 1-based index
  num getWeight(int set) {
    return weights[set - 1];
  }

  int getNumOfSets() {
    return reps.length;
  }

  /// Estimate the one repetition maximum given latest weight and number of repetitions
  /// Implements Mayhew et al. formula
  num calculate1RM(num weight, int reps) {
    return weight * pow((0.522 + 0.419 * pow(e, -0.055 * reps)), -1);
  }

  Map<String, dynamic> toMap() {
    return {
      'movement': movement.toMap(),
      'reps': reps,
      'weights': weights
    };
  }

  Exercise.fromMap(Map<String, dynamic> map) : movement = Movement.fromMap(map['movement']) {
    map['reps'].forEach((element) => reps.add(element));
    map['weights'].forEach((element) => weights.add(element));
  }

}
