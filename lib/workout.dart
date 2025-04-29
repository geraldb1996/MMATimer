import 'dart:async';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'global.dart';

class WorkoutScreen extends StatefulWidget {
  const WorkoutScreen({Key? key}) : super(key: key);

  @override
  _WorkoutScreenState createState() => _WorkoutScreenState();
}

class _WorkoutScreenState extends State<WorkoutScreen> {
  // Initialize controllers and fields with global values.
  late final TextEditingController roundsController;
  int roundMinutes = globalRoundMinutes;
  int roundSeconds = globalRoundSeconds;
  int restMinutes = globalRestMinutes;
  int restSeconds = globalRestSeconds;

  List<int> minutesSeconds = List.generate(60, (i) => i);

  @override
  void initState() {
    super.initState();
    roundsController =
        TextEditingController(text: globalNumberOfRounds.toString());
  }

  Widget buildNumberInput(String label, TextEditingController controller) {
    return Center(
      child: Container(
        width: 300, // Fixed width for centering
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.9),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(label),
            const SizedBox(width: 10),
            Expanded(
              child: TextField(
                controller: controller,
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
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

  Widget buildDropdown(String label, int value, List<int> items, ValueChanged<int?> onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Container(
        width: 300, // Fixed width for the dropdown field
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
                value: value,
                isExpanded: false,
                items: items.map((val) {
                  return DropdownMenuItem(
                    value: val,
                    // Center the dropdown menu item text.
                    child: Center(child: Text(val.toString())),
                  );
                }).toList(),
                onChanged: onChanged,
                underline: Container(
                  height: 1,
                  color: Colors.black,
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
  void dispose() {
    roundsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Workout Settings")),
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
                  buildDropdown("Round Minutes", roundMinutes, minutesSeconds,
                      (val) => setState(() => roundMinutes = val!)),
                  buildDropdown("Round Seconds", roundSeconds, minutesSeconds,
                      (val) => setState(() => roundSeconds = val!)),
                  buildDropdown("Rest Minutes", restMinutes, minutesSeconds,
                      (val) => setState(() => restMinutes = val!)),
                  buildDropdown("Rest Seconds", restSeconds, minutesSeconds,
                      (val) => setState(() => restSeconds = val!)),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      // Update global variables so that they persist next time.
                      globalNumberOfRounds = getRounds();
                      globalRoundMinutes = roundMinutes;
                      globalRoundSeconds = roundSeconds;
                      globalRestMinutes = restMinutes;
                      globalRestSeconds = restSeconds;

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CountdownScreen(
                            totalRounds: getRounds(),
                            roundMinutes: roundMinutes,
                            roundSeconds: roundSeconds,
                            restMinutes: restMinutes,
                            restSeconds: restSeconds,
                          ),
                        ),
                      );
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

// CountdownScreen remains the same.
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
  late AudioPlayer _audioPlayer;
  bool isPaused = false;

  int get roundTotalSeconds =>
      widget.roundMinutes * 60 + widget.roundSeconds;
  int get restTotalSeconds =>
      widget.restMinutes * 60 + widget.restSeconds;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    currentRound = 1;
    isRoundPhase = true;
    remainingSeconds = roundTotalSeconds;
    // Play bell at the start of the first round.
    playBell();
    startTimer();
  }

  void playBell() {
    _audioPlayer.play(AssetSource('lib/sounds/sndBell.wav'));
  }

  void playHorn() {
    _audioPlayer.play(AssetSource('lib/sounds/sndHorn.wav'));
  }

  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (Timer t) {
      setState(() {
        if (!isPaused) {
          if (remainingSeconds > 0) {
            remainingSeconds--;
          } else {
            if (isRoundPhase) {
              // End of round - play horn sound.
              playHorn();
              if (currentRound == widget.totalRounds) {
                timer?.cancel();
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text("Workout Finished"),
                    actions: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context)
                              .popUntil((route) => route.isFirst);
                        },
                        child: const Text("OK"),
                      ),
                    ],
                  ),
                );
              } else {
                if (restTotalSeconds > 0) {
                  // Switch to rest phase.
                  isRoundPhase = false;
                  remainingSeconds = restTotalSeconds;
                } else {
                  // No rest phase; immediately start next round.
                  currentRound++;
                  playBell();
                  isRoundPhase = true;
                  remainingSeconds = roundTotalSeconds;
                }
              }
            } else {
              // End of rest phase: start next round.
              currentRound++;
              playBell();
              isRoundPhase = true;
              remainingSeconds = roundTotalSeconds;
            }
          }
        }
      });
    });
  }

  void pauseTimer() {
    setState(() {
      isPaused = true;
    });
    timer?.cancel();
  }

  void resumeTimer() {
    setState(() {
      isPaused = false;
    });
    startTimer();
  }

  void stopTimer() {
    timer?.cancel();
    Navigator.pop(context);
  }

  @override
  void dispose() {
    timer?.cancel();
    _audioPlayer.dispose();
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
            Text(
              'Round $currentRound of ${widget.totalRounds}',
              style: const TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 20),
            Text(
              '$phaseText Phase',
              style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Text(
              formatTime(remainingSeconds),
              style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    if (isPaused) {
                      resumeTimer();
                    } else {
                      pauseTimer();
                    }
                  },
                  child: Text(isPaused ? 'Resume' : 'Pause'),
                ),
                const SizedBox(width: 20),
                ElevatedButton(
                  onPressed: stopTimer,
                  child: const Text("Stop"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}