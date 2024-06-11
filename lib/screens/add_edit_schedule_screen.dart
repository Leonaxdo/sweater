import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sweater/providers/schedule_provider.dart';

class AddEditScheduleScreen extends StatefulWidget {
  final DateTime selectedDate;
  final Schedule? schedule;

  AddEditScheduleScreen({required this.selectedDate, this.schedule});

  @override
  _AddEditScheduleScreenState createState() => _AddEditScheduleScreenState();
}

class _AddEditScheduleScreenState extends State<AddEditScheduleScreen> {
  final TextEditingController _nameController = TextEditingController();
  final List<StrengthExerciseDetail> _strengthDetails = [];
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _repsController = TextEditingController();
  final TextEditingController _setsController = TextEditingController();
  final TextEditingController _durationController = TextEditingController();
  final TextEditingController _distanceController = TextEditingController();
  bool _isStrength = true;
  bool _excludeDuration = false;
  bool _excludeDistance = false;

  @override
  void initState() {
    super.initState();
    if (widget.schedule != null) {
      _nameController.text = widget.schedule!.name;
      if (widget.schedule!.strengthDetails != null) {
        _strengthDetails.addAll(widget.schedule!.strengthDetails!);
      }
      if (widget.schedule!.cardioDetails != null) {
        _durationController.text = widget.schedule!.cardioDetails!.duration?.toString() ?? '';
        _distanceController.text = widget.schedule!.cardioDetails!.distance?.toString() ?? '';
      }
    }
  }

  void _addStrengthDetail() {
    if (_weightController.text.isNotEmpty &&
        _repsController.text.isNotEmpty &&
        _setsController.text.isNotEmpty) {
      double weight = double.parse(_weightController.text);
      int reps = int.parse(_repsController.text);
      int sets = int.parse(_setsController.text);
      setState(() {
        _strengthDetails.add(StrengthExerciseDetail(weight, reps, sets));
        _weightController.clear();
        _repsController.clear();
        _setsController.clear();
      });
    }
  }

  void _removeStrengthDetail(StrengthExerciseDetail detail) {
    setState(() {
      _strengthDetails.remove(detail);
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.schedule == null ? 'Add Schedule' : 'Edit Schedule'),
          bottom: TabBar(
            onTap: (index) {
              setState(() {
                _isStrength = index == 0;
              });
            },
            tabs: [
              Tab(text: 'Strength'),
              Tab(text: 'Cardio'),
            ],
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Exercise Name'),
              ),
              SizedBox(height: 10),
              Expanded(
                child: _isStrength
                    ? Column(
                  children: [
                    TextField(
                      controller: _weightController,
                      decoration: InputDecoration(labelText: 'Weight (kg)'),
                      keyboardType: TextInputType.number,
                    ),
                    TextField(
                      controller: _repsController,
                      decoration: InputDecoration(labelText: 'Reps'),
                      keyboardType: TextInputType.number,
                    ),
                    TextField(
                      controller: _setsController,
                      decoration: InputDecoration(labelText: 'Sets'),
                      keyboardType: TextInputType.number,
                    ),
                    ElevatedButton(
                      onPressed: _addStrengthDetail,
                      child: Text('Add Detail'),
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: _strengthDetails.length,
                        itemBuilder: (context, index) {
                          final detail = _strengthDetails[index];
                          return ListTile(
                            title: Text('${detail.weight} kg x ${detail.reps} reps x ${detail.sets} sets'),
                            trailing: IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: () => _removeStrengthDetail(detail),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                )
                    : Column(
                  children: [
                    TextField(
                      controller: _durationController,
                      decoration: InputDecoration(labelText: 'Duration (mins)'),
                      keyboardType: TextInputType.number,
                      enabled: !_excludeDuration,
                    ),
                    CheckboxListTile(
                      title: Text('Exclude Duration'),
                      value: _excludeDuration,
                      onChanged: (value) {
                        setState(() {
                          _excludeDuration = value!;
                        });
                      },
                    ),
                    TextField(
                      controller: _distanceController,
                      decoration: InputDecoration(labelText: 'Distance (km)'),
                      keyboardType: TextInputType.number,
                      enabled: !_excludeDistance,
                    ),
                    CheckboxListTile(
                      title: Text('Exclude Distance'),
                      value: _excludeDistance,
                      onChanged: (value) {
                        setState(() {
                          _excludeDistance = value!;
                        });
                      },
                    ),
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  if (_nameController.text.isNotEmpty) {
                    String name = _nameController.text;
                    if (_isStrength && _strengthDetails.isNotEmpty) {
                      Schedule newSchedule = Schedule.strength(name, _strengthDetails);
                      if (widget.schedule == null) {
                        context.read<ScheduleProvider>().addSchedule(widget.selectedDate, newSchedule);
                      } else {
                        context.read<ScheduleProvider>().updateSchedule(widget.selectedDate, widget.schedule!, newSchedule);
                      }
                    } else if (!_isStrength && (_durationController.text.isNotEmpty || _distanceController.text.isNotEmpty)) {
                      int? duration = _excludeDuration ? null : int.tryParse(_durationController.text);
                      double? distance = _excludeDistance ? null : double.tryParse(_distanceController.text);
                      Schedule newSchedule = Schedule.cardio(name, CardioExerciseDetail(duration: duration, distance: distance));
                      if (widget.schedule == null) {
                        context.read<ScheduleProvider>().addSchedule(widget.selectedDate, newSchedule);
                      } else {
                        context.read<ScheduleProvider>().updateSchedule(widget.selectedDate, widget.schedule!, newSchedule);
                      }
                    }
                    Navigator.pop(context);
                  }
                },
                child: Text(widget.schedule == null ? 'Add' : 'Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
