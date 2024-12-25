import 'package:flutter/material.dart';
import 'package:get_strong/components/table_cell.dart';
import 'package:get_strong/model/workout.dart';

/// A table to show the latest workouts
class WorkoutHistory extends StatelessWidget {
  final List<Workout> workouts;
  const WorkoutHistory({super.key, required this.workouts});

  @override
  Widget build(BuildContext context) {
    var tableRows = <Row>[];
    // Add header
    final headerCells = <GSTableCell>[];
    headerCells.add(const GSTableCell(content: Text("Date"))); // date
    headerCells.add(const GSTableCell(content: Text("Finished"))); // finished
    tableRows.add(getTableRow(headerCells));

    // Add content
    for (var workout in workouts) {
      final cells = <GSTableCell>[];
      cells.add(GSTableCell(content: Text(workout.date.toString()))); // date
      cells.add(GSTableCell(
        content: Text(workout.workoutFinished ? "✔️" : "❌"),
      )); // finished
      tableRows.add(getTableRow(cells));
    }

    return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: tableRows);
  }
}

Row getTableRow(List<GSTableCell> cells) {
  return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: cells);
}
