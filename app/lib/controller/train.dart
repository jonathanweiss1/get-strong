import 'package:get_strong/controller/timer.dart';
import 'package:get_strong/model/movement.dart';
import 'package:get_strong/model/workout.dart';
import 'package:get_strong/model/workoutplan.dart';
import 'package:get_strong/model/workoutstate.dart';
import 'package:get_strong/services/authentication.dart';
import 'package:get_strong/services/database.dart';
import 'package:get_strong/services/workoutplan_loader.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Controller for train view
/// The train controller handles how a workout is performed. It performs the following steps:
/// 1. Load workoutplan from disk
/// 2. Wait for user to start the workout
/// 3. Collect information on different exercises from user and store in workout
/// 4. Switch between movements
/// 5. Enforce break times
/// 6. Complete workout
class TrainController extends GetxController {
  WorkoutPlanLoaderService workoutPlanLoader = Get.find<WorkoutPlanLoaderService>();
  DatabaseService databaseService = Get.find<DatabaseService>();
  AuthService authService = Get.find<AuthService>();
  final workoutplan = Rx<WorkoutPlan?>(null);
  final currentMovement = Rx<Movement?>(null);
  final workoutState = Rx<WorkoutState>(WorkoutState.idle);
  final workout = Rx<Workout?>(null);
  final currentSet = 1.obs;
  int currentMovementIdx = 0;
  final setInputController = TextEditingController();
  final repInputController = TextEditingController();
  final weightInputController = TextEditingController();
  final timer = Rx<SetPauseTimer>(SetPauseTimer(focusTime: 60));
  final setPauseTimerRemainingSeconds = 0.obs;
  final lastFiveWorkouts = Rx<List<Workout> >(<Workout>[]);
  final unfinishedWorkout = Rx<Workout?>(null);

  @override
  Future<void> onInit() async {
    workoutplan(await workoutPlanLoader.load());
    if (workoutplanNotEmpty()) {
      currentMovement(workoutplan.value!.movements[0]);
      workout(Workout(workoutplan.value!));
      setSet(1);
      setInputController.text = "1";
      timer(SetPauseTimer(focusTime: workoutplan.value!.movements[0].breakTimeSeconds));
      lastFiveWorkouts(await databaseService.loadLatest5Workouts(authService.getCurrentUser(), workoutplan.value));
      if (workoutplan.value != null) unfinishedWorkout(await databaseService.loadLastUnfinishedWorkout(authService.getCurrentUser(), workoutplan.value));
    }
    super.onInit();
  }


  /// Switches to the next movement in the plan.
  void nextMovement() {
    if (workoutplanNotEmpty() && currentMovement.value != null) {
      if (workoutplan.value!.movements.length > currentMovementIdx + 1) {
        currentMovementIdx += 1;
        workout.value?.lastFinishedExercise++;
        currentMovement(workoutplan.value!.movements[currentMovementIdx]);
        setSet(1);
      }
      else {
        currentMovement(null);
      }
      if(currentMovementIdx == workoutplan.value!.movements.length - 1) {
        workoutState(WorkoutState.lastMovement);
      }
    }
  }

  /// Shorthand to check if the workoutplan is empty
  bool workoutplanNotEmpty() {
    return workoutplan.value!.movements.isNotEmpty;
  }

  /// Switches from idle state to started state
  void startWorkout({bool unfinished = false}) {
    if (unfinished) {
      workout(unfinishedWorkout.value);
      currentMovementIdx = workout.value!.lastFinishedExercise + 1;
      currentMovement(workoutplan.value!.movements[currentMovementIdx]);
    }
    workoutState(WorkoutState.started);
  }

  int getRepsForCurrentExerciseAndSet() {
    return workout.value?.getReps(currentMovementIdx, currentSet.value) ?? 0;
  }

  void setRepsForCurrentExerciseAndSet(int newReps) {
    workout.value?.updateSet(idx: currentMovementIdx, set: currentSet.value, reps: newReps);
  }

  num getWeightForCurrentExerciseAndSet() {
    return workout.value?.getWeight(currentMovementIdx, currentSet.value) ?? 0;
  }

  void setWeightForCurrentExerciseAndSet(num newWeight) {
    workout.value?.updateSet(idx: currentMovementIdx, set: currentSet.value, weight: newWeight);
  }

  int getNumOfSetsForCurrentExercise() {
    return workout.value?.getNumOfSets(currentMovementIdx) ?? 0;
  }

  void setSet(int set) {
    currentSet(set);
    setInputController.text = "$set";
    repInputController.text = "${workout.value?.getReps(currentMovementIdx, set)}";
    weightInputController.text = "${workout.value?.getWeight(currentMovementIdx, set)}";
  }

  /// Handles all steps that need to be performed when a workout is finished
  void finishWorkout() async {
    if (workoutState.value == WorkoutState.lastMovement) {
      workout.value?.workoutFinished = true;
      workout.value?.lastFinishedExercise = currentMovementIdx;
    }
    if (workout.value!.workoutId == null) {
      await databaseService.createWorkout(workout.value, authService.getCurrentUser());
    }
    else {
      await databaseService.updateWorkout(workout.value);
    }
    workoutState(WorkoutState.idle);  // In the future this could be WorkoutState.finished instead to show a summary
    reset();
  }

  /// Reset the controller to its initial state
  void reset() {
    workoutState(WorkoutState.idle);
    currentSet(1);
    currentMovementIdx = 0;
    currentMovement(workoutplan.value!.movements[0]);
    workout(Workout(workoutplan.value!));
    setSet(1);
    setInputController.text = "1";
  }

  /// Switches the workoutstate to paused and starts set pause timer.
  /// When the timer is up, the state is automatically switched back to started or lastMovement 
  /// and the next exercise is selected.
  void startSetPause() {
    workoutState(WorkoutState.paused);
    setPauseTimerRemainingSeconds(currentMovement.value!.breakTimeSeconds);
    timer(SetPauseTimer(focusTime: currentMovement.value!.breakTimeSeconds));
    timer.value.start(callback: (bool timeNotUp) {
      if (timeNotUp) {
        setPauseTimerRemainingSeconds(setPauseTimerRemainingSeconds.value - 1);
      }
      else {
        workoutState(WorkoutState.started);
        nextMovement();
      }
    });
  }

  /// Skips the running set pause and switches directly back to started or lastMovement and selects the next exercise
  void skipSetPause() {
    timer.value.pause();
    workoutState(WorkoutState.started);
    nextMovement();
  }
}