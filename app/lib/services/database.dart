import 'package:get/get.dart';
import 'package:get_strong/model/user.dart';
import 'package:get_strong/model/workout.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_strong/model/workoutplan.dart';
import 'package:get_strong/services/workoutplan_loader.dart';

/// Handles communication with the remote database
class DatabaseService {

  Future<bool> createUser(GSUser user) async {
    try {
      await FirebaseFirestore.instance.collection('users').doc(user.id).set(user.toMap());
    } catch(e) {
      return false;
    }
    return true;
  }

  /// Store the workout in the database. This works for both finished and unfinished workouts.
  /// The current user's id is added before uploading.
  Future<Workout?> createWorkout(Workout? workout, GSUser? user) async {
    if (workout == null) {
      return null;
    }
    try {
      Map<String, dynamic> workoutMap = workout.toMap();
      if (user != null) {
        workoutMap['user'] = user.id;
        await FirebaseFirestore.instance.collection('workouts').add(workoutMap);
        return workout;
      }
    } catch(e) {
      return null;
    }
    return null;
  }

  /// Update the entry of the current workout in the database. 
  /// This will only work if the workout is already stored in the database.
  Future<Workout?> updateWorkout(Workout? workout) async {
    if (workout == null || workout.workoutId == null) { // If the workout has no workoutId this will not work
      return null;
    }
    try {
      Map<String, dynamic> workoutMap = workout.toMap();

      await FirebaseFirestore.instance.collection('workouts').doc(workout.workoutId).update(workoutMap);
      return workout;
    } catch(e) {
      return null;
    }
  }

  /// Get the user's last unfinished workout from the database. Will return null if there is none.
  Future<Workout?> loadLastUnfinishedWorkout(GSUser? currentUser, WorkoutPlan? workoutplan) async {
    if (currentUser == null || workoutplan == null) {
      return null;
    }
      try {
        final workoutDb = await FirebaseFirestore.instance.collection('workouts').where("user", isEqualTo: currentUser.id).where("workoutFinished", isEqualTo: false).orderBy('date', descending: true).limit(1).get();
        final workout = workoutDb.docs.first.data();
        workout['workoutId'] = workoutDb.docs.first.id;
        return Workout.fromMap(workoutDb.docs.first.data(), workoutplan);
      } catch (e) {
        print(e);
      }
      return null;
  }

  Future<List<Workout>? > loadLatest5Workouts(GSUser? currentUser, WorkoutPlan? workoutplan) async {
    if (currentUser == null || workoutplan == null) {
      return null;
    }
      try {
        final workoutDb = await FirebaseFirestore.instance.collection('workouts').where("user", isEqualTo: currentUser.id).orderBy('date', descending: true).limit(5).get();
        final workouts = <Workout>[];
        for (var element in workoutDb.docs) {
          workouts.add(Workout.fromMap(element.data(), workoutplan));
        }
        return workouts;
      } catch (e) {
        print(e);
      }
      return null;
    return null;
  }

}