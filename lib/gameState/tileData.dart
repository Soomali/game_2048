import 'package:flutter/cupertino.dart';

import 'gameState.dart';

class TileData {
  int _number;
  int get number => _number;
  set number(int val) {
    _number = val;
    if (val != 0) {
      hasChanged = true;
    }
  }

  int _verticalMove = 0;
  int _horizontalMove = 0;
  int awaiting = 0;
  bool hasChanged = false;
  Offset get movedOffset {
    return Offset(_verticalMove * GameState.tileSize,
        _horizontalMove * GameState.tileSize);
  }

  late Offset start;
  late Offset end;

  bool get hasMoved => _verticalMove != 0 || _horizontalMove != 0;
  TileData(this._number);

  TileData operator +(TileData other) {
    number += other.number;
    return this;
  }

  void performMove() {
    if (hasMoved) {
      _number = awaiting;
      awaiting = 0;
      _verticalMove = 0;
      _horizontalMove = 0;
    }
    hasChanged = false;
  }

  void moveTo(Move move, int difference) {
    switch (move) {
      case Move.right:
        _verticalMove -= difference;
        break;
      case Move.left:
        _verticalMove -= difference;
        break;
      case Move.up:
        _horizontalMove -= difference;
        break;
      case Move.down:
        _horizontalMove -= difference;
        break;
    }
  }

  @override
  String toString() {
    return 'number:$number verticalMove:$_verticalMove horizontalMove:$_horizontalMove';
  }
}
