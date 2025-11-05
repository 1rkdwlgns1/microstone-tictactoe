import 'dart:math';
import 'speedrun_engine.dart';

class SpeedRunAI {
  static int getBestMove(SpeedRunEngine engine) {
    int bestScore = -999999;
    int bestMove = -1;

    List<String> board = engine.getBoardAsList();

    for (int i = 0; i < 9; i++) {
      if (board[i] == "") {
        SpeedRunEngine copy = engine.copy();
        copy.setCurrentPlayer("O");
        copy.makeMove(i);

        int score = minimax(copy, false, 0);

        if (score > bestScore) {
          bestScore = score;
          bestMove = i;
        }
      }
    }

    return bestMove;
  }

  static int minimax(SpeedRunEngine engine, bool isMaximizing, int depth) {
    String? winner = engine.getWinner();

    if (winner != null) {
      if (winner == "O") return 10 - depth; // AI 승리
      else return depth - 10; // X 승리
    }

    if (engine.isBoardFull() || depth >= 5) {
      return 0; // 무승부 또는 depth 제한
    }

    List<String> board = engine.getBoardAsList();

    if (isMaximizing) {
      int bestScore = -999999;
      for (int i = 0; i < 9; i++) {
        if (board[i] == "") {
          SpeedRunEngine copy = engine.copy();
          copy.setCurrentPlayer("O");
          copy.makeMove(i);

          int score = minimax(copy, false, depth + 1);
          bestScore = max(score, bestScore);
        }
      }
      return bestScore;
    } else {
      int bestScore = 999999;
      for (int i = 0; i < 9; i++) {
        if (board[i] == "") {
          SpeedRunEngine copy = engine.copy();
          copy.setCurrentPlayer("X");
          copy.makeMove(i);

          int score = minimax(copy, true, depth + 1);
          bestScore = min(score, bestScore);
        }
      }
      return bestScore;
    }
  }
}
