import 'dart:core';

class GameEngine {
  final int boardSize;
  List<String> board;
  String? winner;

  // 기본 생성자
  GameEngine(this.boardSize) : board = List.filled(boardSize * boardSize, ""), winner = null;

  // 복사 생성자
  GameEngine.copy(GameEngine other)
      : boardSize = other.boardSize,
        board = List.from(other.board),
        winner = other.winner;

  void setWinner(String? winner) {
    this.winner = winner;
  }

  bool makeMove(int index, String player) {
    if (index < 0 || index >= board.length) return false;
    if (board[index] == "") {
      board[index] = player;
      if (checkWinner(index, player)) {
        winner = player;
      }
      return true;
    }
    return false;
  }

  bool checkWinner(int index, String player) {
    int row = index ~/ boardSize;
    int col = index % boardSize;

    // 가로 체크
    bool rowWin = true;
    for (int i = 0; i < boardSize; i++) {
      if (board[row * boardSize + i] != player) {
        rowWin = false;
        break;
      }
    }
    if (rowWin) return true;

    // 세로 체크
    bool colWin = true;
    for (int i = 0; i < boardSize; i++) {
      if (board[i * boardSize + col] != player) {
        colWin = false;
        break;
      }
    }
    if (colWin) return true;

    // 대각선 체크 (왼↘오)
    if (row == col) {
      bool diagWin = true;
      for (int i = 0; i < boardSize; i++) {
        if (board[i * boardSize + i] != player) {
          diagWin = false;
          break;
        }
      }
      if (diagWin) return true;
    }

    // 대각선 체크 (오↙왼)
    if (row + col == boardSize - 1) {
      bool antiDiagWin = true;
      for (int i = 0; i < boardSize; i++) {
        if (board[i * boardSize + (boardSize - 1 - i)] != player) {
          antiDiagWin = false;
          break;
        }
      }
      if (antiDiagWin) return true;
    }

    return false;
  }

  List<String> getBoard() {
    return List.from(board);
  }

  String? getWinner() {
    return winner;
  }

  void reset() {
    for (int i = 0; i < board.length; i++) {
      board[i] = "";
    }
    winner = null;
  }
}
