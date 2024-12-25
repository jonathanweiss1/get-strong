import 'package:get/get.dart';
import 'package:get_strong/model/user.dart';
import 'package:get_strong/model/workout.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_strong/services/authentication.dart';

/// Handles communication with the remote database
class DatabaseService {
  AuthService authService = Get.find<AuthService>();

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
  Future<Workout?> createWorkout(Workout? workout) async {
    if (workout == null) {
      return null;
    }
    try {
      Map<String, dynamic> workoutMap = workout.toMap();
      final user = authService.getCurrentUser();
      if (user != null) {
        workoutMap['user'] = user.id;
        await FirebaseFirestore.instance.collection('workouts').add(workoutMap);
        return workout;
      }
    } catch(e) {
      return null;
    }
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
  Future<Workout?> loadLastUnfinishedWorkout() async {
      /// Get the current user's id
      final user = authService.getCurrentUser();
      // Map<String, dynamic> workoutMap = await FirebaseFirestore.instance.collection('workouts').where('user', isEqualTo: user!.id).where('workoutFinished', isEqualTo: false).orderBy('date', descending: true).limit(1);
  }

}