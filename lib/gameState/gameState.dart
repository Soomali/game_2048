import 'dart:math' show Random;

import 'package:flutter/material.dart';
import 'package:game_2048/gameState/tileData.dart';

enum Move {
  right,
  left,
  up,
  down,
}

Move getReverseMove(Move move) {
  switch (move) {
    case Move.right:
      return Move.left;
    case Move.left:
      return Move.right;
    case Move.up:
      return Move.down;
    case Move.down:
      return Move.up;
  }
}

typedef Board = List<List<TileData>>;
enum GameCondition { lost, won, ongoing }

class GameState with ChangeNotifier {
  static const double tileSize = 50;
  late final Board board;
  late Board boardBefore;
  Move? lastMove;
  final int height;
  final int width;
  bool inProgress = false;
  GameCondition condition = GameCondition.ongoing;
  GameState({required this.width, required this.height})
      : board = List.generate(height,
            (_) => List.generate(width, (_) => TileData(0), growable: false),
            growable: false) {
    _setRandomStart();
    print(board);
  }
  void reset() {
    for (var i = 0; i < height; i++) {
      for (var j = 0; j < width; j++) {
        board[i][j] = TileData(0);
      }
    }
    _setRandomStart();
    condition = GameCondition.ongoing;
    notifyListeners();
    print(board);
  }

  void _setRandomStart() {
    final randomw = Random().nextInt(width);
    final randomh = Random().nextInt(height);
    board[randomh][randomw] = TileData(2);
    boardBefore = List.from(board);
  }

  GameState.createTest(this.width, this.height) {
    board = List.generate(
        height,
        (mindex) =>
            List.generate(width, (index) => TileData(index == mindex ? 2 : 0)));
  }

  GameState.createSet(this.width, this.height, List<List<int>> values) {
    values.forEach((element) {
      assert(element.length == width);
    });
    board = values.map((e) => e.map((f) => TileData(f)).toList()).toList();
  }

  /// handles the movement then
  /// determines whether the game is won,lost or ongoing by updating the [condition],
  /// if the game [condition] is ongoing replaces a zero with a 2 or 4 randomly.
  /// notifies all the listeners after these events.
  void handleMovement(Move move, {bool debug = false}) {
    if (!debug && inProgress) return;
    boardBefore = List.from(board);
    switch (move) {
      case Move.right:
        // if (!canMoveRight) return;
        _moveRight();
        break;
      case Move.left:
        // if (!canMoveLeft) return;
        _moveLeft();
        break;
      case Move.up:
        // if (!canMoveUp) return;
        _moveUp();
        break;
      case Move.down:
        // if (!canMoveDown) return;
        _moveDown();
        break;
    }
    lastMove = move;
    if (!debug) {
      _updateState();
      if (condition == GameCondition.ongoing) {
        _addRandomNumber();
      }

      notifyListeners();
    }
  }

  void _moveRight() {
    for (var i = height - 1; i >= 0; i--) {
      for (var j = width - 1; j > 0; j--) {
        final current = board[i][j];
        var next = board[i][j - 1];
        if (current.number == 0) {
          int? lim;
          for (var k = j; k >= 0; k--) {
            next = board[i][k];
            if (next.number != 0) {
              lim = k;
              break;
            }
          }
          if (lim != null) {
            board[i][j] = next;
            board[i][lim].moveTo(Move.right, lim - j);
          }
        } else if (current.number == next.number) {
          board[i][j] += board[i][j - 1];
          board[i][j - 1].moveTo(Move.right, 1);
        }
      }
    }
  }

  void _moveDown() {
    for (var j = width - 1; j >= 0; j--) {
      for (var i = height - 1; i > 0; i--) {
        final current = board[i][j];
        var next = board[i - 1][j];
        if (current.number == 0) {
          int? lim;
          for (var k = i; k >= 0; k--) {
            next = board[k][j];
            if (next.number != 0) {
              lim = k;
              break;
            }
          }
          if (lim != null) {
            board[i][j] += next;
            board[lim][j].moveTo(Move.down, lim - i);
          }
        } else if (current.number == next.number) {
          board[i][j] += board[i - 1][j];
          board[i - 1][j].moveTo(Move.down, 1);
        }
      }
    }
  }

  void _moveUp() {
    for (var j = 0; j < width; j++) {
      for (var i = 0; i < height - 1; i++) {
        final current = board[i][j];
        var next = board[i + 1][j];
        if (current.number == 0) {
          int? lim;
          for (var k = i; k < height; k++) {
            next = board[k][j];
            if (next.number != 0) {
              lim = k;
              break;
            }
          }
          if (lim != null) {
            board[i][j] += next;
            board[lim][j].moveTo(Move.up, lim - i);
          }
        } else if (current == next) {
          board[i][j] += board[i + 1][j];
          board[i + 1][j].moveTo(Move.up, 1);
        }
      }
    }
  }

/*

  [
    [],
    []
  ]


*/
  void _moveLeft() {
    for (var i = 0; i < height; i++) {
      for (var j = 0; j < width - 1; j++) {
        final current = board[i][j];
        var next = board[i][j + 1];
        if (current.number == 0) {
          int? lim;
          for (var k = j; k < width; k++) {
            next = board[i][k];
            if (next.number != 0) {
              lim = k;
              break;
            }
          }
          if (lim != null) {
            board[i][j] += next;
            board[i][lim].moveTo(Move.left, lim - j);
          }
        } else if (current == next) {
          board[i][j] += board[i][j + 1];
          board[i][j + 1].moveTo(Move.left, 1);
        }
      }
    }
  }

  // bool get canMoveLeft {
  //   for (var i = 0; i < height; i++) {
  //     if (board[i][0] == board[i][1] || board[i][0] == 0) return true;
  //   }
  //   return false;
  // }

  // bool get canMoveRight {
  //   for (var i = 0; i < height; i++) {
  //     if (board[i][width - 1] == board[i][width - 2] ||
  //         board[i][width - 1] == 0) return true;
  //   }
  //   return false;
  // }

  // bool get canMoveUp {
  //   for (var i = 0; i < width; i++) {
  //     if (board[0][i] == board[1][i] || board[0][i] == 0) return true;
  //   }
  //   return false;
  // }

  // bool get canMoveDown {
  //   for (var i = 0; i < width; i++) {
  //     if (board[height - 1][i] == board[height - 2][i] ||
  //         board[height - 1][i] == 0) return true;
  //   }
  //   return false;
  // }

  /// updates the [condition] of the game according to the board.
  void _updateState() {
    var hasZero = false;

    for (var i in board) {
      for (var j in i) {
        if (j == 2048) {
          condition = GameCondition.won;
          return;
        } else if (j == 0) {
          hasZero = true;
        }
      }
    }
    condition = hasZero ? GameCondition.ongoing : GameCondition.lost;
  }

  void _addRandomNumber() {
    int h, w;
    List<List<int>> tries = [];
    do {
      h = Random().nextInt(height);
      w = Random().nextInt(width);
      while (tries.contains([h, w])) {
        h = Random().nextInt(height);
        w = Random().nextInt(width);
      }
      tries.add([h, w]);
      if (tries.length == width * height) {
        condition = GameCondition.lost;
        notifyListeners();
        break;
      }
    } while (board[h][w] != 0);
    print('added 2 to [$h][$w]');

    Future.delayed(Duration(milliseconds: 100), () {
      board[h][w] = TileData(2 * (1 + Random().nextInt(1)));
      inProgress = false;
      notifyListeners();
    });
  }
}
