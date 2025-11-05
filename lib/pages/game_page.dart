import 'package:flutter/material.dart';
import '../widgets/BaseScaffold.dart';
import 'result_page.dart';
import 'package:microstone_dart/services/game_engine.dart';
import 'package:microstone_dart/services/ai_player.dart';

class GamePage extends StatefulWidget {
  final int boardSize;

  const GamePage({super.key, required this.boardSize});

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  late GameEngine game;
  late AIPlayer aiPlayer;
  String currentPlayer = "X";
  bool isAITurn = false;
  int roundNumber = 1;

  int userWinCount = 0;
  int aiWinCount = 0;

  final String userSymbol = "X";
  final String aiSymbol = "O";

  @override
  void initState() {
    super.initState();
    game = GameEngine(widget.boardSize);
    aiPlayer = AIPlayer(aiSymbol);
    _newGame();
  }

  void _newGame() {
    setState(() {
      game.reset();
      isAITurn = false;
      if (roundNumber == 2) {
        currentPlayer = aiSymbol;
        isAITurn = true;
      } else {
        currentPlayer = userSymbol;
      }
    });
    if (isAITurn) {
      Future.delayed(const Duration(milliseconds: 200), _aiMove);
    }
  }

  void _handleTap(int index) {
    if (isAITurn || game.board[index] != "" || currentPlayer != userSymbol)
      return;
    _makePlayerMove(index);
    if (currentPlayer == aiSymbol) {
      Future.delayed(const Duration(milliseconds: 200), _aiMove);
    }
  }

  void _makePlayerMove(int index) {
    final ok = game.makeMove(index, currentPlayer);
    if (ok) _updateBoard();
  }

  void _aiMove() {
    setState(() => isAITurn = true);
    final aiMove = aiPlayer.getSmartMove(game);
    if (aiMove == -1) {
      setState(() => isAITurn = false);
      return;
    }
    final ok = game.makeMove(aiMove, currentPlayer);
    if (ok) _updateBoard();
    setState(() => isAITurn = false);
  }

  void _updateBoard() {
    setState(() {});
    final w = game.getWinner();
    if (w != null) {
      _updateScore(w);
      _showRoundResultDialog(w);
    } else if (!game.board.contains("")) {
      _showDrawDialog();
    } else {
      setState(
        () =>
            currentPlayer =
                (currentPlayer == userSymbol) ? aiSymbol : userSymbol,
      );
    }
  }

  void _updateScore(String winner) {
    if (winner == userSymbol) {
      userWinCount++;
    } else if (winner == aiSymbol) {
      aiWinCount++;
    }
  }

