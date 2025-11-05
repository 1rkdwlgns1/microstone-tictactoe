import 'package:flutter/material.dart';
import 'package:microstone_dart/services/notactoe_engine.dart';
import 'package:microstone_dart/services/notactoe_ai.dart';
import '../widgets/BaseScaffold.dart';
import 'result_page.dart';

class NoTacToePage extends StatefulWidget {
  const NoTacToePage({super.key});

  @override
  State<NoTacToePage> createState() => _NoTacToePageState();
}

class _NoTacToePageState extends State<NoTacToePage> {
  final int boardSize = 3;
  late NoTacToeEngine engine;
  late List<String> board;
  final String playerSymbol = "O";
  final String aiSymbol = "O";

  String currentPlayer = "O";
  bool isAITurn = false;
  int roundNumber = 1;
  int userWinCount = 0;
  int aiWinCount = 0;
  bool aiFirst = false; // 내가 지면 AI 선공

  @override
  void initState() {
    super.initState();
    engine = NoTacToeEngine(boardSize: boardSize);
    board = List.filled(boardSize * boardSize, "");
    _newGame();
  }

  void _newGame() {
    setState(() {
      engine.reset();
      board = List.filled(boardSize * boardSize, "");
      isAITurn = aiFirst; // UI에 즉시 반영
      currentPlayer = aiFirst ? aiSymbol : playerSymbol;
    });
    if (aiFirst) {
      Future.delayed(const Duration(milliseconds: 200), _aiMove);
    }
  }

  void _handleTap(int index) {
    if (isAITurn || board[index] != "" || currentPlayer != playerSymbol) return;
    bool success = engine.makeMove(index, playerSymbol);
    if (success) {
      bool hasLoser = engine.checkLose(playerSymbol);
      setState(() {
        board = engine.getBoardAsList();
      });
      if (hasLoser) {
        aiWinCount++;
        _showRoundResultDialog(userLose: true);
      } else if (!board.contains("")) {
        _showDrawDialog();
      } else {
        setState(() {
          currentPlayer = aiSymbol;
          isAITurn = true;
        });
        Future.delayed(const Duration(milliseconds: 200), _aiMove);
      }
    }
  }

  void _aiMove() {
    int aiMove = NoTacToeAI.getBestMove(engine);
    if (aiMove != -1) {
      engine.makeMove(aiMove, aiSymbol);
      bool hasLoser = engine.checkLose(aiSymbol);
      setState(() {
        board = engine.getBoardAsList();
      });
      if (hasLoser) {
        userWinCount++;
        _showRoundResultDialog(userLose: false);
      } else if (!board.contains("")) {
        _showDrawDialog();
      } else {
        setState(() {
          currentPlayer = playerSymbol;
          isAITurn = false;
        });
      }
    } else {
      setState(() {
        isAITurn = false;
        currentPlayer = playerSymbol;
      });
      _showDrawDialog();
    }
  }

  void _showRoundResultDialog({required bool userLose}) {
    String buttonText = (roundNumber < 3) ? "Next Round" : "Finish";
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
                userLose ? "You Lose!" : "You Win!",
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
                        aiFirst = userLose; // 지면 AI 선공
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
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    backgroundColor: Colors.white,
                  ),
                  child: Text(
                    buttonText,
                    style: const TextStyle(fontSize: 20, fontFamily: 'CuteFont', color: Colors.black),
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
    String buttonText = (roundNumber < 3) ? "Next Round" : "Finish";
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
                        aiFirst = false; // 무승부는 내가 선공
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
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    backgroundColor: Colors.white,
                  ),
                  child: Text(
                    buttonText,
                    style: const TextStyle(fontSize: 20, fontFamily: 'CuteFont', color: Colors.black),
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
    bool isUserWin = userWinCount > aiWinCount;
    int finalUserScore = userWinCount;
    int finalAiScore = aiWinCount;
    setState(() {
      roundNumber = 1;
      userWinCount = 0;
      aiWinCount = 0;
      aiFirst = false;
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

  // 상단 UI만 수정: 활성 표시(밑줄 얇게) + 고정폭 칩
  Widget _buildPlayerInfo() {
    final bool isYouTurn = !isAITurn; // ← AI/플레이어 동일 기호 대응
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
          Expanded(child: playerCol("You", "O", isYouTurn)),
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

  Widget _buildCell(int index) {
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
            board[index],
            style: const TextStyle(
              fontSize: 48,
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
    return BaseScaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
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
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
              ),
            ),
            // 글씨를 아래로 조금 내리고, 보드 위치는 유지
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.only(top: 22),
              child: _buildPlayerInfo(),
            ),
            const SizedBox(height: 28),
            Container(
              margin: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black, width: 3),
              ),
              child: GridView.builder(
                shrinkWrap: true,
                itemCount: boardSize * boardSize,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: boardSize,
                ),
                itemBuilder: (context, index) => _buildCell(index),
              ),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
