import 'package:flutter/material.dart';
import 'package:intl/intl.dart' show DateFormat;

import '../../../core/theme/app_colors.dart';
import '../domain/live_mandi_price.dart';

/// Simple line chart of the modal price with the min–max range shaded.
/// Drawn by hand to avoid a charting dependency on low-end phones.
class PriceLineChart extends StatelessWidget {
  const PriceLineChart({required this.points, super.key});

  final List<MandiHistoryPoint> points;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      width: double.infinity,
      child: CustomPaint(
        painter: _ChartPainter(
          points: points,
          line: AppColors.primary,
          band: AppColors.primary.withValues(alpha: 0.12),
          grid: AppColors.border,
          text: AppColors.textSecondary,
        ),
      ),
    );
  }
}

class _ChartPainter extends CustomPainter {
  _ChartPainter({required this.points, required this.line, required this.band, required this.grid, required this.text});

  final List<MandiHistoryPoint> points;
  final Color line;
  final Color band;
  final Color grid;
  final Color text;

  static const _left = 48.0;
  static const _bottom = 22.0;
  static const _top = 8.0;

  @override
  void paint(Canvas canvas, Size size) {
    if (points.isEmpty) return;
    final lows = points.map((p) => p.minPrice > 0 ? p.minPrice : p.modalPrice);
    final highs = points.map((p) => p.maxPrice > 0 ? p.maxPrice : p.modalPrice);
    var minY = lows.reduce((a, b) => a < b ? a : b);
    var maxY = highs.reduce((a, b) => a > b ? a : b);
    if (maxY - minY < 1) {
      minY -= 1;
      maxY += 1;
    }
    final chart = Rect.fromLTRB(_left, _top, size.width - 8, size.height - _bottom);

    double x(int i) => points.length == 1 ? chart.center.dx : chart.left + chart.width * i / (points.length - 1);
    double y(double v) => chart.bottom - chart.height * (v - minY) / (maxY - minY);

    final gridPaint = Paint()
      ..color = grid
      ..strokeWidth = 1;
    for (var i = 0; i <= 3; i++) {
      final value = minY + (maxY - minY) * i / 3;
      final gy = y(value);
      canvas.drawLine(Offset(chart.left, gy), Offset(chart.right, gy), gridPaint);
      _label(canvas, '₹${value.round()}', Offset(0, gy - 6), width: _left - 6, align: TextAlign.right);
    }

    if (points.length > 1) {
      final bandPath = Path()..moveTo(x(0), y(highs.first));
      for (var i = 1; i < points.length; i++) {
        bandPath.lineTo(x(i), y(highs.elementAt(i)));
      }
      for (var i = points.length - 1; i >= 0; i--) {
        bandPath.lineTo(x(i), y(lows.elementAt(i)));
      }
      canvas.drawPath(bandPath..close(), Paint()..color = band);

      final linePath = Path()..moveTo(x(0), y(points.first.modalPrice));
      for (var i = 1; i < points.length; i++) {
        linePath.lineTo(x(i), y(points[i].modalPrice));
      }
      canvas.drawPath(
        linePath,
        Paint()
          ..color = line
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2.5
          ..strokeJoin = StrokeJoin.round,
      );
    }
    final dot = Paint()..color = line;
    for (var i = 0; i < points.length; i++) {
      canvas.drawCircle(Offset(x(i), y(points[i].modalPrice)), points.length > 15 ? 2 : 3.5, dot);
    }

    final fmt = DateFormat('d MMM');
    _label(canvas, fmt.format(points.first.date), Offset(chart.left - 8, size.height - 16), width: 70);
    if (points.length > 1) {
      _label(canvas, fmt.format(points.last.date), Offset(chart.right - 62, size.height - 16), width: 70, align: TextAlign.right);
    }
  }

  void _label(Canvas canvas, String s, Offset at, {required double width, TextAlign align = TextAlign.left}) {
    final painter = TextPainter(
      text: TextSpan(text: s, style: TextStyle(color: text, fontSize: 10)),
      textAlign: align,
      textDirection: TextDirection.ltr,
    )..layout(minWidth: width, maxWidth: width);
    painter.paint(canvas, at);
  }

  @override
  bool shouldRepaint(_ChartPainter old) => old.points != points;
}
