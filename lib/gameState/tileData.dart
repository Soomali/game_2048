import 'gameState.dart';

class TileData {
  int number;
  int _verticalMove = 0;
  int _horizontalMove = 0;
  bool get _hasMoved => _verticalMove != 0 || _horizontalMove != 0;
  TileData(this.number);

  TileData operator +(TileData other) {
    if (number == 0) return other;
    number += other.number;
    return this;
  }

  void performMove() {
    if (_hasMoved) {
      number = 0;
      _verticalMove = 0;
      _horizontalMove = 0;
    }
  }

  void moveTo(Move move, int difference) {
    switch (move) {
      case Move.right:
        _verticalMove -= difference;
        break;
      case Move.left:
        _verticalMove += difference;
        break;
      case Move.up:
        _horizontalMove += difference;
        break;
      case Move.down:
        _horizontalMove -= difference;
        break;
    }
  }
}
