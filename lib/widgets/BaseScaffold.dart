import 'package:flutter/material.dart';

class BaseScaffold extends StatelessWidget {
  final Widget body;
  final PreferredSizeWidget? appBar;
  final Color backgroundColor;

  /// 풋터(저작권) 고정 높이
  final double footerHeight;

  /// 표시할 텍스트
  final String copyright;

  const BaseScaffold({
    super.key,
    required this.body,
    this.appBar,
    this.backgroundColor = Colors.white,
    this.footerHeight = 22.5,                         // ← 여기서 높이 지정
    this.copyright = '© 2025 신한대학교 구름팀',
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      backgroundColor: backgroundColor,
      body: Column(
        children: [
          // 본문은 남은 공간만 사용
          Expanded(child: body),

          // 고정 높이 풋터 + 하단 SafeArea
          SafeArea(
            top: false,
            child: SizedBox(
              height: footerHeight,
              child: Center(
                child: Text(
                  copyright,
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
