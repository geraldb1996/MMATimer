import 'dart:async';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'global.dart';
import 'styles.dart';

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
    roundsController = TextEditingController(
      text: globalNumberOfRounds.toString(),
    );
  }

  Widget buildNumberInput(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        width: 300,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.95),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 6,
              offset: Offset(0, 2),
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: Text(label, style: TextStyle(fontWeight: FontWeight.w500)),
            ),
            const SizedBox(width: 10),
            Expanded(
              flex: 3,
              child: TextField(
                controller: controller,
                keyboardType: TextInputType.number,
                textAlign: TextAlign.right,
                decoration: const InputDecoration(
                  isCollapsed: true,
                  border: InputBorder.none,
                ),
                style: TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildDropdown(
    String label,
    int value,
    List<int> items,
    ValueChanged<int?> onChanged,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        width: 300,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.95),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 6,
              offset: Offset(0, 2),
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: Text(label, style: TextStyle(fontWeight: FontWeight.w500)),
            ),
            const SizedBox(width: 10),
            Expanded(
              flex: 3,
              child: DropdownButtonHideUnderline(
                child: DropdownButton<int>(
                  value: value,
                  isExpanded: true,
                  dropdownColor: Colors.white,
                  style: TextStyle(color: Colors.black, fontSize: 16),
                  borderRadius: BorderRadius.circular(10),
                  menuMaxHeight: 200,
                  items:
                      items.map((val) {
                        return DropdownMenuItem(
                          value: val,
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: Text(val.toString()),
                          ),
                        );
                      }).toList(),
                  onChanged: onChanged,
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
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: BoxDecoration(gradient: AppStyles.fondo),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Configuración del Entrenamiento',
                    style: AppStyles.titulo.copyWith(fontSize: 30),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),
                  Card(
                    elevation: 8,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                    color: Colors.white.withOpacity(0.97),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 22),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          _sectionHeader(Icons.fitness_center, 'Número de Rounds'),
                          buildNumberInput('Rounds', roundsController),
                          const Divider(height: 32, thickness: 1.2),
                          _sectionHeader(Icons.timer, 'Tiempo de Round'),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              buildTimeDropdown('Minutos', roundMinutes, (value) {
                                setState(() => roundMinutes = value ?? 0);
                              }),
                              buildTimeDropdown('Segundos', roundSeconds, (value) {
                                setState(() => roundSeconds = value ?? 0);
                              }),
                            ],
                          ),
                          const Divider(height: 32, thickness: 1.2),
                          _sectionHeader(Icons.hotel, 'Tiempo de Descanso'),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              buildTimeDropdown('Minutos', restMinutes, (value) {
                                setState(() => restMinutes = value ?? 0);
                              }),
                              buildTimeDropdown('Segundos', restSeconds, (value) {
                                setState(() => restSeconds = value ?? 0);
                              }),
                            ],
                          ),
                          const SizedBox(height: 36),
                          ElevatedButton.icon(
                            style: AppStyles.gymButton.copyWith(
                              minimumSize: MaterialStateProperty.all(const Size.fromHeight(54)),
                            ),
                            icon: const Icon(Icons.play_arrow, size: 28),
                            label: const Text('Comenzar Entrenamiento', style: TextStyle(fontSize: 20)),
                            onPressed: () {
                              int rounds = int.tryParse(roundsController.text) ?? 0;
                              if (rounds > 0 && (roundMinutes > 0 || roundSeconds > 0)) {
                                globalNumberOfRounds = rounds;
                                globalRoundMinutes = roundMinutes;
                                globalRoundSeconds = roundSeconds;
                                globalRestMinutes = restMinutes;
                                globalRestSeconds = restSeconds;

                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => CountdownScreen(
                                      totalRounds: rounds,
                                      roundMinutes: roundMinutes,
                                      roundSeconds: roundSeconds,
                                      restMinutes: restMinutes,
                                      restSeconds: restSeconds,
                                    ),
                                  ),
                                );
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _sectionHeader(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          Icon(icon, color: AppStyles.colorSecundario, size: 22),
          const SizedBox(width: 8),
          Text(text, style: AppStyles.subtitulo.copyWith(fontSize: 17)),
        ],
      ),
    );
  }

  Widget buildTimeDropdown(
    String label,
    int value,
    ValueChanged<int?> onChanged,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFd7263d)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 12)),
          DropdownButton<int>(
            value: value,
            items:
                minutesSeconds
                    .map(
                      (int value) => DropdownMenuItem<int>(
                        value: value,
                        child: Text(value.toString().padLeft(2, '0')),
                      ),
                    )
                    .toList(),
            onChanged: onChanged,
            underline: Container(),
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

  int get roundTotalSeconds => widget.roundMinutes * 60 + widget.roundSeconds;
  int get restTotalSeconds => widget.restMinutes * 60 + widget.restSeconds;

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
                  builder:
                      (context) => AlertDialog(
                        title: const Text("Workout Finished"),
                        actions: [
                          ElevatedButton(
                            onPressed: () {
                              Navigator.of(
                                context,
                              ).popUntil((route) => route.isFirst);
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
      // Use a light background color or your gradient
      backgroundColor: AppStyles.colorGrisClaro,
      appBar: AppBar(
        title: const Text("Countdown"),
        backgroundColor: AppStyles.colorPrimario,
        foregroundColor: AppStyles.colorGrisClaro,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppStyles.fondo, // Optional: use your gym gradient
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Round $currentRound of ${widget.totalRounds}',
                style: TextStyle(
                  fontSize: 24,
                  color: AppStyles.colorSecundario,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                '$phaseText Phase',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: AppStyles.colorSecundario,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                formatTime(remainingSeconds),
                style: TextStyle(
                  fontSize: 100,
                  fontWeight: FontWeight.bold,
                  color: AppStyles.colorGrisClaro,
                ),
              ),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    style: AppStyles.gymButton,
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
                    style: AppStyles.gymButton,
                    onPressed: stopTimer,
                    child: const Text("Stop"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
