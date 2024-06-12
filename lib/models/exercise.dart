import 'exercise_set.dart';

class Exercise {
  String name;
  List<ExerciseSet> sets;
  DateTime date;

  Exercise({required this.name, required this.date, List<ExerciseSet>? sets}) : sets = sets ?? [];

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'date': date.toIso8601String(),
      'sets': sets.map((set) => set.toJson()).toList(),
    };
  }

  factory Exercise.fromJson(Map<String, dynamic> json) {
    var setsFromJson = json['sets'] as List;
    List<ExerciseSet> setsList = setsFromJson.map((i) => ExerciseSet.fromJson(i)).toList();

    return Exercise(
      name: json['name'],
      date: DateTime.parse(json['date']),
      sets: setsList,
    );
  }
}
