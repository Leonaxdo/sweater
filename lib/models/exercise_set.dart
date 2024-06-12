class ExerciseSet {
  int weight;
  int reps;
  bool completed;

  ExerciseSet({required this.weight, required this.reps, required this.completed});

  Map<String, dynamic> toJson() {
    return {
      'weight': weight,
      'reps': reps,
      'completed': completed,
    };
  }

  factory ExerciseSet.fromJson(Map<String, dynamic> json) {
    return ExerciseSet(
      weight: json['weight'],
      reps: json['reps'],
      completed: json['completed'],
    );
  }
}
