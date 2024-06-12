import 'package:flutter/material.dart';
import '../models/exercise.dart';
import '../models/exercise_set.dart';

class ExerciseCard extends StatefulWidget {
  final Exercise exercise;
  final Function(int) onTotalWeightChange;

  ExerciseCard({required this.exercise, required this.onTotalWeightChange});

  @override
  _ExerciseCardState createState() => _ExerciseCardState();
}

class _ExerciseCardState extends State<ExerciseCard> {
  void _addSet() {
    setState(() {
      if (widget.exercise.sets.isNotEmpty) {
        ExerciseSet lastSet = widget.exercise.sets.last;
        widget.exercise.sets.add(ExerciseSet(weight: lastSet.weight, reps: lastSet.reps, completed: false));
      } else {
        widget.exercise.sets.add(ExerciseSet(weight: 0, reps: 0, completed: false));
      }
      _calculateTotalWeight();
    });
  }

  void _removeSet(int index) {
    setState(() {
      widget.exercise.sets.removeAt(index);
      _calculateTotalWeight();
    });
  }

  void _calculateTotalWeight() {
    int totalWeight = 0;
    for (var set in widget.exercise.sets) {
      if (set.completed) {
        totalWeight += set.weight * set.reps;
      }
    }
    widget.onTotalWeightChange(totalWeight);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ExpansionTile(
        title: Text(
          widget.exercise.name,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        children: [
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: widget.exercise.sets.length,
            itemBuilder: (context, index) {
              final set = widget.exercise.sets[index];
              return ListTile(
                title: Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        initialValue: set.weight.toString(),
                        decoration: InputDecoration(labelText: '무게 (kg)'),
                        keyboardType: TextInputType.number,
                        onChanged: (value) {
                          setState(() {
                            set.weight = int.tryParse(value) ?? set.weight;
                            _calculateTotalWeight();
                          });
                        },
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: TextFormField(
                        initialValue: set.reps.toString(),
                        decoration: InputDecoration(labelText: '횟수'),
                        keyboardType: TextInputType.number,
                        onChanged: (value) {
                          setState(() {
                            set.reps = int.tryParse(value) ?? set.reps;
                            _calculateTotalWeight();
                          });
                        },
                      ),
                    ),
                    Checkbox(
                      value: set.completed,
                      onChanged: (bool? value) {
                        setState(() {
                          set.completed = value ?? false;
                          _calculateTotalWeight();
                        });
                      },
                    ),
                  ],
                ),
                trailing: IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    _removeSet(index);
                  },
                ),
              );
            },
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                onPressed: _addSet,
                child: Text('세트 추가'),
              ),
              TextButton(
                onPressed: () {
                  if (widget.exercise.sets.isNotEmpty) {
                    _removeSet(widget.exercise.sets.length - 1);
                  }
                },
                child: Text('세트 삭제'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
