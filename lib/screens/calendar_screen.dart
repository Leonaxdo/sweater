import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'exercise_schedule_screen.dart';
import '../providers/exercise_data_provider.dart';
import '../models/exercise.dart';
import 'exercise_registration_screen.dart';

class CalendarScreen extends StatefulWidget {
  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  CalendarFormat _calendarFormat = CalendarFormat.week;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Calendar'),
      ),
      body: Column(
        children: [
          Consumer<ExerciseDataProvider>(
            builder: (context, exerciseData, child) {
              return TableCalendar(
                firstDay: DateTime.utc(2010, 10, 16),
                lastDay: DateTime.utc(2030, 3, 14),
                focusedDay: _focusedDay,
                selectedDayPredicate: (day) {
                  return isSameDay(_selectedDay, day);
                },
                onDaySelected: (selectedDay, focusedDay) {
                  setState(() {
                    _selectedDay = selectedDay;
                    _focusedDay = focusedDay;
                  });
                },
                calendarFormat: _calendarFormat,
                onFormatChanged: (format) {
                  setState(() {
                    _calendarFormat = format;
                  });
                },
                calendarBuilders: CalendarBuilders(
                  markerBuilder: (context, date, events) {
                    String dateKey = exerciseData.formatDateKey(date);
                    if (exerciseData.exercisesByDate.containsKey(dateKey)) {
                      return Positioned(
                        bottom: 1,
                        child: Container(
                          width: 5,
                          height: 5,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.blue,
                          ),
                        ),
                      );
                    }
                    return null;
                  },
                ),
              );
            },
          ),
          Expanded(
            child: Consumer<ExerciseDataProvider>(
              builder: (context, exerciseData, child) {
                String dateKey = exerciseData.formatDateKey(_selectedDay ?? DateTime.now());
                final exercises = exerciseData.exercisesByDate[dateKey] ?? [];

                int totalWeight = exercises.fold(0, (sum, exercise) {
                  return sum + exercise.sets.fold(0, (setSum, set) {
                    return setSum + (set.weight * set.reps);
                  });
                });

                return ListView.builder(
                  itemCount: exercises.length + 1,
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      return ListTile(
                        title: Text('총 중량: $totalWeight kg'),
                      );
                    }
                    final exercise = exercises[index - 1];
                    return ListTile(
                      title: Text(exercise.name),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: exercise.sets.map((set) {
                          return Text('무게: ${set.weight} kg, 횟수: ${set.reps}, 상태: ${set.completed ? "완료" : "미완료"}');
                        }).toList(),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (_selectedDay != null) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ExerciseScheduleScreen(selectedDate: _selectedDay!),
              ),
            );
          }
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
