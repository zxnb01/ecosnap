import 'package:flutter/material.dart';
import 'package:new_proj/challenge.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rive/rive.dart';
import 'package:flutter/services.dart';

import 'profile.dart';

void main() {
  runApp(EcoSnapApp());
}

class EcoSnapApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int actionsToday = 0;
  final int maxActions = 5;
  int points = 50;

  Artboard? _riveArtboard;
  SMIInput<double>? _growInput;

  @override
  void initState() {
    super.initState();
    _loadRiveAnimation();
  }

  Future<void> _loadRiveAnimation() async {
    try {
      final data = await rootBundle.load('assets/plante.riv');
      final file = RiveFile.import(data);
      final artboard = file.mainArtboard;

      var controller =
          StateMachineController.fromArtboard(artboard, 'State Machine 1');
      if (controller != null) {
        artboard.addController(controller);
        _growInput = controller.findInput<double>('Grow');
        if (_growInput != null) {
          _updateRiveAnimation();
        }
        print("✅ Rive animation loaded successfully");
      } else {
        print("❌ StateMachineController not found");
      }
      setState(() => _riveArtboard = artboard);
    } catch (e) {
      print("❌ Error loading Rive file: $e");
    }
  }

  void _updateRiveAnimation() {
    if (_growInput != null) {
      double growthStage =
          (actionsToday / maxActions) * 3; // Scale to match 4 stages
      _growInput!.value = growthStage;
    }
  }

  Future<void> _openCamera() async {
    final picker = ImagePicker();
    await picker.pickImage(source: ImageSource.camera);
    if (actionsToday < maxActions) {
      setState(() {
        actionsToday++;
        points += 10;
        _updateRiveAnimation();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double progress = actionsToday / maxActions;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          SizedBox(height: 50),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.green[50],
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 5,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Activity",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.green[700],
                          ),
                        ),
                        SizedBox(height: 10),
                        LinearPercentIndicator(
                          width: MediaQuery.of(context).size.width * 0.55,
                          lineHeight: 12.0,
                          percent: progress,
                          backgroundColor: Colors.grey[300]!,
                          progressColor: Colors.green,
                          barRadius: Radius.circular(10),
                        ),
                        SizedBox(height: 5),
                        Text(
                          "Points: $points",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.green[700],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 20),
                  Column(
                    children: [
                      Text(
                        "Today's Score",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.green[700],
                        ),
                      ),
                      Text(
                        "$actionsToday / $maxActions",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.green[800],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 30),
          Expanded(
            child: Center(
              child: _riveArtboard == null
                  ? CircularProgressIndicator()
                  : SizedBox(
                      width: 250,
                      height: 250,
                      child: Rive(artboard: _riveArtboard!),
                    ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        notchMargin: 8.0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: Icon(Icons.emoji_events),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ChallengesPage()),
                );
              },
            ),
            IconButton(
              icon: Icon(Icons.map),
              onPressed: () {},
            ),
            SizedBox(width: 48),
            IconButton(
              icon: Icon(Icons.message),
              onPressed: () {},
            ),
            IconButton(
              icon: Icon(Icons.person),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProfilePage()),
                );
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _openCamera,
        backgroundColor: Colors.green,
        child: Icon(Icons.camera_alt),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
