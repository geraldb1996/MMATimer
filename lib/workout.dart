import 'dart:async';
import 'package:flutter/material.dart';
import 'global.dart';

class WorkoutScreen extends StatefulWidget {
  const WorkoutScreen({super.key});

  @override
  State<WorkoutScreen> createState() => _WorkoutScreenState();
}

class _WorkoutScreenState extends State<WorkoutScreen> {
  final roundsController = TextEditingController(text: globalNumberOfRounds.toString());
  int roundMinutes = globalRoundMinutes;
  int roundSeconds = globalRoundSeconds;
  int restMinutes = globalRestMinutes;
  int restSeconds = globalRestSeconds;

  List<int> minutesSeconds = List.generate(60, (i) => i); // 0-59

  @override
  void dispose() {
    roundsController.dispose();
    super.dispose();
  }

  Widget buildDropdown(String label, int value, List<int> items, ValueChanged<int?> onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.9),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Row(
          children: [
            Expanded(flex: 2, child: Text(label)),
            const SizedBox(width: 10),
            Expanded(
              flex: 3,
              child: DropdownButton<int>(
                isExpanded: true,
                value: value,
                items: items.map((val) => DropdownMenuItem(
                  value: val,
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Text(val.toString()),
                  ),
                )).toList(),
                onChanged: onChanged,
                underline: const SizedBox(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildNumberInput(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.9),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Row(
          children: [
            Expanded(flex: 2, child: Text(label)),
            const SizedBox(width: 10),
            Expanded(
              flex: 3,
              child: TextField(
                controller: controller,
                keyboardType: TextInputType.number,
                textAlign: TextAlign.right,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                ),
              ),
            ),
          ],
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
          Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView(
                shrinkWrap: true,
                children: [
                  buildNumberInput("Number of Rounds", roundsController),
                  buildDropdown("Round Minutes", roundMinutes, minutesSeconds, (val) => setState(() => roundMinutes = val!)),
                  buildDropdown("Round Seconds", roundSeconds, minutesSeconds, (val) => setState(() => roundSeconds = val!)),
                  buildDropdown("Rest Minutes", restMinutes, minutesSeconds, (val) => setState(() => restMinutes = val!)),
                  buildDropdown("Rest Seconds", restSeconds, minutesSeconds, (val) => setState(() => restSeconds = val!)),
                  const SizedBox(height: 50),
                  ElevatedButton(
                    onPressed: () {
                      // Update global variables with current selections
                      globalNumberOfRounds = getRounds();
                      globalRoundMinutes = roundMinutes;
                      globalRoundSeconds = roundSeconds;
                      globalRestMinutes = restMinutes;
                      globalRestSeconds = restSeconds;
    
                      Navigator.push(context, MaterialPageRoute(
                        builder: (context) => CountdownScreen(
                          totalRounds: globalNumberOfRounds,
                          roundMinutes: globalRoundMinutes,
                          roundSeconds: globalRoundSeconds,
                          restMinutes: globalRestMinutes,
                          restSeconds: globalRestSeconds,
                        ),
                      ));
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

class CountdownScreen extends StatefulWidget {
  final int totalRounds;
  final int roundMinutes;
  final int roundSeconds;
  final int restMinutes;
  final int restSeconds;

  const CountdownScreen({
    Key? key,
    required this.totalRounds,
    required this.roundMinutes,
    required this.roundSeconds,
    required this.restMinutes,
    required this.restSeconds,
  }) : super(key: key);

  @override
  _CountdownScreenState createState() => _CountdownScreenState();
}

class _CountdownScreenState extends State<CountdownScreen> {
  late int currentRound;
  late bool isRoundPhase;
  late int remainingSeconds;
  Timer? timer;

  int get roundTotalSeconds => widget.roundMinutes * 60 + widget.roundSeconds;
  int get restTotalSeconds => widget.restMinutes * 60 + widget.restSeconds;

  @override
  void initState() {
    super.initState();
    currentRound = 1;
    isRoundPhase = true;
    remainingSeconds = roundTotalSeconds;
    startTimer();
  }

  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (Timer t) {
      setState(() {
        if (remainingSeconds > 0) {
          remainingSeconds--;
        } else {
          if (isRoundPhase) {
            if (currentRound == widget.totalRounds) {
              timer?.cancel();
              showDialog(
                context: context,
                builder: (_) => AlertDialog(
                  title: const Text("Workout Finished"),
                  actions: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).popUntil((route) => route.isFirst);
                      },
                      child: const Text("OK"),
                    ),
                  ],
                ),
              );
            } else {
              if (restTotalSeconds > 0) {
                isRoundPhase = false;
                remainingSeconds = restTotalSeconds;
              } else {
                currentRound++;
                isRoundPhase = true;
                remainingSeconds = roundTotalSeconds;
              }
            }
          } else {
            currentRound++;
            isRoundPhase = true;
            remainingSeconds = roundTotalSeconds;
          }
        }
      });
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  String formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final secs = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final phaseText = isRoundPhase ? 'Round' : 'Rest';
    return Scaffold(
      appBar: AppBar(title: const Text("Countdown")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Round $currentRound of ${widget.totalRounds}', style: const TextStyle(fontSize: 24)),
            const SizedBox(height: 20),
            Text('$phaseText Phase', style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            Text(formatTime(remainingSeconds), style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}
