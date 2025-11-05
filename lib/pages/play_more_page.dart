import 'package:flutter/material.dart';
import '../widgets/BaseScaffold.dart';
import '../widgets/cute_button.dart';
import 'guide_page.dart';
import 'speedrun_page.dart';
import 'notactoe_page.dart';
import 'tictac_snap_page.dart';

class PlayMorePage extends StatelessWidget {
  const PlayMorePage({super.key});

  static const speedrunDescription = '''
• 스피드런 모드는 제한 시간 내 가장 빠르게 3개의 말을 연결하여 승리하세요.
• 각 플레이어는 보드 위에 동시에 3개의 말만 둘 수 있으며,
  4번째 말을 둔 경우 가장 오래된 말이 자동으로 사라집니다.
• 빠른 판단과 멀티태스킹 능력이 승패를 좌우합니다.
• AI도 실시간 전략을 사용하니 집중해서 플레이하세요.
''';

  static const snapDescription = '''
• 순간 틱택토는 3x3 보드에서 10초 동안 빠르게 변하는 노란 타일 위치를 주의 깊게 관찰해야 합니다.
• 원하는 위치가 번쩍일 때 ‘두기!’ 버튼을 눌러 말을 놓으세요.
• 제한 시간 안에 선택하지 못하면 턴이 자동으로 넘어갑니다.
• AI도 반응 대기 알고리즘을 사용해 공정하게 경기를 진행합니다.
• 기억력과 반응 속도를 동시에 요구하는 두뇌 퍼즐 게임입니다.
''';

  static const noTacToeDescription = '''
• 역방향 틱택토는 기존 틱택토와 달리 3개를 연결하면 패배하는 전략 퍼즐 게임입니다.
• 모든 플레이어는 같은 기호를 사용하며, 상대방이 3개 줄을 만들도록 유도하는 심리전이 중요합니다.
• 공간을 전략적으로 관리하며 실수를 피하는 플레이가 승리의 열쇠입니다.
• AI는 적절한 방어 전략으로 사용자를 도전하게 만듭니다.
''';

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // 홈 버튼
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
                        '모드 선택',
                        style: TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.w700,
                          fontFamily: 'CuteFont',
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 40),

                      CuteButton(
                        label: '스피드런',
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const GuidePage(
                                title: '스피드런',
                                description: speedrunDescription,
                                gamePage: SpeedRunPage(),
                              ),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 70),

                      CuteButton(
                        label: '순간 틱택토',
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const GuidePage(
                                title: '순간 틱택토',
                                description: snapDescription,
                                gamePage: TicTacSnapPage(),
                              ),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 70),

                      CuteButton(
                        label: '역방향 틱택토',
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const GuidePage(
                                title: '역방향 틱택토',
                                description: noTacToeDescription,
                                gamePage: NoTacToePage(),
                              ),
                            ),
                          );
                        },
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
