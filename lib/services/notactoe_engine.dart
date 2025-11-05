class NoTacToeEngine {
  final int boardSize;
  List<String> board;

  NoTacToeEngine({this.boardSize = 3}) : board = List.filled(9, "");

  NoTacToeEngine.copy(NoTacToeEngine other)
      : boardSize = other.boardSize,
        board = List.from(other.board);

  bool makeMove(int index, String player) {
    if (index < 0 || index >= board.length) return false;
    if (board[index] == "") {
      board[index] = player; // 항상 'O'
      return true;
    }
    return false;
  }

  /// 'O'가 3목 완성됐는지(패배 상황)
  bool checkLose(String player) {
    for (int row = 0; row < boardSize; row++) {
      bool win = true;
      for (int col = 0; col < boardSize; col++) {
        if (board[row * boardSize + col] != player) {
          win = false;
          break;
        }
      }
      if (win) return true;
    }
    for (int col = 0; col < boardSize; col++) {
      bool win = true;
      for (int row = 0; row < boardSize; row++) {
        if (board[row * boardSize + col] != player) {
          win = false;
          break;
        }
      }
      if (win) return true;
    }
    // 대각선
    bool diagWin = true;
    for (int i = 0; i < boardSize; i++) {
      if (board[i * boardSize + i] != player) {
        diagWin = false;
        break;
      }
    }
    if (diagWin) return true;
    // 역대각선
    bool antiDiagWin = true;
    for (int i = 0; i < boardSize; i++) {
      if (board[i * boardSize + (boardSize - 1 - i)] != player) {
        antiDiagWin = false;
        break;
      }
    }
    if (antiDiagWin) return true;

    return false;
  }

  List<String> getBoardAsList() => List.from(board);

  void reset() {
    for (int i = 0; i < board.length; i++) {
      board[i] = "";
    }
  }
}
