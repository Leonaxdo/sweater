import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sweater/providers/schedule_provider.dart';
import 'package:sweater/screens/schedule_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ScheduleProvider()),
      ],
      child: MaterialApp(
        title: 'SweaterProject',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: SchedulePage(),
      ),
    );
  }
}
