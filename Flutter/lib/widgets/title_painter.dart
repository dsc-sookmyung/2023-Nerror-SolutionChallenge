import 'package:flutter/material.dart';

class TitlePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final x = size.width;
    final y = size.height;
    const r = 50.0;

    // 1. setting path
    final upperRec = Path()
      ..moveTo(0, 0)
      ..lineTo(x, 0)
      ..lineTo(x, y - 2 * r)
      ..arcToPoint(Offset(x - r, y - r), radius: const Radius.circular(r))
      ..lineTo(x - r, y - r)
      ..lineTo(r, y - r)
      ..arcToPoint(Offset(0, y),
          radius: const Radius.circular(r), rotation: 270.0, clockwise: false)
      ..lineTo(0, y - r)
      ..lineTo(0, 0)
      ..close();

    // 2. paint setting
    final paint = Paint()
      ..color = const Color(0xe6ffffff)
      ..style = PaintingStyle.fill;

    // 3. draw
    canvas.drawPath(upperRec, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
