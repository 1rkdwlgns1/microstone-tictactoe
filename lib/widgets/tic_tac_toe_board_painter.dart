import 'package:flutter/material.dart';

class TicTacToeBoardPainter extends CustomPainter {


  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 8
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final double cellSize = size.width / 3;

    // 가로선
    for (int i = 1; i <= 2; i++) {
      canvas.drawLine(
        Offset(0, cellSize * i),
        Offset(size.width, cellSize * i),
        paint,
      );
    }

    // 세로선
    for (int i = 1; i <= 2; i++) {
      canvas.drawLine(
        Offset(cellSize * i, 0),
        Offset(cellSize * i, size.height),
        paint,
      );
    }

    const double paddingRatio = 0.17; // 간격 비율 (조절 가능)

    final double offset = cellSize * paddingRatio;

    // 첫 번째 줄 X
    _drawCuteX(canvas, cellSize * 0 + cellSize / 2, cellSize * 0 + cellSize / 2, cellSize * (0.5 - paddingRatio));

    // 첫 번째 줄 O
    _drawO(canvas, cellSize * 1 + cellSize / 2, cellSize * 0 + cellSize / 2, cellSize * (0.5 - paddingRatio));

    // 두 번째 줄 O
    _drawO(canvas, cellSize * 1 + cellSize / 2, cellSize * 1 + cellSize / 2, cellSize * (0.5 - paddingRatio));

    // 두 번째 줄 X
    _drawCuteX(canvas, cellSize * 2 + cellSize / 2, cellSize * 1 + cellSize / 2, cellSize * (0.5 - paddingRatio));

    // 세 번째 줄 O
    _drawO(canvas, cellSize * 2 + cellSize / 2, cellSize * 2 + cellSize / 2, cellSize * (0.5 - paddingRatio));
  }

  void _drawCuteX(Canvas canvas, double cx, double cy, double size) {
    final path = Path();

    // 살짝 휘어진 X 그리기 (베지어 곡선 사용)
    path.moveTo(cx - size, cy - size);
    path.quadraticBezierTo(cx - size * 0.5, cy - size * 0.3, cx + size, cy + size);

    path.moveTo(cx - size, cy + size);
    path.quadraticBezierTo(cx - size * 0.5, cy + size * 0.3, cx + size, cy - size);

    final paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 9
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawPath(path, paint);
  }


  void _drawO(Canvas canvas, double cx, double cy, double radius) {
    final paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 9
      ..style = PaintingStyle.stroke;

    canvas.drawCircle(Offset(cx, cy), radius, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
