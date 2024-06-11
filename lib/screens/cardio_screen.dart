import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sweater/providers/schedule_provider.dart';

class CardioScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<ScheduleProvider>(
      builder: (context, scheduleProvider, child) {
        final schedules = scheduleProvider.schedules[DateTime.now()] ?? [];
        int totalDuration = schedules.fold(0, (total, schedule) {
          if (schedule.cardioDetails != null) {
            return total + (schedule.cardioDetails!.duration ?? 0);
          }
          return total;
        });
        double totalDistance = schedules.fold(0, (total, schedule) {
          if (schedule.cardioDetails != null) {
            return total + (schedule.cardioDetails!.distance ?? 0);
          }
          return total;
        });

        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Total Distance: $totalDistance km',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                'Total Duration: $totalDuration mins',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              Expanded(
                child: ListView.builder(
                  itemCount: schedules.length,
                  itemBuilder: (context, index) {
                    final schedule = schedules[index];
                    if (schedule.cardioDetails != null) {
                      return Card(
                        elevation: 4,
                        margin: EdgeInsets.symmetric(vertical: 8),
                        child: ListTile(
                          title: Text(schedule.name, style: TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Text(
                            'Duration: ${schedule.cardioDetails!.duration ?? 'N/A'} mins\n'
                                'Distance: ${schedule.cardioDetails!.distance ?? 'N/A'} km',
                          ),
                        ),
                      );
                    } else {
                      return SizedBox.shrink();
                    }
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
