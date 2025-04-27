import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // <-- Add this import
import 'workout.dart';

void main() {
  runApp(MMATimerApp());
}

class MMATimerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MMA Timer',
      home: MainScreen(),
    );
  }
}

class MainScreen extends StatelessWidget {
  final List<String> buttonTitles = [
    "Sparring",
    "Timer",
    "Workout",
    "Settings",
    "Info",
    "Exit"
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background image
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('lib/assets/background.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Buttons overlay
          Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: buttonTitles.map((title) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: SizedBox(
                      width: 200,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {
                          if (title == "Info") {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: Text("MMATimer"),
                                content: Text("Developed by Gerald Bejarano, v1"),
                                actions: [
                                  ElevatedButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: Text("Accept"),
                                  ),
                                ],
                              ),
                            );
                          } else if (title == "Exit") {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: Text("Exit"),
                                content: Text("Are you sure you want to exit?"),
                                actions: [
                                  ElevatedButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: Text("Cancel"),
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      SystemNavigator.pop();
                                    },
                                    child: Text("Yes"),
                                  ),
                                ],
                              ),
                            );
                          } else if (title == "Workout") {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const WorkoutScreen(),
                              ),
                            );
                          } else if (title == "Settings") {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Scaffold(
                                  appBar: AppBar(title: Text("Settings")),
                                  body: Center(child: Text("Settings Screen")),
                                ),
                              ),
                            );
                          } else {
                            print('$title button pressed');
                          }
                        },
                        child: Text(title),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}