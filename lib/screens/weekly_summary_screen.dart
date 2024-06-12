import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import '../providers/exercise_data_provider.dart';

class WeeklySummaryScreen extends StatelessWidget {
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
        );
      },
    );
  }

  List<ExerciseSummary> _createSampleData(ExerciseDataProvider exerciseData) {
    List<ExerciseSummary> data = [];
    // 주별 요약 데이터를 생성하는 로직을 구현합니다.
    // 이 예제에서는 더미 데이터를 사용합니다.
    data.add(ExerciseSummary('Sun', 50));
    data.add(ExerciseSummary('Mon', 70));
    data.add(ExerciseSummary('Tue', 100));
    data.add(ExerciseSummary('Wed', 30));
    data.add(ExerciseSummary('Thu', 90));
    data.add(ExerciseSummary('Fri', 20));
    data.add(ExerciseSummary('Sat', 80));

    return data;
  }
}

class ExerciseSummary {
  final String day;
  final int totalWeight;

  ExerciseSummary(this.day, this.totalWeight);
}
