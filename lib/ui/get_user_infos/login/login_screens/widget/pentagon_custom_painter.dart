import 'package:flutter/material.dart';

class PentagonPainter extends CustomPainter {
  final Color color;
  final bool isCurrentIndex;
  PentagonPainter(this.color, this.isCurrentIndex);
  @override
  void paint(Canvas canvas, Size size) {
    final path = Path();
    path.moveTo(0, 0);
    path.lineTo(0, size.height);
    path.lineTo((size.width / 3) * 2, size.height);
    path.lineTo(size.width, size.height / 2);
    path.lineTo((size.width / 3) * 2, 0);

    path.close();

    final paint = Paint()
      ..color = isCurrentIndex ? color : Colors.grey
      ..style = PaintingStyle.fill;
    final paint1 = Paint()
      ..color = Colors.amber
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;
    canvas.drawPath(path, paint);
    if (isCurrentIndex) {
      canvas.drawPath(path, paint1);
    }
  }

  @override
  bool shouldRepaint(PentagonPainter oldDelegate) => false;
}
