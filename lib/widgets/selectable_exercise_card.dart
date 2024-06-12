import 'package:flutter/material.dart';
import '../models/exercise.dart';
import '../models/exercise_set.dart';

class SelectableExerciseCard extends StatefulWidget {
  final Exercise exercise;
  final Function(int) onTotalWeightChange;
  final Function(bool) onSelected;
  final bool isSelectionMode;

  SelectableExerciseCard({
    required this.exercise,
    required this.onTotalWeightChange,
    required this.onSelected,
    required this.isSelectionMode,
  });

  @override
  _SelectableExerciseCardState createState() => _SelectableExerciseCardState();
}

class _SelectableExerciseCardState extends State<SelectableExerciseCard> {
  bool _isSelected = false;
  late List<TextEditingController> _weightControllers;
  late List<TextEditingController> _repsControllers;

  @override
  void initState() {
    super.initState();
    _weightControllers = widget.exercise.sets.map((set) => TextEditingController(text: set.weight.toString())).toList();
    _repsControllers = widget.exercise.sets.map((set) => TextEditingController(text: set.reps.toString())).toList();
  }

  @override
  void dispose() {
    _weightControllers.forEach((controller) => controller.dispose());
    _repsControllers.forEach((controller) => controller.dispose());
    super.dispose();
  }

  void _addSet() {
    setState(() {
      ExerciseSet newSet;
      if (widget.exercise.sets.isNotEmpty) {
        ExerciseSet lastSet = widget.exercise.sets.last;
        newSet = ExerciseSet(weight: lastSet.weight, reps: lastSet.reps, completed: false);
      } else {
        newSet = ExerciseSet(weight: 0, reps: 0, completed: false);
      }
      widget.exercise.sets.add(newSet);
      _weightControllers.add(TextEditingController(text: newSet.weight.toString()));
      _repsControllers.add(TextEditingController(text: newSet.reps.toString()));
      _calculateTotalWeight();
    });
  }

  void _removeSet(int index) {
    setState(() {
      widget.exercise.sets.removeAt(index);
      _weightControllers.removeAt(index).dispose();
      _repsControllers.removeAt(index).dispose();
      _calculateTotalWeight();
    });
  }

  void _calculateTotalWeight() {
    int totalWeight = widget.exercise.getCheckedTotalWeight();
    widget.onTotalWeightChange(totalWeight);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: _isSelected ? Colors.grey[300] : Colors.white,
      child: ExpansionTile(
        title: Row(
          children: [
            if (widget.isSelectionMode)
              Checkbox(
                value: _isSelected,
                onChanged: (bool? value) {
                  setState(() {
                    _isSelected = value ?? false;
                    widget.onSelected(_isSelected);
                  });
                },
              ),
            Expanded(
              child: Text(
                widget.exercise.name,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            Text(
              '${widget.exercise.getCheckedTotalWeight()} kg',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.grey[600]),
            ),
          ],
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
                        controller: _weightControllers[index],
                        decoration: InputDecoration(labelText: '무게 (kg)'),
                        keyboardType: TextInputType.number,
                        onTap: () => _weightControllers[index].selection = TextSelection(baseOffset: 0, extentOffset: _weightControllers[index].text.length),
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
                        controller: _repsControllers[index],
                        decoration: InputDecoration(labelText: '횟수'),
                        keyboardType: TextInputType.number,
                        onTap: () => _repsControllers[index].selection = TextSelection(baseOffset: 0, extentOffset: _repsControllers[index].text.length),
                        onChanged: (value) {
                          setState(() {
                            set.reps = int.tryParse(value) ?? set.reps;
                            _calculateTotalWeight();
                          });
                        },
                      ),
                    ),
                    Column(
                      children: [
                        Text(
                          '완료',
                          style: TextStyle(fontSize: 14),
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
                  ],
                ),
                trailing: Padding(
                  padding: const EdgeInsets.only(left: 16.0),
                  child: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      _removeSet(index);
                    },
                  ),
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
