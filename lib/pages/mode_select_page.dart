import 'package:flutter/material.dart';
import '../widgets/BaseScaffold.dart';
import '../widgets/cute_button.dart';
import 'game_page.dart';
import 'guide_page.dart';

class ModeSelectPage extends StatelessWidget {
  const ModeSelectPage({super.key});

  // 설명 텍스트
  static const _desc3 =
      '• 3x3 보드에서 먼저 세 칸을 잇는 사람이 승리합니다.\n'
      '• 중앙과 코너를 활용해 공격과 수비를 병행하세요.\n'
      '• 가장 기본적인 모드로 초보자에게 적합합니다.';
  static const _desc4 =
      '• 4x4 보드에서는 네 칸을 직선으로 연결해야 승리합니다.\n'
      '• 수가 많아져 수비의 중요성이 커집니다.\n'
      '• 중급자에게 권장되는 모드입니다.';
  static const _desc5 =
      '• 5x5 보드에서는 다섯 칸을 직선으로 연결해야 승리합니다.\n'
      '• 넓은 공간에서 장기전이 자주 발생합니다.\n'
      '• 전략적 계획과 패턴 인식 능력이 중요합니다.';

  void _goGuide(BuildContext context, String title, String desc, int size) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => GuidePage(
          title: title,
          description: desc,
          gamePage: GamePage(boardSize: size),
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
            // 상단 홈 버튼
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
                    onPressed: () =>
                        Navigator.of(context).popUntil((r) => r.isFirst),
                  ),
                ),
              ),
            ),

            // 중앙 콘텐츠
            Expanded(
              child: Center(
                child: Padding(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        '난이도 선택',
                        style: TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.w700,
                          fontFamily: 'CuteFont',
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 40),

                      CuteButton(
                        label: '쉬움 3x3',
                        onPressed: () => _goGuide(context, '3x3 가이드', _desc3, 3),
                      ),
                      const SizedBox(height: 70),

                      CuteButton(
                        label: '보통 4x4',
                        onPressed: () => _goGuide(context, '4x4 가이드', _desc4, 4),
                      ),
                      const SizedBox(height: 70),

                      CuteButton(
                        label: '어려움 5x5',
                        onPressed: () => _goGuide(context, '5x5 가이드', _desc5, 5),
                      ),
                    ],
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
