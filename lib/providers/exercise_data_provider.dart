import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/exercise.dart';

class ExerciseDataProvider extends ChangeNotifier {
  Map<String, List<Exercise>> _exercisesByDate = {};

  Map<String, List<Exercise>> get exercisesByDate => _exercisesByDate;

  ExerciseDataProvider() {
    _loadExercises();
  }

  void addExercise(Exercise exercise) {
    String dateKey = formatDateKey(exercise.date);
    if (_exercisesByDate[dateKey] == null) {
      _exercisesByDate[dateKey] = [];
    }
    _exercisesByDate[dateKey]!.add(exercise);
    saveExercises();
    notifyListeners();
  }

  void removeExercise(DateTime date, Exercise exercise) {
    String dateKey = formatDateKey(date);
    _exercisesByDate[dateKey]?.remove(exercise);
    saveExercises();
    notifyListeners();
  }

  void saveExercises() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String jsonExercises = jsonEncode(_exercisesByDate.map((key, value) {
      return MapEntry(key, value.map((e) => e.toJson()).toList());
    }));
    await prefs.setString('exercisesByDate', jsonExercises);
  }

  void _loadExercises() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? jsonExercises = prefs.getString('exercisesByDate');
    if (jsonExercises != null) {
      Map<String, dynamic> exercisesMap = jsonDecode(jsonExercises);
      _exercisesByDate = exercisesMap.map((key, value) {
        List<Exercise> exercisesList = (value as List).map((e) => Exercise.fromJson(e)).toList();
        return MapEntry(key, exercisesList);
      });
      notifyListeners();
    }
  }

  void clearExercises() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('exercisesByDate');
    _exercisesByDate = {};
    notifyListeners();
  }

  String formatDateKey(DateTime date) {
    return '${date.year}-${date.month}-${date.day}';
  }
}
