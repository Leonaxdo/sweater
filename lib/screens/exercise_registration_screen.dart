import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/exercise.dart';
import '../providers/exercise_data_provider.dart';

class ExerciseRegistrationScreen extends StatefulWidget {
  final DateTime selectedDate;

  ExerciseRegistrationScreen({required this.selectedDate});

  @override
  _ExerciseRegistrationScreenState createState() => _ExerciseRegistrationScreenState();
}

class _ExerciseRegistrationScreenState extends State<ExerciseRegistrationScreen> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('운동 등록'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: '운동 이름',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (_controller.text.isNotEmpty) {
                  Provider.of<ExerciseDataProvider>(context, listen: false).addExercise(
                    Exercise(name: _controller.text, date: widget.selectedDate),
                  );
                  Navigator.pop(context);
                }
              },
              child: Text('등록'),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 32.0, vertical: 16.0),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
