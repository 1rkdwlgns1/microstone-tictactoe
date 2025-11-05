import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:microstone_dart/services/game_engine.dart';
import 'package:microstone_dart/services/ai_player.dart';
import '../widgets/BaseScaffold.dart';
import 'result_page.dart';

class TicTacSnapPage extends StatefulWidget {
  const TicTacSnapPage({super.key});

  @override
  State<TicTacSnapPage> createState() => _TicTacSnapPageState();
}

class _TicTacSnapPageState extends State<TicTacSnapPage> {
  final int boardSize = 3;
  final String userSymbol = "X";
  final String aiSymbol = "O";
  late GameEngine game;
  late AIPlayer aiPlayer;

  int userWinCount = 0;
  int aiWinCount = 0;
  int roundNumber = 1;
  String currentPlayer = "X";

  int? flashingIndex;
  Timer? flashingTimer;
  Timer? limitTimer;
  int secondsLeft = 10;
  bool isAwaitingChoice = false;
  bool isGameBusy = false;

  @override
  void initState() {
    super.initState();
    game = GameEngine(boardSize);
    aiPlayer = AIPlayer(aiSymbol);
    _newGame();
  }

  @override
  void dispose() {
    flashingTimer?.cancel();
    limitTimer?.cancel();
    super.dispose();
  }

  void _newGame() {
    setState(() {
      game.reset();
      currentPlayer = (roundNumber == 2) ? aiSymbol : userSymbol;
      isGameBusy = false;
      flashingIndex = null;
    });
    Future.delayed(const Duration(milliseconds: 300), _nextTurn);
  }

  void _nextTurn() {
    if (game.getWinner() != null || !game.board.contains("")) return;
    if (currentPlayer == userSymbol) {
      _startFlashingForPlayer();
    } else {
      _startFlashingForAI();
    }
  }

