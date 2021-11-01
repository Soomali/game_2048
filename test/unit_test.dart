import 'package:game_2048/gameState/gameState.dart';
import 'package:test/test.dart';

void main() {
  test('generates 5x5 board with a 2 in it', () {
    var state = GameState(width: 5, height: 5);
    expect(5, state.board.length);
    expect(5, state.board.first.length);
    expect(
        true, state.board.any((element) => element.any((elem) => elem == 2)));
  });
  late GameState moveState;
  List<List<int>> initList() => [
        [0, 2, 2, 0],
        [2, 8, 8, 0],
        [4, 4, 8, 0],
        [0, 2, 2, 4],
      ];
  List<List<int>> onlyMoveableDown() => [
        [2, 4, 2, 4],
        [4, 2, 4, 2],
        [2, 4, 2, 4],
        [8, 4, 8, 8]
      ];
  List<List<int>> onlyMoveableLeft() => [
        [2, 4, 2, 4],
        [4, 2, 4, 2],
        [2, 4, 2, 4],
        [2, 8, 8, 16]
      ];
  List<List<int>> onlyMoveableRight() => [
        [2, 4, 2, 4],
        [4, 2, 4, 2],
        [2, 4, 2, 4],
        [16, 16, 8, 8]
      ];
  List<List<int>> onlyMoveableUp() => [
        [2, 4, 2, 4],
        [4, 8, 2, 8],
        [2, 4, 8, 4],
        [8, 4, 16, 8]
      ];
  /*
  
  [,
     [0, 2, 2, 0],
     [2, 8, 8, 0],
     [0, 4, 8, 0],
     [0, 0, 2, 4]
   ]
   */
  reset() {
    moveState = GameState.createSet(4, 4, initList());
    moveState.condition = GameCondition.won;
  }

  setUp(() {
    moveState = GameState.createSet(4, 4, [
      [0, 2, 2, 0],
      [2, 8, 8, 0],
      [4, 4, 8, 0],
      [0, 2, 2, 4]
    ]);
    moveState.condition = GameCondition.won;
  });

  test('creates a defined board.', () {
    expect(initList(), moveState.board);
  });
  test('moves board to the left', () {
    moveState.handleMovement(Move.left, debug: true);
    expect(moveState.board, [
      [2, 2, 0, 0],
      [2, 16, 0, 0],
      [8, 8, 0, 0],
      [2, 2, 4, 0]
    ]);
  });

  test('moves board to the up', () {
    reset();
    moveState.handleMovement(Move.up, debug: true);
    expect(moveState.board, [
      [2, 2, 2, 4],
      [4, 8, 16, 0],
      [0, 4, 2, 0],
      [0, 2, 0, 0]
    ]);
  });
  test('moves board to the right', () {
    reset();
    moveState.handleMovement(Move.right, debug: true);
    expect(moveState.board, [
      [0, 0, 2, 2],
      [0, 2, 8, 8],
      [0, 4, 4, 8],
      [0, 0, 4, 4]
    ]);
  });
  test('moves board to down', () {
    reset();

    moveState.handleMovement(Move.down, debug: true);
    expect(
      moveState.board,
      [
        [0, 2, 0, 0],
        [0, 8, 2, 0],
        [2, 4, 16, 0],
        [4, 2, 2, 4]
      ],
    );
  });
  test('determines movability to left', () {
    // reset();
    // expect(true, moveState.canMoveLeft);
  });
}
