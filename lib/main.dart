import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // For SystemNavigator.pop()
import 'workout.dart';
import 'timer.dart';
import 'styles.dart';
import 'sparring.dart';

void main() {
  runApp(const MMATimerApp());
}

class MMATimerApp extends StatelessWidget {
  const MMATimerApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MMA Timer',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: AppStyles.colorPrimario,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppStyles.colorPrimario,
          primary: AppStyles.colorPrimario,
          secondary: const Color.fromARGB(255, 0, 0, 0),
          background: AppStyles.colorPrimario,
          surface: AppStyles.colorGrisClaro,
          onPrimary: AppStyles.colorGrisClaro,
          onSecondary: AppStyles.colorPrimario,
          onBackground: AppStyles.colorGrisClaro,
          onSurface: AppStyles.colorPrimario,
        ),
        scaffoldBackgroundColor: AppStyles.colorPrimario,
        textTheme: TextTheme(
          headlineLarge: AppStyles.titulo,
          titleLarge: AppStyles.subtitulo,
        ),
      ),
      home: const MainScreen(),
    );
  }
}

class MainScreen extends StatelessWidget {
  const MainScreen({Key? key}) : super(key: key);

  final List<Map<String, String>> menuItems = const [
    {"title": "Sparring", "icon": "🥊"},
    {"title": "Timer", "icon": "⏱️"},
    {"title": "Workout", "icon": "💪"},
    {"title": "Settings", "icon": "⚙️"},
    {"title": "Info", "icon": "ℹ️"},
    {"title": "Exit", "icon": "❌"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: AppStyles.fondo),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(
                  'MMA Timer',
                  style: AppStyles.titulo,
                  textAlign: TextAlign.center,
                ),
              ),
              Expanded(
                child: Center(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children:
                          menuItems
                              .map(
                                (item) => MainMenuButton(
                                  title: item['title']!,
                                  icon: item['icon']!,
                                ),
                              )
                              .toList(),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MainMenuButton extends StatelessWidget {
  final String title;
  final String icon;

  const MainMenuButton({Key? key, required this.title, required this.icon})
    : super(key: key);

  void _handleNavigation(BuildContext context) {
    switch (title) {
      case "Sparring":
        showDialog(
          context: context,
          builder:
              (context) => AlertDialog(
                title: const Text("Sparring"),
                content: const Text("This is screen is under construction"),
                actions: [
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text("Accept"),
                  ),
                ],
              ),
        );
        break;
      case "Timer":
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const TimerScreen()),
        );
        break;
      case "Workout":
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const WorkoutScreen()),
        );
        break;
      case "Settings":
        showDialog(
          context: context,
          builder:
              (context) => AlertDialog(
                title: const Text("Settings"),
                content: const Text("This is screen is under construction"),
                actions: [
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text("Accept"),
                  ),
                ],
              ),
        );
        break;
      case "Info":
        showDialog(
          context: context,
          builder:
              (context) => AlertDialog(
                title: const Text("MMATimer"),
                content: const Text("Gerald Bejarano, MMATimer beta 0.1.0"),
                actions: [
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text("Accept"),
                  ),
                ],
              ),
        );
        break;
      case "Exit":
        SystemNavigator.pop();
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 20.0),
      child: Container(
        decoration: AppStyles.tarjeta,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => _handleNavigation(context),
            borderRadius: BorderRadius.circular(20),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Text(icon, style: const TextStyle(fontSize: 24)),
                      const SizedBox(width: 16),
                      Text(title, style: AppStyles.subtitulo),
                    ],
                  ),
                  Icon(
                    Icons.arrow_forward_ios,
                    color: AppStyles.colorSecundario,
                    size: 20,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
