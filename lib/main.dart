import 'package:flutter/material.dart';
import 'package:tt_bytepace/src/app.dart';
import 'package:tt_bytepace/src/theme/light_mode.dart';


void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: lightMode,
      home: const App()
    );
  }
}
