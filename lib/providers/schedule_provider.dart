import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class StrengthExerciseDetail {
  final double weight;
  final int reps;
  final int sets;

  StrengthExerciseDetail(this.weight, this.reps, this.sets);

  Map<String, dynamic> toJson() => {
    'weight': weight,
    'reps': reps,
    'sets': sets,
  };

  factory StrengthExerciseDetail.fromJson(Map<String, dynamic> json) {
    return StrengthExerciseDetail(
      json['weight'],
      json['reps'],
      json['sets'],
    );
  }
}

class CardioExerciseDetail {
  final int? duration;
  final double? distance;

  CardioExerciseDetail({this.duration, this.distance});

  Map<String, dynamic> toJson() => {
    'duration': duration,
    'distance': distance,
  };

  factory CardioExerciseDetail.fromJson(Map<String, dynamic> json) {
    return CardioExerciseDetail(
      duration: json['duration'],
      distance: json['distance'],
    );
  }
}

class Schedule {
  final String name;
  final List<StrengthExerciseDetail>? strengthDetails;
  final CardioExerciseDetail? cardioDetails;

  Schedule.strength(this.name, this.strengthDetails) : cardioDetails = null;
  Schedule.cardio(this.name, this.cardioDetails) : strengthDetails = null;

  Map<String, dynamic> toJson() => {
    'name': name,
    'strengthDetails': strengthDetails?.map((e) => e.toJson()).toList(),
    'cardioDetails': cardioDetails?.toJson(),
  };

  factory Schedule.fromJson(Map<String, dynamic> json) {
    return json['strengthDetails'] != null
        ? Schedule.strength(
      json['name'],
      (json['strengthDetails'] as List<dynamic>)
          .map((e) => StrengthExerciseDetail.fromJson(e))
          .toList(),
    )
        : Schedule.cardio(
      json['name'],
      CardioExerciseDetail.fromJson(json['cardioDetails']),
    );
  }
}

class ScheduleProvider with ChangeNotifier {
  Map<DateTime, List<Schedule>> _schedules = {};

  Map<DateTime, List<Schedule>> get schedules => _schedules;

  ScheduleProvider() {
    _loadFromPrefs();
  }

  void addSchedule(DateTime date, Schedule schedule) {
    if (_schedules[date] == null) {
      _schedules[date] = [];
    }
    _schedules[date]?.add(schedule);
    notifyListeners();
    _saveToPrefs();
  }

  void removeSchedule(DateTime date, Schedule schedule) {
    _schedules[date]?.remove(schedule);
    if (_schedules[date]?.isEmpty ?? false) {
      _schedules.remove(date);
    }
    notifyListeners();
    _saveToPrefs();
  }

  void updateSchedule(DateTime date, Schedule oldSchedule, Schedule newSchedule) {
    final scheduleList = _schedules[date];
    if (scheduleList != null) {
      final index = scheduleList.indexOf(oldSchedule);
      if (index != -1) {
        scheduleList[index] = newSchedule;
        notifyListeners();
        _saveToPrefs();
      }
    }
  }

  double getTotalWeight(DateTime date) {
    if (_schedules[date] == null) return 0;
    return _schedules[date]!.fold(0, (total, schedule) {
      if (schedule.strengthDetails != null) {
        return total + schedule.strengthDetails!.fold(0, (detailTotal, detail) {
          return detailTotal + (detail.weight * detail.reps * detail.sets);
        });
      }
      return total;
    });
  }

  Future<void> _saveToPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final data = _schedules.map((key, value) =>
        MapEntry(key.toIso8601String(), jsonEncode(value.map((e) => e.toJson()).toList())));
    await prefs.setString('schedules', jsonEncode(data));
  }

  Future<void> _loadFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString('schedules');
    if (data != null) {
      final Map<String, dynamic> jsonData = jsonDecode(data);
      _schedules = jsonData.map((key, value) {
        final date = DateTime.parse(key);
        final schedules = (jsonDecode(value) as List<dynamic>)
            .map((e) => Schedule.fromJson(e))
            .toList();
        return MapEntry(date, schedules);
      });
      notifyListeners();
    }
  }
}
