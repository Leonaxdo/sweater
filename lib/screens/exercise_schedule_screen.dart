import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'exercise_registration_screen.dart';
import '../models/exercise.dart';
import '../providers/exercise_data_provider.dart';
import '../widgets/selectable_exercise_card.dart';
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
  bool _isSelectionMode = false;
  Set<Exercise> _selectedExercises = {};

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

  void _updateTotalWeight() {
    setState(() {
      _totalWeight = Provider.of<ExerciseDataProvider>(context, listen: false)
          .exercisesByDate[Provider.of<ExerciseDataProvider>(context, listen: false).formatDateKey(widget.selectedDate)]!
          .map((e) => e.getCheckedTotalWeight())
          .fold(0, (prev, element) => prev + element);
    });
  }

  void _deleteSelectedExercises() {
    setState(() {
      _selectedExercises.forEach((exercise) {
        Provider.of<ExerciseDataProvider>(context, listen: false).removeExercise(widget.selectedDate, exercise);
      });
      _selectedExercises.clear();
      _isSelectionMode = false;
      _updateTotalWeight();
    });
  }

  void _toggleSelectionMode() {
    setState(() {
      _isSelectionMode = !_isSelectionMode;
      if (!_isSelectionMode) {
        _selectedExercises.clear();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('운동 스케줄 (${widget.selectedDate.toLocal().toIso8601String().split('T')[0]})'),
        actions: [
          IconButton(
            icon: Icon(_isSelectionMode ? Icons.close : Icons.delete),
            onPressed: _toggleSelectionMode,
          ),
          if (_isSelectionMode)
            IconButton(
              icon: Icon(Icons.check),
              onPressed: _selectedExercises.isEmpty ? null : _deleteSelectedExercises,
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
                _totalWeight = exercises.map((e) => e.getCheckedTotalWeight()).fold(0, (prev, element) => prev + element);
                return ListView.builder(
                  itemCount: exercises.length,
                  itemBuilder: (context, index) {
                    return SelectableExerciseCard(
                      exercise: exercises[index],
                      onTotalWeightChange: (weight) {
                        _updateTotalWeight();
                      },
                      onSelected: (isSelected) {
                        setState(() {
                          if (isSelected) {
                            _selectedExercises.add(exercises[index]);
                          } else {
                            _selectedExercises.remove(exercises[index]);
                          }
                        });
                      },
                      isSelectionMode: _isSelectionMode,
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
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(horizontal: 32.0, vertical: 16.0),
                      ),
                    ),
                  ],
                )
                    : ElevatedButton(
                  onPressed: _startWorkout,
                  child: Text('운동 시작'),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 32.0, vertical: 16.0),
                  ),
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
          ).then((_) => _updateTotalWeight());
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
