import 'package:flutter/material.dart';

class CurvePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint();
    paint.color = Colors.blueAccent;
    paint.style = PaintingStyle.fill; // Change this to fill

    var path = Path();

    path.moveTo(0, size.height * 0.50);
    path.quadraticBezierTo(size.width * 0.25, size.height * 0.50,
        size.width * 0.5, size.height * 0.459);
    path.quadraticBezierTo(size.width * 0.75, size.height * 0.459,
        size.width * 1.0, size.height * 0.50);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}