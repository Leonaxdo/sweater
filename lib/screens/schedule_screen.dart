import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:sweater/providers/schedule_provider.dart';

class ScheduleScreen extends StatefulWidget {
  @override
  _ScheduleScreenState createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Schedule'),
      ),
      body: Column(
        children: [
          TableCalendar(
            firstDay: DateTime.utc(2020, 10, 16),
            lastDay: DateTime.utc(2030, 3, 14),
            focusedDay: _focusedDay,
            calendarFormat: _calendarFormat,
            selectedDayPredicate: (day) {
              return isSameDay(_selectedDay, day);
            },
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
            },
            onFormatChanged: (format) {
              if (_calendarFormat != format) {
                setState(() {
                  _calendarFormat = format;
                });
              }
            },
            onPageChanged: (focusedDay) {
              _focusedDay = focusedDay;
            },
            eventLoader: (day) {
              return context.read<ScheduleProvider>().schedules[day] ?? [];
            },
          ),
          Expanded(
            child: Consumer<ScheduleProvider>(
              builder: (context, scheduleProvider, child) {
                final schedules = scheduleProvider.schedules[_selectedDay] ?? [];
                return ListView.builder(
                  itemCount: schedules.length,
                  itemBuilder: (context, index) {
                    final schedule = schedules[index];
                    if (schedule.strengthDetails != null) {
                      return ExpansionTile(
                        title: Text(schedule.name),
                        children: schedule.strengthDetails!.map((detail) {
                          return ListTile(
                            title: Text('${detail.weight} kg x ${detail.reps} reps x ${detail.sets} sets'),
                          );
                        }).toList(),
                      );
                    } else if (schedule.cardioDetails != null) {
                      return ListTile(
                        title: Text(schedule.name),
                        subtitle: Text(
                          'Duration: ${schedule.cardioDetails!.duration != null ? '${schedule.cardioDetails!.duration} mins' : 'N/A'}, '
                              'Distance: ${schedule.cardioDetails!.distance != null ? '${schedule.cardioDetails!.distance} km' : 'N/A'}',
                        ),
                      );
                    } else {
                      return ListTile(
                        title: Text(schedule.name),
                        subtitle: Text('No details available'),
                      );
                    }
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}