  void _startTimeLimit(VoidCallback timeoutCallback) {
    limitTimer?.cancel();
    setState(() {
      secondsLeft = 10;
    });
    limitTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        secondsLeft--;
      });
      if (secondsLeft <= 0) {
        timer.cancel();
        timeoutCallback();
      }
    });
  }

  void _cancelTimeLimit() {
    limitTimer?.cancel();
    setState(() {
      secondsLeft = 10;
    });
  }

  void _startFlashingForPlayer() {
    flashingTimer?.cancel();
    setState(() {
      isAwaitingChoice = true;
      isGameBusy = false;
    });

    _startTimeLimit(() {
      _cancelTimeLimit();
      setState(() {
        isAwaitingChoice = false;
      });
      _turnTimeoutSkip();
    });

    flashingTimer = Timer.periodic(const Duration(milliseconds: 450), (_) {
      final available = [
        for (int i = 0; i < game.board.length; i++)
          if (game.board[i] == "") i,
      ];
      if (available.isEmpty) {
        flashingTimer?.cancel();
        setState(() {
          flashingIndex = null;
          isAwaitingChoice = false;
        });
        return;
      }
      setState(() {
        flashingIndex = available[Random().nextInt(available.length)];
      });
    });
  }

  void _startFlashingForAI() {
    flashingTimer?.cancel();
    setState(() {
      isGameBusy = true;
    });

    final int aiTarget = aiPlayer.getSmartMove(game);

    _startTimeLimit(() {
      _cancelTimeLimit();
      _turnTimeoutSkip();
    });

    flashingTimer = Timer.periodic(const Duration(milliseconds: 450), (timer) {
      final available = [
        for (int i = 0; i < game.board.length; i++)
          if (game.board[i] == "") i,
      ];
      if (available.isEmpty) {
        timer.cancel();
        setState(() {
          flashingIndex = null;
          isGameBusy = false;
        });
        return;
      }
      setState(() {
        flashingIndex = available[Random().nextInt(available.length)];
      });
      if (flashingIndex == aiTarget) {
        Future.delayed(const Duration(milliseconds: 120), () {
          _makeMoveAndProceed(aiTarget);
        });
        timer.cancel();
        _cancelTimeLimit();
      }
    });
  }

  void _turnTimeoutSkip() {
    flashingTimer?.cancel();
    setState(() {
      isGameBusy = false;
      isAwaitingChoice = false;
      currentPlayer = (currentPlayer == userSymbol) ? aiSymbol : userSymbol;
    });
    Future.delayed(const Duration(milliseconds: 400), _nextTurn);
  }

  void _trySelectFlashing() {
    if (!isAwaitingChoice || flashingIndex == null || isGameBusy) return;
    _cancelTimeLimit();
    _makeMoveAndProceed(flashingIndex!);
  }

  void _makeMoveAndProceed(int index) {
    if (game.board[index] != "" || game.getWinner() != null) return;
    flashingTimer?.cancel();
    _cancelTimeLimit();
    setState(() {
      isAwaitingChoice = false;
      isGameBusy = true;
    });
    final success = game.makeMove(index, currentPlayer);
    if (success) {
      _updateBoard();
    } else {
      setState(() {
        isGameBusy = false;
      });
      _nextTurn();
    }
  }

  void _updateBoard() {
    setState(() {});
    final winner = game.getWinner();
    if (winner != null) {
      if (winner == userSymbol) userWinCount++;
      if (winner == aiSymbol) aiWinCount++;
      if (userWinCount == 2 || aiWinCount == 2) {
        _showFinalResult();
      } else {
        _showRoundResultDialog(winner);
      }
    } else if (!game.board.contains("")) {
      _showDrawDialog();
    } else {
      setState(() {
        currentPlayer = (currentPlayer == userSymbol) ? aiSymbol : userSymbol;
        isGameBusy = false;
      });
      Future.delayed(const Duration(milliseconds: 400), _nextTurn);
    }
  }

  void _showRoundResultDialog(String winner) {
    final isUserWin = (winner == userSymbol);
    const buttonText = "Next Round";
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 10),
              Text(
                isUserWin ? "You Win!" : "You Lose!",
                style: const TextStyle(fontSize: 28, fontFamily: 'CuteFont', color: Colors.black),
              ),
              const SizedBox(height: 10),
              Text(
                "Score $userWinCount : $aiWinCount",
                style: const TextStyle(fontSize: 24, fontFamily: 'CuteFont', color: Colors.black),
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
                        _newGame();
                      });
                    });
                  },
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.black, width: 2),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    backgroundColor: Colors.white,
                  ),
                  child: const Text(
                    buttonText,
                    style: TextStyle(fontSize: 20, fontFamily: 'CuteFont', color: Colors.black),
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
    const buttonText = "Next Round";
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "It's a Tie!",
                style: TextStyle(fontSize: 36, fontFamily: 'CuteFont', color: Colors.black),
              ),
              const SizedBox(height: 10),
              Text(
                "Round $roundNumber is a tie!",
                style: const TextStyle(fontSize: 24, fontFamily: 'CuteFont', color: Colors.black),
              ),
              const SizedBox(height: 10),
              Text(
                "Score $userWinCount : $aiWinCount",
                style: const TextStyle(fontSize: 24, fontFamily: 'RobotoMono', color: Colors.black),
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
                        _newGame();
                      });
                    });
                  },
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.black, width: 2),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    backgroundColor: Colors.white,
                  ),
                  child: const Text(
                    buttonText,
                    style: TextStyle(fontSize: 20, fontFamily: 'CuteFont', color: Colors.black),
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
        builder: (_) => ResultPage(
          isWin: isUserWin,
          userScore: finalUserScore,
          aiScore: finalAiScore,
        ),
      ),
    );
  }

  // 상단 정보: 밑줄(얇게) + 고정폭 칩
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

  // 새 타이머 UI
  Widget _buildTimerBar() {
    final double progress = (secondsLeft / 10).clamp(0.0, 1.0);
    final Color nColor = secondsLeft <= 3 ? Colors.red : Colors.black;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 12),
          child: Text(
            "$secondsLeft",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: nColor,
            ),
          ),
        ),
        Container(
          width: 200,
          height: 14,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(7),
            border: Border.all(color: Colors.black, width: 2),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: Colors.white,
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.black),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCell(int index) {
    final bool isFlash = (index == flashingIndex);
    return Container(
      margin: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: isFlash ? Colors.yellow[200] : Colors.white,
        border: Border.all(color: Colors.black, width: 2),
      ),
      child: Center(
        child: Text(
          game.board[index],
          style: const TextStyle(
            fontSize: 48,
            fontFamily: 'CuteFont',
            color: Colors.black,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 16, top: 10),
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
              const SizedBox(height: 10),

              // 글씨를 살짝 아래로
              Padding(
                padding: const EdgeInsets.only(top: 22),
                child: _buildPlayerInfo(),
              ),
              const SizedBox(height: 28),

              _buildTimerBar(),
              const SizedBox(height: 12),

              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black, width: 3),
                ),
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: boardSize * boardSize,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: boardSize,
                  ),
                  itemBuilder: (context, index) => _buildCell(index),
                ),
              ),
              const SizedBox(height: 8),

              ElevatedButton(
                onPressed: (isAwaitingChoice &&
                    currentPlayer == userSymbol &&
                    flashingIndex != null &&
                    !isGameBusy)
                    ? _trySelectFlashing
                    : null,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(180, 56),
                  backgroundColor:
                  isAwaitingChoice ? const Color(0xFF54555E) : Colors.grey.shade300,
                  foregroundColor: Colors.white,
                  elevation: 8,
                  shadowColor: Colors.black.withOpacity(0.16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                    side: BorderSide(
                      color: isAwaitingChoice ? const Color(0xFF54555E) : Colors.grey,
                      width: 2,
                    ),
                  ),
                  textStyle: const TextStyle(
                    fontSize: 28,
                    fontFamily: 'CuteFont',
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.5,
                  ),
                ),
                child: const Text("두기"),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
