import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sweater/providers/schedule_provider.dart';
import 'package:sweater/screens/home_screen.dart';
import 'package:sweater/screens/schedule_screen.dart';
import 'package:sweater/screens/add_edit_schedule_screen.dart';
import 'package:sweater/screens/history_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ScheduleProvider(),
      child: MaterialApp(
        title: 'Sweater',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => HomeScreen(),
          '/add_edit_schedule': (context) => AddEditScheduleScreen(selectedDate: DateTime.now(), schedule: null),
        },
      ),
    );
  }
}
