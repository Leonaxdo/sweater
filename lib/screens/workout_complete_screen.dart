import 'package:flutter/material.dart';

class WorkoutCompleteScreen extends StatelessWidget {
  final int totalWeight;
  final String workoutTime;

  WorkoutCompleteScreen({required this.totalWeight, required this.workoutTime});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('운동 완료'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('축하합니다! 운동을 완료했습니다!'),
            // 폭죽 애니메이션 추가 필요
            SizedBox(height: 20),
            Text('운동 시간: $workoutTime'),
            Text('총 중량: $totalWeight kg'),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.popUntil(context, (route) => route.isFirst);
              },
              child: Text('홈으로 돌아가기'),
            ),
          ],
        ),
      ),
    );
  }
}
