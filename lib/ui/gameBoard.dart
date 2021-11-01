import 'package:flutter/material.dart';
import 'package:game_2048/ui/tile.dart';
import 'package:provider/provider.dart';
import 'package:game_2048/gameState/gameState.dart';

class GameBoard extends StatelessWidget {
  const GameBoard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<GameState>(
      builder: (BuildContext context, GameState state, _) {
        return Padding(
          padding: const EdgeInsets.only(top: 250),
          child: BoardAnimator(state: state),
        );
      },
    );
  }
}

class BoardAnimator extends StatefulWidget {
  final GameState state;
  const BoardAnimator({
    Key? key,
    required this.state,
  }) : super(key: key);

  @override
  _BoardAnimatorState createState() => _BoardAnimatorState();
}

class _BoardAnimatorState extends State<BoardAnimator>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onVerticalDragEnd: (details) {
            if (details.primaryVelocity != null) {
              Move move = Move.up;
              if (details.primaryVelocity! > 0) {
                move = Move.down;
              }
              widget.state.handleMovement(move);
            }
          },
          onHorizontalDragEnd: (details) {
            if (details.primaryVelocity != null) {
              Move move = Move.left;
              if (details.primaryVelocity! > 0) {
                move = Move.right;
              }
              widget.state.handleMovement(move);
            }
          },
          child: BoardWidget(
            state: widget.state,
          ),
        ),
      ],
    );
  }
}

class BoardWidget extends StatelessWidget {
  final GameState state;
  const BoardWidget({Key? key, required this.state}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Container(
        width: state.width * (GameState.tileSize + 1),
        height: state.height * (GameState.tileSize + 1),
        alignment: Alignment.center,
        decoration: BoxDecoration(border: Border.all(width: 2)),
        child: BoardBuilder(
            width: state.width, height: state.height, board: state.board),
      ),
      IconButton(onPressed: () => state.reset(), icon: Icon(Icons.restore)),
    ]);
  }
}

class BoardBuilder extends StatelessWidget {
  final int width;
  final int height;
  final Board board;
  final Move? move;
  const BoardBuilder({
    Key? key,
    required this.width,
    required this.height,
    required this.board,
    this.move,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(
          height,
          (h) => Row(
                  children: List.generate(width, (w) {
                final number = board[h][w];
                return number == 0
                    ? Container(
                        width: 50,
                        height: 50,
                        color: Colors.red,
                      )
                    : Tile(
                        number: number.number,
                      );
              }))),
    );
  }
}













/*

[[0, 0, 0, 2], [0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0]]



*/