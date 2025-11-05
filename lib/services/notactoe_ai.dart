import 'dart:math';
import 'notactoe_engine.dart';

class NoTacToeAI {
  static final Random _random = Random();
  static const int maxDepth = 5;

  static int getBestMove(NoTacToeEngine engine) {
    NoTacToeEngine copy = NoTacToeEngine.copy(engine);
    Move move = minimax(copy, true, 0);
    return move.position;
  }

  static int getRandomMove(NoTacToeEngine engine) {
    List<int> available = [];
    List<String> board = engine.getBoardAsList();
    for (int i = 0; i < board.length; i++) {
      if (board[i] == "") available.add(i);
    }
    return available[_random.nextInt(available.length)];
  }

  static Move minimax(NoTacToeEngine engine, bool isAITurn, int depth) {
    if (engine.checkLose("O")) {
      // 현재 턴이 AI면 AI가 마지막으로 두어서 3목 완성(패), 아니면 플레이어 패배
      return Move(-1, isAITurn ? -10 + depth : 10 - depth);
    }
    if (!engine.board.contains("")) return Move(-1, 0); // 무승부

    if (depth >= maxDepth) return Move(-1, 0);

    List<Move> moves = [];
    for (int i = 0; i < engine.board.length; i++) {
      if (engine.board[i] == "") {
        engine.board[i] = "O";
        Move simScore = minimax(engine, !isAITurn, depth + 1);
        simScore.position = i;
        engine.board[i] = "";
        moves.add(simScore);
      }
    }

    if (isAITurn) {
      Move? bestMove;
      int bestScore = -99999;
      for (Move move in moves) {
        if (move.score > bestScore) {
          bestScore = move.score;
          bestMove = move;
        }
      }
      return bestMove ?? Move(-1, 0);
    } else {
      Move? bestMove;
      int bestScore = 99999;
      for (Move move in moves) {
        if (move.score < bestScore) {
          bestScore = move.score;
          bestMove = move;
        }
      }
      return bestMove ?? Move(-1, 0);
    }
  }
}

class Move {
  int position;
  int score;
  Move(this.position, this.score);
}
