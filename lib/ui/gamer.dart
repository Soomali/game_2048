import 'package:flutter/material.dart';
import 'package:game_2048/gameState/gameState.dart';
import 'package:game_2048/ui/gameBoard.dart';
import 'package:provider/provider.dart';

class Game extends StatelessWidget {
  const Game({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<GameState>(
      create: (_) => GameState(width: 8, height: 5),
      child: GameBoard(),
    );
  }
}
