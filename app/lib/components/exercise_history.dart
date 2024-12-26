import 'package:flutter/material.dart';
import 'package:get_strong/model/exercise.dart';

/// A table to show the history of exercises
class ExerciseHistory extends StatelessWidget {
  final List<Exercise> exercises;
  final List<DateTime> dates;

  /// exercises and dates are supposed to be list of same length where the entry at an index in dates resembles the entry in exercises of the same index
  const ExerciseHistory(
      {super.key, required this.exercises, required this.dates});

  @override
  Widget build(BuildContext context) {
    var tableRows = <DataRow>[];
    const style = TextStyle(fontSize: 12.0);

    // Add content
    for (int i = 0; i < exercises.length; i++) {
      final numOfSets = exercises[i].getNumOfSets();

      // For each set in the given list of exercises, add one row to the table
      for (int set = 0; set < numOfSets; set++) {
        final cells = <DataCell>[];
        final reps = exercises[i].getReps(set + 1);
        final weight = exercises[i].getWeight(set + 1);
        final orm = exercises[i].calculate1RM(weight, reps);

        cells.add(DataCell(
            Text(dates[i].toString().substring(0, 10), style: style))); // date
        cells.add(DataCell(
          Text((set + 1).toString(), style: style),
        )); // set
        cells.add(DataCell(
          Text(reps.toString(), style: style),
        )); // reps
        cells.add(DataCell(
          Text(weight.toString(), style: style),
        )); // weight
        cells.add(DataCell(
          Text(orm.toStringAsFixed(2), style: style),
        )); // orm
        tableRows.add(DataRow(cells: cells));
      }
    }

    return SizedBox(
        height: 200,
        child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: DataTable(
                horizontalMargin: 0,
                columnSpacing: 0,
                columns: const <DataColumn>[
                  DataColumn(
                    label: Text('Date', style: style),
                  ),
                  DataColumn(
                    label: Text('Set', style: style),
                  ),
                  DataColumn(
                    label: Text('Weight', style: style),
                  ),
                  DataColumn(
                    label: Text('Reps', style: style),
                  ),
                  DataColumn(
                    label: Text('1RM', style: style),
                  ),
                ],
                rows: tableRows)));
  }
}
