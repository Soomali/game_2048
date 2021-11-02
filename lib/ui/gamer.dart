import 'package:flutter/material.dart';
import 'package:game_2048/gameState/gameState.dart';
import 'package:game_2048/ui/gameBoard.dart';
import 'package:provider/provider.dart';

class Game extends StatelessWidget {
  const Game({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<GameState>(
      create: (_) => GameState.createSet(4, 4, [
        [8, 4, 4, 0],
        [64, 2, 4, 4],
        [8, 32, 16, 8],
        [256, 8, 4, 8]
      ]),
      child: GameBoard(),
    );
  }
}

/*


    [[32, 256, 16, 4], [16, 8, 4, 0], [8, 4, 2, 0], [4, 0, 2, 0]]



    
    [[32, 256, 2, 4], [16, 8, 4, 0], [8, 4, 2, 0], [4, 0, 0, 0]]



 */