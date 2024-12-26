import 'package:get_strong/components/exercise_history.dart';
import 'package:get_strong/components/gradientbutton.dart';
import 'package:get_strong/components/workout_history.dart';
import 'package:get_strong/config.dart';
import 'package:get_strong/controller/train.dart';
import 'package:get_strong/model/exercise.dart';
import 'package:get_strong/model/workoutstate.dart';
import 'package:get_strong/utils/numeric_range_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

/// Train screen. Guides the user through the different exercises in a workout.
class TrainView extends GetView<TrainController> {
  final TrainController trainCtrl = Get.find();

  @override
  Widget build(BuildContext context) {
    return Obx(() => trainCtrl.workoutplan.value == null
        ? const Text(
            "Plan konnte nicht geladen werden. Bitte kontaktieren Sie den Kundensupport.")
        : Container(
            child: trainCtrl.workoutState.value == WorkoutState.idle
                ? Center(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                        Padding(
                            padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                            child: GradientButton(
                                onPressed: () => trainCtrl.startWorkout(),
                                label: "Start New Workout",
                                colorGradient: GSPrimaryGradient)),
                        trainCtrl.unfinishedWorkout.value != null ? GradientButton( // resume unfinished button only visible if there is an unfinished workout
                            onPressed: () => trainCtrl.startWorkout(unfinished: true),
                            label: "Resume Latest",
                            colorGradient: GSHighlightGradient) : Container(),
                        Padding(
                            padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                            child: WorkoutHistory(
                                workouts: trainCtrl.lastFiveWorkouts.value))
                      ]))
                : Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 0, 0, 5),
                          child: Text(trainCtrl.workoutplan.value?.name ?? "",
                              style: const TextStyle(
                                  color: GSTextColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20)),
                        ),
                        Padding(
                            padding: const EdgeInsets.fromLTRB(0, 0, 0, 3),
                            child: Text(
                                "Category: ${trainCtrl.workoutplan.value?.category ?? ""}",
                                style: const TextStyle(
                                    color: GSTextSecondaryColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12))),
                        Text(
                            "Split: ${trainCtrl.workoutplan.value?.split ?? ""}",
                            style: const TextStyle(
                                color: GSTextTernaryColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 12)),
                        Expanded(
                            child: Container(
                          margin: const EdgeInsets.fromLTRB(50, 20, 50, 20),
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                              border: Border.all(width: 2),
                              borderRadius: BorderRadius.circular(20)),
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Text(
                                    trainCtrl.currentMovement.value?.name ?? "",
                                    style: const TextStyle(
                                        color: GSTextColor,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16)),
                                TextField(
                                  controller: trainCtrl.setInputController,
                                  onSubmitted: (String input) =>
                                      {trainCtrl.setSet(int.parse(input))},
                                  decoration:
                                      const InputDecoration(labelText: "Set"),
                                  keyboardType: TextInputType.number,
                                  inputFormatters: <TextInputFormatter>[
                                    IntegerRangeFormatter(
                                        min: 0,
                                        max: trainCtrl
                                            .getNumOfSetsForCurrentExercise())
                                  ],
                                ),
                                TextField(
                                  controller: trainCtrl.repInputController,
                                  onSubmitted: (String input) => {
                                    trainCtrl.setRepsForCurrentExerciseAndSet(
                                        int.parse(input))
                                  },
                                  decoration:
                                      const InputDecoration(labelText: "Reps"),
                                  keyboardType: TextInputType.number,
                                  inputFormatters: <TextInputFormatter>[
                                    FilteringTextInputFormatter.digitsOnly
                                  ],
                                ),
                                TextField(
                                  controller: trainCtrl.weightInputController,
                                  onSubmitted: (String input) => {
                                    trainCtrl.setWeightForCurrentExerciseAndSet(
                                        num.parse(input))
                                  },
                                  decoration: const InputDecoration(
                                      labelText: "Weight"),
                                  keyboardType: TextInputType.number,
                                  inputFormatters: <TextInputFormatter>[
                                    FilteringTextInputFormatter.allow(
                                        RegExp(r'[0-9]+[,.]{0,1}[0-9]*')),
                                    TextInputFormatter.withFunction(
                                      (oldValue, newValue) => newValue.copyWith(
                                        text:
                                            newValue.text.replaceAll('.', ','),
                                      ),
                                    ),
                                  ],
                                ),
                                ExerciseHistory(
                                    exercises: trainCtrl.lastFiveWorkouts.value
                                        .map((workout) => workout.exercises[
                                            trainCtrl.currentMovementIdx])
                                        .toList(),
                                    dates: trainCtrl.lastFiveWorkouts.value
                                        .map((workout) => workout.date)
                                        .toList()),
                                (trainCtrl.workoutState.value ==
                                            WorkoutState.lastMovement &&
                                        trainCtrl.currentSet.value ==
                                            trainCtrl
                                                .getNumOfSetsForCurrentExercise())
                                    ? Container()
                                    : Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            0, 10, 0, 0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            GradientButton(
                                              onPressed: trainCtrl
                                                          .workoutState.value ==
                                                      WorkoutState.paused
                                                  ? trainCtrl.skipSetPause
                                                  : trainCtrl.currentSet
                                                              .value ==
                                                          trainCtrl
                                                              .getNumOfSetsForCurrentExercise()
                                                      ? trainCtrl.startSetPause
                                                      : () => {
                                                            trainCtrl.setSet(
                                                                trainCtrl
                                                                        .currentSet
                                                                        .value +
                                                                    1)
                                                          },
                                              label: trainCtrl
                                                          .workoutState.value ==
                                                      WorkoutState.paused
                                                  ? "Skip Pause 🕓 ${trainCtrl.setPauseTimerRemainingSeconds}s"
                                                  : trainCtrl.currentSet
                                                              .value ==
                                                          trainCtrl
                                                              .getNumOfSetsForCurrentExercise()
                                                      ? "Next Exercise"
                                                      : "Next Set",
                                              colorGradient: GSPrimaryGradient,
                                            )
                                          ],
                                        ))
                              ]),
                        )),
                        GradientButton(
                          onPressed: trainCtrl.finishWorkout,
                          label: trainCtrl.workoutState.value ==
                                  WorkoutState.lastMovement
                              ? "Finish Workout"
                              : "Save & Exit",
                          colorGradient: GSHighlightGradient,
                        )
                      ],
                    )),
          ));
  }
}
