import 'package:flutter/material.dart';
import 'package:game_2048/gameState/tileData.dart';
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
            width: state.width, height: state.height, state: state),
      ),
      IconButton(onPressed: () => state.reset(), icon: Icon(Icons.restore)),
    ]);
  }
}

class BoardBuilder extends StatelessWidget {
  final int width;
  final int height;
  final GameState state;
  final Move? move;
  const BoardBuilder({
    Key? key,
    required this.width,
    required this.height,
    required this.state,
    this.move,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    state.printBoard();
    final _childrenData = _createChildren(state.width, state.height);
    return Container(
        color: Colors.red,
        child: Stack(
            children: _childrenData
                .map((e) => e.number == 0
                    ? Container()
                    : TweenAnimationBuilder<double>(
                        tween: Tween(begin: 0, end: 15),
                        duration: Duration(milliseconds: 150),
                        child: Tile(
                          number: e.number,
                        ),
                        builder: (context, pos, child) {
                          e.performMove();
                          return AnimatedPositioned(
                              left: pos < 1 ? e.start.dx : e.end.dx,
                              top: pos < 1 ? e.start.dy : e.end.dy,
                              child: child!,
                              duration: Duration(milliseconds: 50));
                        },
                      ))
                .toList()));
  }

  List<TileData> _createChildren(int width, int height) {
    final data = _boardAsOneDim();
    var c = 0;
    for (var i = 0; i < data.length; i++) {
      final e = data[i];
      if (e.number != 0) {
        c++;
      }
      final h = i ~/ width;
      final w = i % width;
      final begin = Offset(
          w.toDouble() * GameState.tileSize, h.toDouble() * GameState.tileSize);
      final end = begin + e.movedOffset;
      e.end = end;
      e.start = begin;
    }
    print('we have $c non zero tiles.');
    return data;
  }

  List<TileData> _boardAsOneDim() {
    final res = <TileData>[];
    for (var i in state.board) {
      res.addAll(i);
    }
    return res;
  }
}













/*

[[0, 0, 0, 2], [0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0]]



*/