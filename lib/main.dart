import 'package:flutter/material.dart';
import 'dart:async';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme:
            ColorScheme.fromSwatch(backgroundColor: const Color(0xFFE64D3D)),
        textTheme: const TextTheme(
          bodyLarge: TextStyle(
            color: Color(0xFFE64D3D),
          ),
          bodyMedium: TextStyle(
            color: Color(0xFFF4A59D),
          ),
        ),
        cardColor: Colors.white,
        primaryColorLight: const Color(0xFFF4A59D),
      ),
      home: const Pomodoro(),
    );
  }
}

class Pomodoro extends StatefulWidget {
  const Pomodoro({super.key});

  @override
  State<Pomodoro> createState() => _PomodoroState();
}

class _PomodoroState extends State<Pomodoro> {
  static const defalutFocusTime = 60;
  static const defalutRestTime = 60;
  static const focus = 'focus';
  static const rest = 'rest';
  int focusTime = defalutFocusTime;
  int restTime = defalutRestTime;
  bool isRunning = false;
  String current = focus;
  int round = 0;
  int goal = 0;
  late Timer focusTimer;
  late Timer restTimer;

  void _handleTimerOptionSelected(int minute) {
    setState(() {
      focusTime = minute * 60;
    });
  }

  void onTick(Timer timer) {
    if (focusTime == 0) {
      restTimer = Timer.periodic(const Duration(seconds: 1), onRest);
      focusTimer.cancel();
      setState(() {
        focusTime = defalutFocusTime;
        current = rest;
        round = round + 1;
      });
    } else {
      setState(() {
        focusTime = focusTime - 1;
      });
    }

    if (round == 4) {
      round = 0;
      goal = goal + 1;
    }
  }

  void onRest(Timer timer) {
    if (restTime == 0) {
      restTimer.cancel();
      setState(() {
        restTime = defalutRestTime;
        current = focus;
        isRunning = false;
      });
    } else {
      setState(() {
        restTime = restTime - 1;
      });
    }
  }

  void onStartTimer() {
    setState(() {
      if (current == focus) {
        focusTimer = Timer.periodic(const Duration(seconds: 1), onTick);
      }
      if (current == rest) {
        restTimer = Timer.periodic(const Duration(seconds: 1), onRest);
      }
      isRunning = true;
    });
  }

  void onPauseTimer() {
    if (focusTimer.isActive) {
      focusTimer.cancel();
    } else if (restTimer.isActive) {
      restTimer.cancel();
    }
    setState(() {
      isRunning = false;
    });
  }

  void onResetPressed() {
    if (isRunning && focusTimer.isActive) {
      focusTimer.cancel();
    } else if (isRunning && restTimer.isActive) {
      restTimer.cancel();
    }

    setState(() {
      isRunning = false;
      focusTime = defalutFocusTime;
      restTime = defalutRestTime;
      current = focus;
    });
  }

  List<String> format(int seconds) {
    var duration = Duration(seconds: seconds);
    return duration
        .toString()
        .split('.')
        .first
        .substring(2)
        .toString()
        .split(':');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(children: [
          Flexible(
            flex: 1,
            child: Container(
              alignment: Alignment.centerLeft,
              child: const Text(
                'POMOTIMER',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 20,
                  letterSpacing: 2,
                ),
              ),
            ),
          ),
          Flexible(
            flex: 4,
            child: Container(
                alignment: Alignment.bottomCenter,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 15,
                            vertical: 30,
                          ),
                          decoration: BoxDecoration(
                            color: Theme.of(context).cardColor,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            format(current == focus ? focusTime : restTime)
                                .first,
                            style: TextStyle(
                              color:
                                  Theme.of(context).textTheme.bodyLarge?.color,
                              fontWeight: FontWeight.w800,
                              backgroundColor: Theme.of(context).cardColor,
                              fontSize: 50,
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          ':',
                          style: TextStyle(
                            color:
                                Theme.of(context).textTheme.bodyMedium?.color,
                            fontSize: 50,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 15,
                            vertical: 30,
                          ),
                          decoration: BoxDecoration(
                            color: Theme.of(context).cardColor,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            format(current == focus ? focusTime : restTime)
                                .last,
                            style: TextStyle(
                              color:
                                  Theme.of(context).textTheme.bodyLarge?.color,
                              fontWeight: FontWeight.w800,
                              backgroundColor: Theme.of(context).cardColor,
                              fontSize: 50,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 40),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          TimerOption(
                            minute: 1,
                            onTimeSelected: _handleTimerOptionSelected,
                          ),
                          const SizedBox(width: 10),
                          TimerOption(
                            minute: 5,
                            onTimeSelected: _handleTimerOptionSelected,
                          ),
                          const SizedBox(width: 10),
                          TimerOption(
                            minute: 10,
                            onTimeSelected: _handleTimerOptionSelected,
                          ),
                          const SizedBox(width: 10),
                          TimerOption(
                            minute: 15,
                            onTimeSelected: _handleTimerOptionSelected,
                          ),
                          const SizedBox(width: 10),
                          TimerOption(
                            minute: 30,
                            onTimeSelected: _handleTimerOptionSelected,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 40),
                    IconButton(
                      onPressed: isRunning ? onPauseTimer : onStartTimer,
                      icon: Icon(
                          isRunning ? Icons.pause_circle : Icons.play_circle),
                      color: Theme.of(context).primaryColorLight,
                      iconSize: 100,
                    ),
                    IconButton(
                      onPressed: onResetPressed,
                      icon: const Icon(Icons.refresh),
                      color: Theme.of(context).primaryColorLight,
                      iconSize: 20,
                    ),
                  ],
                )),
          ),
          Flexible(
            flex: 1,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    Text(
                      '$round/4',
                      style: const TextStyle(
                        fontSize: 23,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'ROUND',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Text(
                      '$goal/12',
                      style: const TextStyle(
                        fontSize: 23,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'GOAL',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ]),
      ),
    );
  }
}

typedef TimeSelectedCallback = void Function(int minute);

class TimerOption extends StatelessWidget {
  final int minute;
  final TimeSelectedCallback onTimeSelected;

  const TimerOption({
    super.key,
    required this.minute,
    required this.onTimeSelected,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onTimeSelected(minute);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 8,
          vertical: 5,
        ),
        decoration: BoxDecoration(
          border: Border.all(
            color: Theme.of(context).primaryColorLight,
            width: 3.0,
          ),
          borderRadius: BorderRadius.circular(5),
        ),
        child: Text(
          '$minute',
          style: TextStyle(
            color: Theme.of(context).textTheme.bodyMedium?.color,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
