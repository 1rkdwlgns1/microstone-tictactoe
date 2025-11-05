import 'package:flutter/material.dart';
import '../widgets/BaseScaffold.dart';
import 'result_page.dart';
import 'package:microstone_dart/services/speedrun_engine.dart';
import 'package:microstone_dart/services/speedrun_ai.dart';

class SpeedRunPage extends StatefulWidget {
  const SpeedRunPage({super.key});

  @override
  State<SpeedRunPage> createState() => _SpeedRunPageState();
}

class _SpeedRunPageState extends State<SpeedRunPage> {
  final int boardSize = 3;
  late SpeedRunEngine engine;
  late List<String> board;
  String currentPlayer = "X";
  bool isAITurn = false;
  int roundNumber = 1;

  int userWinCount = 0;
  int aiWinCount = 0;

  @override
  void initState() {
    super.initState();
    engine = SpeedRunEngine();
    board = List.filled(boardSize * boardSize, "");
    _newGame();
  }

  void _newGame() {
    setState(() {
      engine.reset();
      board = List.filled(boardSize * boardSize, "");
      isAITurn = false;
      currentPlayer = "X";
    });
  }

  void _handleTap(int index) {
    if (isAITurn || board[index] != "" || currentPlayer != "X") return;
    final success = engine.makeMove(index);
    if (success) _updateBoard();
  }

  void _aiMove() {
    setState(() => isAITurn = true);
    final aiMove = SpeedRunAI.getBestMove(engine);
    if (aiMove != -1) {
      engine.makeMove(aiMove);
      _updateBoard();
    }
    setState(() => isAITurn = false);
  }

  void _updateBoard() {
    setState(() {
      board = engine.getBoardAsList();
      currentPlayer = engine.getCurrentPlayer();
    });

    final winner = engine.getWinner();
    if (winner != null) {
      _updateScore(winner);
      _showRoundResultDialog(winner);
    } else if (!board.contains("")) {
      _showDrawDialog();
    } else {
      if (currentPlayer == "O") {
        Future.delayed(const Duration(milliseconds: 200), _aiMove);
      }
    }
  }

  void _updateScore(String winner) {
    if (winner == "X") {
      userWinCount++;
    } else if (winner == "O") {
      aiWinCount++;
    }
  }

  void _showRoundResultDialog(String winner) {
    final isUserWin = (winner == "X");
    final buttonText = (roundNumber < 3) ? "Next Round" : "Finish";

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
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
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
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
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
        builder: (_) => ResultPage(
          isWin: isUserWin,
          userScore: finalUserScore,
          aiScore: finalAiScore,
        ),
      ),
    );
  }

  // 상단 UI: 활성 표시(밑줄 얇게) + 고정폭 칩
  Widget _buildPlayerInfo() {
    final bool isYouTurn = currentPlayer == "X"; // 사람은 X
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
        child: const FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            "Your turn",
            style: TextStyle(
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
                const Text(
                  "Round  ",
                  style: TextStyle(
                    fontSize: 12, // 시각적 위치만 유지용. 실제 라운드는 아래 Text로 표시됨
                    color: Colors.transparent,
                  ),
                ),
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
                SizedBox(
                  width: 96,
                  height: 28,
                  child: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      isYouTurn ? "Your turn" : "AI turn",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontFamily: 'CuteFont',
                      ),
                    ),
                  ),
                ),
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
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
              ),
            ),
            const Expanded(flex: 1, child: SizedBox()),
            Column(
              children: [
                // 글씨만 아래로 살짝
                Padding(
                  padding: const EdgeInsets.only(top: 22),
                  child: _buildPlayerInfo(),
                ),
                const SizedBox(height: 28), // 기존 50에서 12 줄여 보드 위치 유지
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
              ],
            ),
            const Expanded(flex: 5, child: SizedBox()),
          ],
        ),
      ),
    );
  }
}
