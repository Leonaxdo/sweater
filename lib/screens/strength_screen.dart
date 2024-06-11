import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sweater/providers/schedule_provider.dart';

class StrengthScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<ScheduleProvider>(
      builder: (context, scheduleProvider, child) {
        final schedules = scheduleProvider.schedules[DateTime.now()] ?? [];
        double totalWeight = scheduleProvider.getTotalWeight(DateTime.now());

        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Total Weight Volume: $totalWeight kg',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              Expanded(
                child: ListView.builder(
                  itemCount: schedules.length,
                  itemBuilder: (context, index) {
                    final schedule = schedules[index];
                    if (schedule.strengthDetails != null) {
                      return Card(
                        elevation: 4,
                        margin: EdgeInsets.symmetric(vertical: 8),
                        child: ListTile(
                          title: Text(schedule.name, style: TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: schedule.strengthDetails!.map((detail) {
                              return Text('${detail.weight} kg x ${detail.reps} reps x ${detail.sets} sets');
                            }).toList(),
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
