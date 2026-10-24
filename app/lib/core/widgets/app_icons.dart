import 'package:flutter/material.dart';

class AirplayIcon extends StatelessWidget {
  const AirplayIcon({super.key, this.size = 20, this.color = Colors.white});

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size.square(size),
      painter: _AirplayPainter(color),
    );
  }
}

class _AirplayPainter extends CustomPainter {
  const _AirplayPainter(this.color);

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final scale = size.width / 24;
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.8 * scale
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final rect = Path()
      ..moveTo(5 * scale, 5 * scale)
      ..lineTo(19 * scale, 5 * scale)
      ..quadraticBezierTo(21 * scale, 5 * scale, 21 * scale, 7 * scale)
      ..lineTo(21 * scale, 15 * scale)
      ..lineTo(15.5 * scale, 15 * scale)
      ..lineTo(12 * scale, 20 * scale)
      ..lineTo(8.5 * scale, 15 * scale)
      ..lineTo(3 * scale, 15 * scale)
      ..lineTo(3 * scale, 7 * scale)
      ..quadraticBezierTo(3 * scale, 5 * scale, 5 * scale, 5 * scale)
      ..close();

    canvas.drawPath(rect, paint);
  }

  @override
  bool shouldRepaint(covariant _AirplayPainter oldDelegate) {
    return oldDelegate.color != color;
  }
}
