import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/exercise.dart';
import '../providers/exercise_data_provider.dart';

class ExerciseRegistrationScreen extends StatelessWidget {
  final TextEditingController _controller = TextEditingController();
  final DateTime selectedDate;

  ExerciseRegistrationScreen({required this.selectedDate});

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
              decoration: InputDecoration(labelText: '운동 이름'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (_controller.text.isNotEmpty) {
                  Provider.of<ExerciseDataProvider>(context, listen: false).addExercise(
                    Exercise(name: _controller.text, date: selectedDate),
                  );
                  Navigator.pop(context);
                }
              },
              child: Text('등록'),
            ),
          ],
        ),
      ),
    );
  }
}
