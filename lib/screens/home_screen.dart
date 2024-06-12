import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'exercise_schedule_screen.dart';
import '../providers/exercise_data_provider.dart';
import '../models/exercise.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sweater'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ExerciseScheduleScreen(selectedDate: DateTime.now())),
                );
              },
              child: Text('오늘의 운동 시작하기'),
            ),
            SizedBox(height: 20),
            Expanded(child: WeeklySummaryChart()),
          ],
        ),
      ),
    );
  }
}

class WeeklySummaryChart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<ExerciseDataProvider>(
      builder: (context, exerciseData, child) {
        final data = _createSampleData(exerciseData);
        List<charts.Series<ExerciseSummary, String>> series = [
          charts.Series(
            id: 'WeeklySummary',
            domainFn: (ExerciseSummary summary, _) => summary.day,
            measureFn: (ExerciseSummary summary, _) => summary.totalWeight,
            colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
            data: data,
          )
        ];

        return charts.BarChart(
          series,
          animate: true,
          primaryMeasureAxis: charts.NumericAxisSpec(
            viewport: charts.NumericExtents(0, 10000),
          ),
        );
      },
    );
  }

  List<ExerciseSummary> _createSampleData(ExerciseDataProvider exerciseData) {
    List<ExerciseSummary> data = [];
    List<String> daysOfWeek = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];

    DateTime today = DateTime.now();
    DateTime startOfWeek = today.subtract(Duration(days: today.weekday - 1));

    for (var i = 0; i < 7; i++) {
      int totalWeight = 0;
      DateTime date = startOfWeek.add(Duration(days: i));
      String dateKey = exerciseData.formatDateKey(date);
      final exercises = exerciseData.exercisesByDate[dateKey] ?? [];
      for (var exercise in exercises) {
        for (var set in exercise.sets) {
          totalWeight += set.weight * set.reps;
        }
      }
      data.add(ExerciseSummary(daysOfWeek[date.weekday % 7], totalWeight));
    }

    return data;
  }
}

class ExerciseSummary {
  final String day;
  final int totalWeight;

  ExerciseSummary(this.day, this.totalWeight);
}
