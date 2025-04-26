import 'package:flutter/material.dart';

class WorkoutScreen extends StatefulWidget {
  const WorkoutScreen({super.key});

  @override
  State<WorkoutScreen> createState() => _WorkoutScreenState();
}

class _WorkoutScreenState extends State<WorkoutScreen> {
  final roundsController = TextEditingController(text: '1');
  int roundMinutes = 0;
  int roundSeconds = 0;
  int restMinutes = 0;
  int restSeconds = 0;

  List<int> minutesSeconds = List.generate(60, (i) => i); // 0-59

  @override
  void dispose() {
    roundsController.dispose();
    super.dispose();
  }

  Widget buildDropdown(String label, int value, List<int> items, ValueChanged<int?> onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        children: [
          Expanded(flex: 2, child: Text(label)),
          const SizedBox(width: 10),
          Expanded(
            flex: 3,
            child: DropdownButton<int>(
              isExpanded: true,
              value: value,
              items: items
                  .map((val) => DropdownMenuItem(
                        value: val,
                        child: Text(val.toString()),
                      ))
                  .toList(),
              onChanged: onChanged,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildNumberInput(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }

  int getRounds() {
    final value = int.tryParse(roundsController.text) ?? 1;
    return value < 1 ? 1 : value;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Workout")),
      body: Stack(
        children: [
          // Background image
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('lib/assets/workout.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Center( // Center the content horizontally and vertically
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView(
                shrinkWrap: true, // Ensures the ListView takes minimum space
                children: [
                  buildNumberInput("Rounds", roundsController),
                  buildDropdown("Round Minutes", roundMinutes, minutesSeconds, (val) => setState(() => roundMinutes = val!)),
                  buildDropdown("Round Seconds", roundSeconds, minutesSeconds, (val) => setState(() => roundSeconds = val!)),
                  buildDropdown("Rest Minutes", restMinutes, minutesSeconds, (val) => setState(() => restMinutes = val!)),
                  buildDropdown("Rest Seconds", restSeconds, minutesSeconds, (val) => setState(() => restSeconds = val!)),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      final rounds = getRounds();
                      print("Rounds: $rounds");
                      print("Round: $roundMinutes min $roundSeconds sec");
                      print("Rest: $restMinutes min $restSeconds sec");
                    },
                    child: const Text("Start"),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
