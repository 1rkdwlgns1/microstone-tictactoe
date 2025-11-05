import 'package:flutter/material.dart';
import '../widgets/BaseScaffold.dart';
import 'main_page.dart';

class ResultPage extends StatelessWidget {
  final bool isWin;
  final int userScore;
  final int aiScore;

  const ResultPage({
    super.key,
    required this.isWin,
    required this.userScore,
    required this.aiScore,
  });

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              isWin ? 'You Win!' : 'You Lose!',
              style: const TextStyle(
                fontSize: 45,
                fontFamily: 'CuteFont',
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Score $userScore : $aiScore',
              style: const TextStyle(
                fontSize: 24,
                fontFamily: 'RobotoMono',
              ),
            ),
            const SizedBox(height: 40),
            SizedBox(
              width: 225,
              height: 60,
              child: OutlinedButton(
                onPressed: () {
                  Navigator.of(context).popUntil((route) => route.isFirst);
                },
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.black, width: 3),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  backgroundColor: Colors.white,
                ),
                child: const Text(
                  'Go Home',
                  style: TextStyle(
                    fontSize: 24,
                    fontFamily: 'CuteFont',
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
