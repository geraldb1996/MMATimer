import 'dart:async';
import 'package:flutter/material.dart';
import 'styles.dart';

class TimerScreen extends StatefulWidget {
  const TimerScreen({Key? key}) : super(key: key);

  @override
  _TimerScreenState createState() => _TimerScreenState();
}

class _TimerScreenState extends State<TimerScreen> {
  Timer? timer;
  int elapsedSeconds = 0;
  bool isRunning = false;

  void startTimer() {
    if (isRunning) return;
    isRunning = true;
    timer = Timer.periodic(const Duration(seconds: 1), (Timer t) {
      setState(() {
        elapsedSeconds++;
      });
    });
  }

  void pauseTimer() {
    if (!isRunning) return;
    timer?.cancel();
    setState(() {
      isRunning = false;
    });
  }

  void resetTimer() {
    timer?.cancel();
    setState(() {
      elapsedSeconds = 0;
      isRunning = false;
    });
  }

  String formatTime(int seconds) {
    final hours = seconds ~/ 3600;
    final minutes = (seconds % 3600) ~/ 60;
    final secs = seconds % 60;
    if (hours > 0) {
      return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
    }
    return '${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: BoxDecoration(gradient: AppStyles.fondo),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 32.0, bottom: 16.0),
                child: Text(
                  'Cronómetro',
                  style: AppStyles.titulo.copyWith(fontSize: 32),
                  textAlign: TextAlign.center,
                ),
              ),
              Expanded(
                child: Center(
                  child: Card(
                    elevation: 10,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                    color: Colors.white.withOpacity(0.97),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 36),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            formatTime(elapsedSeconds),
                            style: TextStyle(
                              fontSize: 72,
                              fontWeight: FontWeight.bold,
                              color: AppStyles.colorSecundario,
                              letterSpacing: 2,
                            ),
                          ),
                          const SizedBox(height: 36),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              _buildTimerButton(
                                onPressed: isRunning ? null : startTimer,
                                icon: Icons.play_arrow,
                                label: 'Iniciar',
                              ),
                              _buildTimerButton(
                                onPressed: isRunning ? pauseTimer : null,
                                icon: Icons.pause,
                                label: 'Pausar',
                              ),
                              _buildTimerButton(
                                onPressed: elapsedSeconds > 0 ? resetTimer : null,
                                icon: Icons.refresh,
                                label: 'Reiniciar',
                              ),
                            ],
                          ),
                        ],
                      ),
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

  Widget _buildTimerButton({
    required VoidCallback? onPressed,
    required IconData icon,
    required String label,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ElevatedButton(
          style: AppStyles.gymButton.copyWith(
            backgroundColor: MaterialStateProperty.resolveWith<Color>(
              (Set<MaterialState> states) {
                if (states.contains(MaterialState.disabled)) {
                  return Colors.grey.shade400;
                }
                return AppStyles.colorSecundario;
              },
            ),
            foregroundColor: MaterialStateProperty.all(AppStyles.colorPrimario),
            padding: MaterialStateProperty.all(const EdgeInsets.all(18)),
          ),
          onPressed: onPressed,
          child: Icon(icon, size: 28),
        ),
        const SizedBox(height: 8),
        Text(label, style: AppStyles.subtitulo.copyWith(fontSize: 15)),
      ],
    );
  }
}
