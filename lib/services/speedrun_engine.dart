import 'dart:collection';

class SpeedRunEngine {
  List<String> board;
  Queue<int> xMoves;
  Queue<int> oMoves;
  String currentPlayer;

  SpeedRunEngine()
      : board = List.filled(9, ""),
        xMoves = Queue<int>(),
        oMoves = Queue<int>(),
        currentPlayer = "X" {
    reset();
  }

  void reset() {
    for (int i = 0; i < 9; i++) {
      board[i] = "";
    }
    xMoves.clear();
    oMoves.clear();
    currentPlayer = "X";
  }

  bool makeMove(int index) {
    if (board[index] != "") return false;

    placeMove(index);
    deleteOldestIfNeeded();
    switchTurn();

    return true;
  }

  void placeMove(int index) {
    board[index] = currentPlayer;

    if (currentPlayer == "X") {
      xMoves.add(index);
    } else {
      oMoves.add(index);
    }
  }

  void deleteOldestIfNeeded() {
    if (currentPlayer == "X") {
      if (xMoves.length > 3) {
        int removeIdx = xMoves.removeFirst();
        board[removeIdx] = "";
      }
    } else {
      if (oMoves.length > 3) {
        int removeIdx = oMoves.removeFirst();
        board[removeIdx] = "";
      }
    }
  }

  void switchTurn() {
    currentPlayer = currentPlayer == "X" ? "O" : "X";
  }

  String getCurrentPlayer() {
    return currentPlayer;
  }

  void setCurrentPlayer(String player) {
    currentPlayer = player;
  }

  String? getWinner() {
    List<List<int>> winPatterns = [
      [0, 1, 2],
      [3, 4, 5],
      [6, 7, 8],
      [0, 3, 6],
      [1, 4, 7],
      [2, 5, 8],
      [0, 4, 8],
      [2, 4, 6]
    ];

    for (var pattern in winPatterns) {
      int a = pattern[0];
      int b = pattern[1];
      int c = pattern[2];

      if (board[a] != "" && board[a] == board[b] && board[a] == board[c]) {
        return board[a];
      }
    }

    return null;
  }

  bool isBoardFull() {
    for (var s in board) {
      if (s == "") return false;
    }
    return true;
  }

  SpeedRunEngine copy() {
    SpeedRunEngine newEngine = SpeedRunEngine();
    for (int i = 0; i < 9; i++) {
      newEngine.board[i] = board[i];
    }
    newEngine.xMoves = Queue<int>.from(xMoves);
    newEngine.oMoves = Queue<int>.from(oMoves);
    newEngine.currentPlayer = currentPlayer;
    return newEngine;
  }

  List<String> getBoardAsList() {
    return List.from(board);
  }
}
