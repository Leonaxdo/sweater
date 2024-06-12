import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class WorkoutCompleteScreen extends StatefulWidget {
  final int totalWeight;
  final String workoutTime;

  WorkoutCompleteScreen({required this.totalWeight, required this.workoutTime});

  @override
  _WorkoutCompleteScreenState createState() => _WorkoutCompleteScreenState();
}

class _WorkoutCompleteScreenState extends State<WorkoutCompleteScreen> {
  late VideoPlayerController _controller;
  bool _isLoading = true;
  String _errorMessage = "";

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset("assets/new_fireworks.mp4")
      ..initialize().then((_) {
        setState(() {
          _isLoading = false;
        });
        _controller.play();
        _controller.setLooping(true);
      }).catchError((error) {
        print("Error initializing video: $error");
        setState(() {
          _isLoading = false;
          _errorMessage = "Failed to load video: $error";
        });
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('운동 완료'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            if (_isLoading)
              Container(
                height: 300,
                width: 300,
                child: CircularProgressIndicator(),
              )
            else if (_errorMessage.isNotEmpty)
              Text(
                _errorMessage,
                style: TextStyle(color: Colors.red),
              )
            else
              Container(
                height: 300,
                width: 300,
                child: AspectRatio(
                  aspectRatio: _controller.value.aspectRatio,
                  child: VideoPlayer(_controller),
                ),
              ),
            SizedBox(height: 20),
            Text(
              '운동 완료!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text(
              '총 중량: ${widget.totalWeight} kg',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 10),
            Text(
              '운동 시간: ${widget.workoutTime}',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('홈으로 돌아가기'),
            ),
          ],
        ),
      ),
    );
  }
}
