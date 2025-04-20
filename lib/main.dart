import 'package:flutter/material.dart';
import 'dart:async';

void main() {
  runApp(const MMATimerApp());
}

class MMATimerApp extends StatelessWidget {
  const MMATimerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MMA Timer',
      theme: ThemeData.dark(),
      home: const TimerPage(),
    );
  }
}

class TimerPage extends StatefulWidget {
  const TimerPage({super.key});

  @override
  State<TimerPage> createState() => _TimerPageState();
}

class _TimerPageState extends State<TimerPage> {
  int _seconds = 0;
  int _round = 1;
  final int _roundLength = 5 * 60; // 5 minutos por round
  final int _maxRounds = 3;

  Timer? _timer;
  bool _isRunning = false;

  void _toggleTimer() {
    if (_isRunning) {
      _timer?.cancel();
    } else {
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        setState(() {
          _seconds++;
          if (_seconds >= _roundLength) {
            _seconds = 0;
            _round++;
            if (_round > _maxRounds) {
              _timer?.cancel();
              _isRunning = false;
              _round = 1;
            }
          }
        });
      });
    }
    setState(() {
      _isRunning = !_isRunning;
    });
  }

  void _resetTimer() {
    _timer?.cancel();
    setState(() {
      _seconds = 0;
      _round = 1;
      _isRunning = false;
    });
  }

  String _formatTime(int totalSeconds) {
    final minutes = (totalSeconds ~/ 60).toString().padLeft(2, '0');
    final seconds = (totalSeconds % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('MMA Timer')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Round $_round / $_maxRounds',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 20),
            Text(
              _formatTime(_roundLength - _seconds),
              style: Theme.of(context).textTheme.displayLarge,
            ),
            const SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: _toggleTimer,
                  child: Text(_isRunning ? 'Pausar' : 'Iniciar'),
                ),
                const SizedBox(width: 20),
                ElevatedButton(
                  onPressed: _resetTimer,
                  child: const Text('Reiniciar'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
