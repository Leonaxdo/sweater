import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'exercise_registration_screen.dart';
import '../models/exercise.dart';
import '../providers/exercise_data_provider.dart';
import '../widgets/exercise_card.dart';
import 'workout_complete_screen.dart';
import 'dart:async';

class ExerciseScheduleScreen extends StatefulWidget {
  final DateTime selectedDate;

  ExerciseScheduleScreen({required this.selectedDate});

  @override
  _ExerciseScheduleScreenState createState() => _ExerciseScheduleScreenState();
}

class _ExerciseScheduleScreenState extends State<ExerciseScheduleScreen> {
  bool _isWorkoutStarted = false;
  Timer? _timer;
  int _start = 0;
  int _totalWeight = 0;

  void _startWorkout() {
    setState(() {
      _isWorkoutStarted = true;
      _start = 0;
    });
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        _start++;
      });
    });
  }

  void _stopWorkout() {
    _timer?.cancel();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => WorkoutCompleteScreen(
          totalWeight: _totalWeight,
          workoutTime: _formattedTime,
        ),
      ),
    ).then((_) {
      setState(() {
        _isWorkoutStarted = false;
      });
    });
  }

  String get _formattedTime {
    final minutes = _start ~/ 60;
    final seconds = _start % 60;
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }

  void _updateTotalWeight(int weight) {
    setState(() {
      _totalWeight = weight;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('운동 스케줄 (${widget.selectedDate.toLocal().toIso8601String().split('T')[0]})'),
        actions: [
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              Provider.of<ExerciseDataProvider>(context, listen: false).clearExercises();
              setState(() {
                _totalWeight = 0;
              });
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Consumer<ExerciseDataProvider>(
              builder: (context, exerciseData, child) {
                String dateKey = exerciseData.formatDateKey(widget.selectedDate);
                final exercises = exerciseData.exercisesByDate[dateKey] ?? [];
                return ListView.builder(
                  itemCount: exercises.length,
                  itemBuilder: (context, index) {
                    return ExerciseCard(
                      exercise: exercises[index],
                      onTotalWeightChange: _updateTotalWeight,
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Text('총 중량: $_totalWeight kg'),
                _isWorkoutStarted
                    ? Column(
                  children: [
                    Text('운동 시간: $_formattedTime'),
                    ElevatedButton(
                      onPressed: _stopWorkout,
                      child: Text('운동 완료'),
                    ),
                  ],
                )
                    : ElevatedButton(
                  onPressed: _startWorkout,
                  child: Text('운동 시작'),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ExerciseRegistrationScreen(selectedDate: widget.selectedDate),
            ),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
