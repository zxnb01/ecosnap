import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:image_picker/image_picker.dart';
import 'challenge.dart'; // Importing Challenge Page

void main() {
  runApp(EcoSnapApp());
}

class EcoSnapApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeScreen(), // Ensure home screen is set
      routes: {
        '/challenge': (context) => ChallengesPage(),
      },
    );
  }
}

class HomeScreen extends StatelessWidget {
  final int actionsToday = 3;
  final int maxActions = 5;
  final List<int> weeklyActions = [3, 5, 2, 4, 1, 5, 0];

  Future<void> _openCamera() async {
    final picker = ImagePicker();
    await picker.pickImage(source: ImageSource.camera);
  }

  @override
  Widget build(BuildContext context) {
    double progress = actionsToday / maxActions;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            // Ensure the navigation context is valid
            if (Navigator.of(context).canPop()) {
              Navigator.pop(context);
            } else {
              Navigator.pushReplacementNamed(context, '/challenge');
            }
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Leaderboard & Badges Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(onPressed: () {}, child: Text("Leaderboard")),
                TextButton(onPressed: () {}, child: Text("Badges")),
              ],
            ),

            SizedBox(height: 20),

            // Circular Progress Tracker
            CircularPercentIndicator(
              radius: 100.0,
              lineWidth: 13.0,
              percent: progress,
              center: Icon(Icons.eco, size: 50, color: Colors.green),
              progressColor: Colors.green,
              backgroundColor: Colors.grey[300]!,
              circularStrokeCap: CircularStrokeCap.round,
            ),

            SizedBox(height: 20),

            // Weekly Tracker
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(7, (index) {
                double weeklyProgress = weeklyActions[index] / maxActions;
                return Column(
                  children: [
                    CircularPercentIndicator(
                      radius: 20.0,
                      lineWidth: 4.0,
                      percent: weeklyProgress,
                      center: Text("${weeklyActions[index]}",
                          style: TextStyle(fontSize: 12)),
                      progressColor: Colors.green,
                      backgroundColor: Colors.grey[300]!,
                      circularStrokeCap: CircularStrokeCap.round,
                    ),
                    Text(
                        [
                          "Mon",
                          "Tue",
                          "Wed",
                          "Thu",
                          "Fri",
                          "Sat",
                          "Sun"
                        ][index],
                        style: TextStyle(fontSize: 12))
                  ],
                );
              }),
            ),

            SizedBox(height: 20),

            // Snap It Button
            ElevatedButton(
              onPressed: _openCamera,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text("Snap It",
                  style: TextStyle(color: Colors.white, fontSize: 16)),
            ),
          ],
        ),
      ),
    );
  }
}
