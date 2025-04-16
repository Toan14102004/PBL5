import 'package:flutter/material.dart';

class ActivityRing extends StatelessWidget {
  const ActivityRing({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(200, 200),
      painter: ActivityRingPainter(),
    );
  }
}

class ActivityRingPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint ringPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 15;

    // Vòng đỏ (di chuyển)
    ringPaint.color = Colors.redAccent;
    canvas.drawArc(Rect.fromCircle(center: size.center(Offset.zero), radius: size.width / 2),
        -1.5, 3.2, false, ringPaint);

    // Vòng xanh lá (thể dục)
    ringPaint.color = Colors.greenAccent;
    canvas.drawArc(Rect.fromCircle(center: size.center(Offset.zero), radius: size.width / 2.4),
        -1.5, 2.8, false, ringPaint);

    // Vòng xanh dương (đứng)
    ringPaint.color = Colors.lightBlueAccent;
    canvas.drawArc(Rect.fromCircle(center: size.center(Offset.zero), radius: size.width / 3),
        -1.5, 2.5, false, ringPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
