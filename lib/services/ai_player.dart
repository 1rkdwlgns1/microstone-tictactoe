import 'dart:math';
import 'game_engine.dart';

class AIPlayer {
  final String aiLetter;
  final Random _random = Random();
  static const int maxDepth = 4;

  AIPlayer(this.aiLetter);

  int getRandomMove(GameEngine game) {
    List<int> available = [];
    List<String> board = game.board;

    for (int i = 0; i < board.length; i++) {
      if (board[i] == "") {
        available.add(i);
      }
    }
    return available[_random.nextInt(available.length)];
  }

  int getSmartMove(GameEngine game) {
    int boardSize = game.boardSize;

    if (boardSize == 3) {
      GameEngine copy = GameEngine.copy(game);
      return minimax(copy, aiLetter, false, 0).position;
    } else {
      GameEngine copy = GameEngine.copy(game);
      return minimax(copy, aiLetter, true, 0).position;
    }
  }

  Move minimax(GameEngine game, String player, bool useDepthLimit, int depth) {
    String maxPlayer = aiLetter;
    String otherPlayer = player == "X" ? "O" : "X";

    if (game.winner != null && game.winner == otherPlayer) {
      int score = (player == maxPlayer) ? -1 * (countEmpty(game) + 1) : 1 * (countEmpty(game) + 1);
      return Move(-1, score);
    }

    if (!game.board.contains("")) {
      return Move(-1, 0);
    }

    if (useDepthLimit && depth >= maxDepth) {
      int eval = evaluateBoard(game, maxPlayer);
      return Move(-1, eval);
    }

    List<Move> moves = [];

    for (int i = 0; i < game.board.length; i++) {
      if (game.board[i] == "") {
        game.board[i] = player;
        String? winnerBefore = game.winner;

        if (game.checkWinner(i, player)) {
          game.winner = player;
        }

        Move simScore = minimax(game, otherPlayer, useDepthLimit, depth + 1);
        simScore.position = i;

        game.board[i] = "";
        game.winner = winnerBefore;

        moves.add(simScore);
      }
    }

    Move? bestMove;
    if (player == maxPlayer) {
      int bestScore = -999999;
      for (Move m in moves) {
        if (m.score > bestScore) {
          bestScore = m.score;
          bestMove = m;
        }
      }
    } else {
      int bestScore = 999999;
      for (Move m in moves) {
        if (m.score < bestScore) {
          bestScore = m.score;
          bestMove = m;
        }
      }
    }

    return bestMove!;
  }

  int countEmpty(GameEngine game) {
    int count = 0;
    for (String s in game.board) {
      if (s == "") count++;
    }
    return count;
  }

  int evaluateBoard(GameEngine game, String player) {
    int score = 0;
    String opponent = player == "X" ? "O" : "X";

    for (String cell in game.board) {
      if (cell == player) {
        score += 2;
      } else if (cell == opponent) {
        score -= 2;
      } else {
        score += 1;
      }
    }

    return score;
  }
}

class Move {
  int position;
  int score;

  Move(this.position, this.score);
}
