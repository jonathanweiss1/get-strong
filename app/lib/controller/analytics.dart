import 'dart:math';

import 'package:get/get.dart';
import 'package:get_strong/controller/train.dart';
import 'package:get_strong/model/workout.dart';
// import 'package:fl_chart/fl_chart.dart';

class AnalyticsController extends GetxController {
  final TrainController trainCtrl = Get.find();
  final highest1RM = 0.0.obs;
  final mostReps = 0.obs;
  final highestWeight = 0.0.obs;

  @override
  void onInit() {
    trainCtrl.lastFiveWorkouts.listen((value) {
      num highest1RMTemp = 0;
      int mostRepsTemp = 0;
      num highestWeightTemp = 0;
      Workout? lastWorkout = trainCtrl.lastFiveWorkouts.value.isNotEmpty
          ? trainCtrl.lastFiveWorkouts.value[0]
          : null;

      if (lastWorkout == null) {
        return;
      }

      /// find last workout
      for (var workout in trainCtrl.lastFiveWorkouts.value) {
        if (workout.date.isAfter(lastWorkout!.date)) {
          lastWorkout = workout;
        }
      }

      /// find best exercises
      for (var exercise in lastWorkout!.exercises) {
        for (int set = 0; set < exercise.getNumOfSets(); set++) {
          try {
            final current1RM = exercise.calculate1RM(
                exercise.weights[set], exercise.reps[set]);
            if (highest1RMTemp < current1RM) {
              highest1RMTemp = current1RM;
            }
            if (mostRepsTemp < exercise.reps[set]) {
              mostRepsTemp = exercise.reps[set];
            }
            if (highestWeightTemp < exercise.weights[set]) {
              highestWeightTemp = exercise.weights[set];
            }
          } catch (e) {
            print(e);
          }
        }
      }
      highest1RM(highest1RMTemp as double);
      mostReps(mostRepsTemp);
      highestWeight(highestWeightTemp as double);
    });
    super.onInit();
  }
}
