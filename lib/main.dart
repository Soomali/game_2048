import 'dart:math';

import 'package:flutter/material.dart';
import 'package:game_2048/ui/gamer.dart';
import 'package:game_2048/ui/tile.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        body: Center(
          child: Game(),
        ),
      ),
    );
  }
}
