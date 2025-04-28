import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // For SystemNavigator.pop()
import 'workout.dart';
import 'timer.dart';

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
          // Background image.
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('lib/assets/background.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Buttons overlay.
          Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: buttonTitles.map((title) => MainMenuButton(title: title)).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class MainMenuButton extends StatelessWidget {
  final String title;

  const MainMenuButton({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                  title: const Text("MMATimer"),
                  content: const Text("Developed by Gerald Bejarano, v1"),
                  actions: [
                    ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text("Accept"),
                    ),
                  ],
                ),
              );
            } else if (title == "Exit") {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text("Exit"),
                  content: const Text("Are you sure you want to exit?"),
                  actions: [
                    ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text("Cancel"),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        SystemNavigator.pop();
                      },
                      child: const Text("Yes"),
                    ),
                  ],
                ),
              );
            } else if (title == "Timer") {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const TimerScreen(),
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
                    appBar: AppBar(title: const Text("Settings")),
                    body: const Center(
                      child: Text("Settings Screen"),
                    ),
                  ),
                ),
              );
            } else if (title == "Sparring") {
              // Add navigation for Sparring if needed.
            } else {
              print('$title button pressed');
            }
          },
          child: Text(title),
        ),
      ),
    );
  }
}
