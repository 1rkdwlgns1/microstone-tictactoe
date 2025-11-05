class SnapEngine {
  final List<int> board = List.filled(9, 0);
  int targetIndex = -1;

  void reset() {
    for (int i = 0; i < board.length; i++) {
      board[i] = 0;
    }
    targetIndex = -1;
  }

  void setTarget(int index) {
    reset();
    board[index] = 1;
    targetIndex = index;
  }

  bool checkTap(int index) {
    return index == targetIndex;
  }

  List<int> getBoard() {
    return List.from(board);
  }
}
