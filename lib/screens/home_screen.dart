import 'package:flutter/material.dart';
import 'package:sweater/screens/strength_screen.dart';
import 'package:sweater/screens/cardio_screen.dart';
import 'package:sweater/screens/history_screen.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Home'),
          bottom: TabBar(
            tabs: [
              Tab(icon: Icon(Icons.fitness_center), text: 'Strength'),
              Tab(icon: Icon(Icons.directions_run), text: 'Cardio'),
              Tab(icon: Icon(Icons.history), text: 'History'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            StrengthScreen(),  // Strength Workouts
            CardioScreen(),  // Cardio Workouts
            HistoryScreen(),
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            Navigator.pushNamed(context, '/add_edit_schedule');
          },
          label: Text("Let's Sweat"),
          icon: Icon(Icons.play_arrow),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        bottomNavigationBar: BottomAppBar(
          shape: CircularNotchedRectangle(),
          notchMargin: 10.0,
          child: Container(
            height: 60,
          ),
        ),
      ),
    );
  }
}
