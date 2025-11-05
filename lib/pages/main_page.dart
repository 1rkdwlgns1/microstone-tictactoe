import 'package:flutter/material.dart';
import '../widgets/BaseScaffold.dart';
import '../widgets/tic_tac_toe_board_painter.dart';
import '../widgets/cute_button.dart';
import 'mode_select_page.dart';
import 'play_more_page.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 보드판
            CustomPaint(
              size: const Size(300, 300),
              painter: TicTacToeBoardPainter(),
            ),
            const SizedBox(height: 20),

            // 가운데 텍스트
            const Text(
              'tic tac toe',
              style: TextStyle(
                fontSize: 60,
                fontWeight: FontWeight.w500,
                fontFamily: 'CuteFont',
              ),
            ),
            const SizedBox(height: 40),

            // 귀여운 버튼들
            CuteButton(
              label: '틱택토',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ModeSelectPage()),
                );
              },
            ),
            const SizedBox(height: 30),
            CuteButton(
              label: '다른 모드',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const PlayMorePage()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
