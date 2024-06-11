import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sweater/models/user.dart';

import '../providers/user_provider.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = context.watch<UserProvider>().user;

    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              'User Profile',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage('assets/profile_placeholder.png'),
            ),
            SizedBox(height: 20),
            if (user != null) ...[
              Text(
                'Username: ${user.email}',
                style: TextStyle(fontSize: 18),
              ),
              Text(
                'Email: ${user.email}',
                style: TextStyle(fontSize: 18),
              ),
            ],
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                context.read<UserProvider>().logout();
                Navigator.pushReplacementNamed(context, '/');
              },
              child: Text('Logout'),
            ),
          ],
        ),
      ),
    );
  }
}
