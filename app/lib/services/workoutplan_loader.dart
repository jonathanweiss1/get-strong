import 'dart:convert';

import 'package:app/model/movement.dart';
import 'package:app/model/workoutplan.dart';
import 'package:flutter/services.dart';

class WorkoutPlanLoaderService {
  final String pathToPlan = 'assets/trainingsplan.json';
    
  Future<String> loadAsset(String pathToAsset) async {
    String asset = await rootBundle.loadString(pathToAsset);
    return asset;
  }

  Future<WorkoutPlan?> load() async {
    final String workoutplanAsset = await loadAsset(pathToPlan);
    final dynamic workoutplanJson = jsonDecode(workoutplanAsset);

    WorkoutPlan workoutplan = WorkoutPlan(
      name: workoutplanJson["name"] as String,
      description: workoutplanJson["description"] as String,
      durationInMinutes: workoutplanJson["duration"] as int,
      category: workoutplanJson["category"] as String,
      split: workoutplanJson["split"] as String
    );

    for (var movement in workoutplanJson["exercises"]) {

      // Cast equipment list from List<dynamic> to List<String>
      List<String> equipment = [];
      for (var equipmentPiece in movement["equipment"]) {
        equipment.add(equipmentPiece as String);
      }

      workoutplan.addMovement(Movement(
        name: movement["name"] as String,
        sets: movement["sets"] as int,
        reps: movement["reps"] as int,
        repUnit: movement["repUnit"] as String,
        weight: movement["weight"] as num,
        weightUnit: movement["weightUnit"] as String,
        breakTimeSeconds: movement["break"] as int,
        muscleGroup: movement["muscleGroup"] as String,
        equipment: equipment  // equipment can now be expected to be List<String>
      ));
    }

    return workoutplan;
  }
}