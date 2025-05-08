import 'dart:async';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'global.dart';
import 'styles.dart';

class SparringScreen extends StatefulWidget {
  const SparringScreen({Key? key}) : super(key: key);

  @override
  _SparringScreenState createState() => _SparringScreenState();
}

class _SparringScreenState extends State<SparringScreen> {
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

  Widget buildTimeDropdown(
    String label,
    int value,
    ValueChanged<int?> onChanged,
  ) {
    return Expanded(
      child: buildDropdown(label, value, minutesSeconds, onChanged),
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
                    'Configuración del Sparring',
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
                      padding: const EdgeInsets.symmetric(
                        vertical: 28,
                        horizontal: 22,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          _sectionHeader(Icons.sports_mma, 'Número de Rounds'),
                          buildNumberInput('Rounds', roundsController),
                          const Divider(height: 32, thickness: 1.2),
                          _sectionHeader(Icons.timer, 'Tiempo de Round'),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              buildTimeDropdown('Min', roundMinutes, (value) {
                                setState(() => roundMinutes = value ?? 0);
                              }),
                              buildTimeDropdown('Sec', roundSeconds, (value) {
                                setState(() => roundSeconds = value ?? 0);
                              }),
                            ],
                          ),
                          const Divider(height: 32, thickness: 1.2),
                          _sectionHeader(Icons.hotel, 'Tiempo de Descanso'),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              buildTimeDropdown('Min', restMinutes, (value) {
                                setState(() => restMinutes = value ?? 0);
                              }),
                              buildTimeDropdown('Sec', restSeconds, (value) {
                                setState(() => restSeconds = value ?? 0);
                              }),
                            ],
                          ),
                          const SizedBox(height: 36),
                          ElevatedButton.icon(
                            style: AppStyles.gymButton.copyWith(
                              minimumSize: MaterialStateProperty.all(
                                const Size.fromHeight(54),
                              ),
                            ),
                            icon: const Icon(Icons.play_arrow, size: 28),
                            label: const Text(
                              'Empezar',
                              style: TextStyle(fontSize: 20),
                            ),
                            onPressed: () {
                              int rounds =
                                  int.tryParse(roundsController.text) ?? 0;
                              if (rounds > 0 &&
                                  (roundMinutes > 0 || roundSeconds > 0)) {
                                globalNumberOfRounds = rounds;
                                globalRoundMinutes = roundMinutes;
                                globalRoundSeconds = roundSeconds;
                                globalRestMinutes = restMinutes;
                                globalRestSeconds = restSeconds;
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (context) => CountdownScreen(
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
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Icon(icon, color: AppStyles.colorSecundario),
          const SizedBox(width: 8),
          Text(
            text,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
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
  late AudioPlayer _audioPlayer;
  bool isPaused = false;

  // Variables para almacenar la calificación del round
  String? winner;
  List<String> fouls = [];

  // Lista de posibles faltas
  final List<String> possibleFouls = [
    'Golpe bajo',
    'Dedos en los ojos',
    'Cabezazo',
    'Golpe en la espalda',
    'Golpe con la rodilla',
    'Patear al oponente en el suelo',
  ];

  // Método para mostrar el diálogo de calificación
  Future<void> showRoundRatingDialog(BuildContext context) async {
    String? selectedWinner;
    List<String> selectedFouls = [];

    await showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (context) => AlertDialog(
            title: Text('Calificación del Round ${currentRound}'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Selección del ganador
                  DropdownButton<String>(
                    value: selectedWinner,
                    hint: const Text('¿Quién ganó el round?'),
                    items: const [
                      DropdownMenuItem(value: 'Rojo', child: Text('Rojo')),
                      DropdownMenuItem(value: 'Azul', child: Text('Azul')),
                      DropdownMenuItem(value: 'Empate', child: Text('Empate')),
                    ],
                    onChanged: (value) {
                      setState(() {
                        selectedWinner = value;
                      });
                    },
                  ),
                  const SizedBox(height: 20),
                  // Selección de faltas
                  Column(
                    children:
                        possibleFouls
                            .map(
                              (foul) => CheckboxListTile(
                                title: Text(foul),
                                value: selectedFouls.contains(foul),
                                onChanged: (bool? value) {
                                  setState(() {
                                    if (value == true) {
                                      selectedFouls.add(foul);
                                    } else {
                                      selectedFouls.remove(foul);
                                    }
                                  });
                                },
                              ),
                            )
                            .toList(),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancelar'),
              ),
              ElevatedButton(
                onPressed: () {
                  // Guardar la calificación
                  setState(() {
                    winner = selectedWinner;
                    fouls = selectedFouls;
                    // Mostrar en consola la calificación
                    print('Round ${currentRound} - Winner: $winner');
                    if (fouls.isNotEmpty) {
                      print('Fouls: ${fouls.join(', ')}');
                    }
                  });
                  Navigator.pop(context);
                },
                child: const Text('Guardar'),
              ),
            ],
          ),
    );
  }

  int get roundTotalSeconds => widget.roundMinutes * 60 + widget.roundSeconds;
  int get restTotalSeconds => widget.restMinutes * 60 + widget.restSeconds;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    currentRound = 1;
    isRoundPhase = true;
    remainingSeconds = roundTotalSeconds;
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
              // End of round - play horn sound
              playHorn();

              // Mostrar diálogo de calificación después de cada round
              if (currentRound == widget.totalRounds) {
                // Si es el último round, mostrar el diálogo y terminar
                timer?.cancel();

                // Pausar el temporizador
                isPaused = true;

                // Mostrar diálogo de fin de sparring
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder:
                      (context) => AlertDialog(
                        title: const Text("Sparring Finished"),
                        actions: [
                          ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                              Navigator.of(
                                context,
                              ).popUntil((route) => route.isFirst);
                            },
                            child: const Text("OK"),
                          ),
                        ],
                      ),
                ).then((_) {
                  // Reanudar el temporizador cuando se cierre el diálogo
                  isPaused = false;
                });
              } else {
                // Si no es el último round, mostrar el diálogo y continuar
                // Pausar el temporizador mientras se muestra el diálogo
                isPaused = true;

                // Mostrar diálogo de calificación
                showRoundRatingDialog(context).then((_) {
                  // Reanudar el temporizador y continuar con el descanso
                  isPaused = false;
                  isRoundPhase = false;
                  remainingSeconds = restTotalSeconds;
                });
              }
            } else {
              // End of rest phase: start next round
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
      backgroundColor: AppStyles.colorGrisClaro,
      appBar: AppBar(
        title: const Text("Sparring Countdown"),
        backgroundColor: AppStyles.colorPrimario,
        foregroundColor: AppStyles.colorGrisClaro,
      ),
      body: Container(
        decoration: const BoxDecoration(gradient: AppStyles.fondo),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Round $currentRound of ${widget.totalRounds}',
                style: const TextStyle(
                  fontSize: 24,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              Text(
                phaseText,
                style: const TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Text(
                formatTime(remainingSeconds),
                style: const TextStyle(
                  fontSize: 100,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton.icon(
                    style: AppStyles.gymButton.copyWith(
                      minimumSize: MaterialStateProperty.all(
                        const Size(120, 54),
                      ),
                    ),
                    icon: Icon(
                      isPaused ? Icons.play_arrow : Icons.pause,
                      size: 28,
                    ),
                    label: Text(
                      isPaused ? 'Reanudar' : 'Pausar',
                      style: const TextStyle(fontSize: 20),
                    ),
                    onPressed: isPaused ? resumeTimer : pauseTimer,
                  ),
                  const SizedBox(width: 20),
                  ElevatedButton.icon(
                    style: AppStyles.gymButton.copyWith(
                      minimumSize: MaterialStateProperty.all(
                        const Size(120, 54),
                      ),
                    ),
                    icon: const Icon(Icons.stop, size: 28),
                    label: const Text(
                      'Detener',
                      style: TextStyle(fontSize: 20),
                    ),
                    onPressed: stopTimer,
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
