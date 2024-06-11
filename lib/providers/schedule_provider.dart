import 'package:flutter/material.dart';

class ScheduleProvider with ChangeNotifier {
  Map<DateTime, List<String>> _schedules = {};

  Map<DateTime, List<String>> get schedules => _schedules;

  void addSchedule(DateTime date, String schedule) {
    if (_schedules[date] == null) {
      _schedules[date] = [];
    }
    _schedules[date]?.add(schedule);
    notifyListeners();
  }

  void removeSchedule(DateTime date, String schedule) {
    _schedules[date]?.remove(schedule);
    if (_schedules[date]?.isEmpty ?? false) {
      _schedules.remove(date);
    }
    notifyListeners();
  }
}
