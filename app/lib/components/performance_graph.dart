import 'package:flutter/material.dart';
import 'package:get_strong/model/exercise.dart';

/// A graph plotting the weight progression, reps progression and 1rp progression
class PerformanceGraph extends StatelessWidget {
  final List<Exercise> exercises;
  final List<DateTime> dates;
  final Gradient colorGradient;
  late final List<num> orm;

  PerformanceGraph(
      {super.key,
      required this.exercises,
      required this.dates,
      required this.colorGradient}) {
    orm = calculate1RMes(exercises);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 32,
        decoration: BoxDecoration(
            gradient: colorGradient, borderRadius: BorderRadius.circular(20)),
        padding: const EdgeInsets.fromLTRB(8, 2, 8, 2),
        child: Text("Graph"));
  }
}

/// Return the 1pm of each exercise instance based on the last set.
List<num> calculate1RMes(List<Exercise> exercises) {
  return exercises.map((exercise) => exercise.calculate1RM(
      exercise.weights[exercise.getNumOfSets()],
      exercise.reps[exercise.getNumOfSets()])).toList();
}
