import 'package:flutter/material.dart';
import 'package:get_strong/model/workout.dart';

/// A table to show the latest workouts
class WorkoutHistory extends StatelessWidget {
  final List<Workout> workouts;
  const WorkoutHistory({super.key, required this.workouts});

  @override
  Widget build(BuildContext context) {
    var tableRows = <DataRow>[];

    // Add content
    for (var workout in workouts) {
      final cells = <DataCell>[];
      cells.add(DataCell(Text(workout.date.toString().substring(0,10)))); // date
      cells.add(DataCell(
        Text(workout.workoutFinished ? "✔️" : "❌"),
      )); // finished
      tableRows.add(DataRow(cells: cells));
    }

    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
        child: DataTable(columns: const <DataColumn>[
      DataColumn(
        label: Expanded(
          child: Text(
            'Date',
          ),
        ),
      ),
      DataColumn(
        label: Expanded(
          child: Text(
            'Finished',
          ),
        ),
      ),
    ], rows: tableRows));
  }
}
