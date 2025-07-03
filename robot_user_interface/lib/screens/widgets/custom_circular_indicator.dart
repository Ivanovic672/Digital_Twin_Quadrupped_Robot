import 'dart:math';
import 'package:flutter/material.dart';
import 'package:robot_user_interface/app_styles.dart';

class SemiCircularIndicator extends StatelessWidget {
  final double value;
  final double radius;
  final double strokeWidth;
  final List<double>? thresholds;

  const SemiCircularIndicator({
    super.key,
    required this.value,
    this.radius = 100,
    this.strokeWidth = 8,
    this.thresholds,
  });

  @override
  Widget build(BuildContext context) {
    Color? color;

    if (thresholds == null) {
      color = AppStyles.generalColors['success'];
    } else if (thresholds!.length == 1) {
      if (value.abs() > thresholds![0]) {
        color = AppStyles.generalColors['cancel'];
      } else {
        color = AppStyles.generalColors['success'];
      }
    } else if (thresholds!.length == 2) {
      if (value.abs() > thresholds![1]) {
        color = AppStyles.generalColors['cancel'];
      } else if (value.abs() > thresholds![0]) {
        color = AppStyles.generalColors['details'];
      } else {
        color = AppStyles.generalColors['success'];
      }
    }

    return Stack(children: [
      Center(
        child: CustomPaint(
          size: Size(radius * 2, radius),
          painter: _SemiCircularPainter(
            value: value,
            color: color!,
            strokeWidth: strokeWidth,
          ),
        ),
      ),
      Align(
        alignment: Alignment.bottomCenter,
        child: Text(
          '$value',
          style: AppStyles.textStyleH3(
            textColor: AppStyles.textColors['primary'],
          ),
          textAlign: TextAlign.center,
        ),
      )
    ]);
  }
}

class _SemiCircularPainter extends CustomPainter {
  final double value;
  final Color color;
  final double strokeWidth;

  _SemiCircularPainter({
    required this.value,
    required this.color,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height);
    final radius = size.width / 2;

    final backgroundPaint = Paint()
      ..color = color.withOpacity(0.2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    final foregroundPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    // Dibuja la semicircunferencia superior
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      pi, // 180 grados
      pi, // 180 grados
      false,
      backgroundPaint,
    );

    // Dibuja el progreso
    //final sweepAngle = pi * value.abs();
    // final startAngle = 1 / 2 * pi; // Comienza desde la izquierda
    // final sweepAngle = pi / 4;
    final sweepAngle = (value.abs() < 90.0) ? value * pi / 180 : pi / 2;
    final startAngle = 3 * pi / 2; // Comienza desde la izquierda

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      // value >= 0 ? sweepAngle : -sweepAngle,
      sweepAngle,
      false,
      foregroundPaint,
    );

    // Dibuja la flecha al final
    // final endAngle = startAngle + (value >= 0 ? sweepAngle : -sweepAngle);
    final endAngle = startAngle + sweepAngle;
    final arrowLength = 5.0;
    final arrowAngle = pi / 4; // 30 grados

    final arrowX = center.dx + radius * cos(endAngle);
    final arrowY = center.dy + radius * sin(endAngle);
    final arrowTip = Offset(arrowX, arrowY);
    final offsetAdjust = (sweepAngle >= 0 ? pi / 2 : -pi / 2);

    final path = Path();
    path.moveTo(arrowTip.dx, arrowTip.dy);
    path.lineTo(
      arrowTip.dx - arrowLength * cos(endAngle - arrowAngle + offsetAdjust),
      arrowTip.dy - arrowLength * sin(endAngle - arrowAngle + offsetAdjust),
    );
    path.moveTo(arrowTip.dx, arrowTip.dy);
    path.lineTo(
      arrowTip.dx - arrowLength * cos(endAngle + arrowAngle + offsetAdjust),
      arrowTip.dy - arrowLength * sin(endAngle + arrowAngle + offsetAdjust),
    );

    canvas.drawPath(path, foregroundPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