  void _showRoundResultDialog(String winner) {
    final isUserWin = (winner == userSymbol);
    final buttonText = (roundNumber < 3) ? "Next Round" : "Finish";

    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (_) => Dialog(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "Round Finished",
                    style: TextStyle(
                      fontSize: 36,
                      fontFamily: 'CuteFont',
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    isUserWin ? "You Win!" : "You Lose!",
                    style: const TextStyle(
                      fontSize: 28,
                      fontFamily: 'CuteFont',
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Score $userWinCount : $aiWinCount",
                    style: const TextStyle(
                      fontSize: 24,
                      fontFamily: 'CuteFont',
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 30),
                  SizedBox(
                    width: 150,
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        Future.delayed(const Duration(milliseconds: 100), () {
                          setState(() {
                            roundNumber++;
                            if (roundNumber <= 3) {
                              _newGame();
                            } else {
                              _showFinalResult();
                            }
                          });
                        });
                      },
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.black, width: 2),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        backgroundColor: Colors.white,
                      ),
                      child: Text(
                        buttonText,
                        style: const TextStyle(
                          fontSize: 20,
                          fontFamily: 'CuteFont',
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
    );
  }

  void _showDrawDialog() {
    final buttonText = (roundNumber < 3) ? "Next Round" : "Finish";

    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (_) => Dialog(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "It's a Tie!",
                    style: TextStyle(
                      fontSize: 36,
                      fontFamily: 'CuteFont',
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Round $roundNumber is a tie!",
                    style: const TextStyle(
                      fontSize: 24,
                      fontFamily: 'CuteFont',
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Score $userWinCount : $aiWinCount",
                    style: const TextStyle(
                      fontSize: 24,
                      fontFamily: 'CuteFont',
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 30),
                  SizedBox(
                    width: 150,
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        Future.delayed(const Duration(milliseconds: 100), () {
                          setState(() {
                            roundNumber++;
                            if (roundNumber <= 3) {
                              _newGame();
                            } else {
                              _showFinalResult();
                            }
                          });
                        });
                      },
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.black, width: 2),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        backgroundColor: Colors.white,
                      ),
                      child: Text(
                        buttonText,
                        style: const TextStyle(
                          fontSize: 20,
                          fontFamily: 'CuteFont',
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
    );
  }

  void _showFinalResult() {
    final isUserWin = userWinCount > aiWinCount;
    final finalUserScore = userWinCount;
    final finalAiScore = aiWinCount;

    setState(() {
      roundNumber = 1;
      userWinCount = 0;
      aiWinCount = 0;
    });

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder:
            (_) => ResultPage(
              isWin: isUserWin,
              userScore: finalUserScore,
              aiScore: finalAiScore,
            ),
      ),
    );
  }

  Widget _buildPlayerInfo() {
    final bool isYouTurn = currentPlayer == userSymbol;
    final Color active = Colors.black;
    final Color inactive = Colors.black.withOpacity(0.35);

    TextStyle nameStyle(bool on) => TextStyle(
      fontSize: 40,
      fontFamily: 'CuteFont',
      fontWeight: FontWeight.w700,
      color: on ? active : inactive,
      decoration: on ? TextDecoration.underline : TextDecoration.none,
      decorationThickness: 1.6,
      decorationColor: Colors.black,
    );

    TextStyle symbolStyle(bool on) => TextStyle(
      fontSize: 30,
      fontFamily: 'CuteFont',
      color: on ? active : inactive,
    );

    Widget playerCol(String name, String symbol, bool on) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(name, style: nameStyle(on)),
          const SizedBox(height: 5),
          Text(symbol, style: symbolStyle(on)),
        ],
      );
    }

    const double chipW = 96, chipH = 28;

    Widget fixedTurnChip(String text) => SizedBox(
      width: chipW,
      height: chipH,
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(12),
        ),
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontFamily: 'CuteFont',
            ),
          ),
        ),
      ),
    );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Expanded(child: playerCol("You", "X", isYouTurn)),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Round $roundNumber",
                  style: const TextStyle(
                    fontSize: 25,
                    fontFamily: 'CuteFont',
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  "$userWinCount : $aiWinCount",
                  style: const TextStyle(
                    fontSize: 24,
                    fontFamily: 'RobotoMono',
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 8),
                fixedTurnChip(isYouTurn ? "Your turn" : "AI turn"),
              ],
            ),
          ),
          Expanded(child: playerCol("AI", "O", !isYouTurn)),
        ],
      ),
    );
  }

  // 변경된 부분: 5x5일 때만 fontSize 조절, 나머지는 기존 48 유지
  Widget _buildCell(int index) {
    double fontSize;
    if (widget.boardSize == 5) {
      double boardSizePx = 360.0;
      double cellSize = boardSizePx / widget.boardSize;
      fontSize = cellSize * 0.65;
    } else {
      fontSize = 48;
    }

    return GestureDetector(
      onTap: () => _handleTap(index),
      child: Container(
        margin: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.black, width: 2),
        ),
        child: Center(
          child: Text(
            game.board[index],
            style: TextStyle(
              fontSize: fontSize,
              fontFamily: 'CuteFont',
              color: Colors.black,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double boardBoxSize = 360.0;

    return BaseScaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 16, top: 12),
              child: Align(
                alignment: Alignment.topLeft,
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.black, width: 2),
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.home, size: 30, color: Colors.black),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
              ),
            ),
            const Expanded(flex: 1, child: SizedBox()),
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 22),
                  child: _buildPlayerInfo(),
                ),
                const SizedBox(height: 28),
                Center(
                  child: Container(
                    width: boardBoxSize,
                    height: boardBoxSize,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.black, width: 3),
                    ),
                    child: GridView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      padding: EdgeInsets.zero,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: widget.boardSize,
                      ),
                      itemCount: widget.boardSize * widget.boardSize,
                      itemBuilder: (context, index) => _buildCell(index),
                    ),
                  ),
                ),
              ],
            ),
            const Expanded(flex: 5, child: SizedBox()),
          ],
        ),
      ),
    );
  }
}
