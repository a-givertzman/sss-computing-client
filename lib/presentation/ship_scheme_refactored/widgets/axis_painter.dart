import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:sss_computing_client/presentation/core/models/chart_axis.dart';

///
class AxisPainter extends CustomPainter {
  final ChartAxis _axis;
  final double _crossAxisOffset;
  final Color _color;
  final Color? _gridColor;
  final double _thickness;
  final List<(double, String)> _majorAxisTicks;
  final List<double>? _minorAxisTicks;
  final TextStyle? _labelStyle;
  final double Function(double) _transformValue;

  ///
  const AxisPainter({
    required ChartAxis axis,
    required double crossAxisOffset,
    required Color color,
    Color? gridColor,
    double thickness = 1.0,
    required List<(double, String)> majorAxisTicks,
    List<double>? minorAxisTicks,
    TextStyle? labelStyle,
    required double Function(double) transformValue,
  })  : _transformValue = transformValue,
        _crossAxisOffset = crossAxisOffset,
        _gridColor = gridColor,
        _majorAxisTicks = majorAxisTicks,
        _minorAxisTicks = minorAxisTicks,
        _axis = axis,
        _color = color,
        _labelStyle = labelStyle,
        _thickness = thickness,
        super();

  ///
  @override
  void paint(Canvas canvas, Size size) {
    final axisPaint = Paint()
      ..isAntiAlias = false
      ..color = _color
      ..strokeWidth = _thickness;
    final gridPaint = Paint()
      ..isAntiAlias = false
      ..color = _gridColor ?? _color.withOpacity(0.25)
      ..strokeWidth = _thickness;
    final startY = size.height - _crossAxisOffset - _axis.labelsSpaceReserved;
    canvas.drawLine(
      Offset(0.0, startY),
      Offset(size.width, startY),
      axisPaint,
    );
    for (final majorTick in _majorAxisTicks) {
      final (offsetX, text) = majorTick;
      final dx = _transformValue(offsetX);
      final centerY = startY + _axis.labelsSpaceReserved / 2.0;
      if (dx < 0.0 || dx > size.width) continue;
      canvas.drawLine(Offset(dx, startY), Offset(dx, centerY), axisPaint);
      _paintText(canvas, text: text, offset: Offset(dx, centerY));
      if (_axis.isGridVisible) {
        canvas.drawLine(
          Offset(dx, 0.0),
          Offset(dx, size.height - _axis.labelsSpaceReserved),
          gridPaint,
        );
      }
    }
    if (_minorAxisTicks != null) {
      for (final minorTick in _minorAxisTicks) {
        final offsetX = minorTick;
        final dx = _transformValue(offsetX);
        if (dx < 0.0 || dx > size.width) continue;
        canvas.drawLine(
          Offset(dx, startY),
          Offset(dx, startY + _axis.labelsSpaceReserved / 4.0),
          axisPaint,
        );
      }
    }
  }

  ///
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }

  /// Paints text on canvas and rotate it if angle is specified
  void _paintText(
    canvas, {
    required String text,
    required Offset offset,
    double radians = 0.0,
  }) {
    final textPainter = TextPainter(
      text: TextSpan(text: text, style: _labelStyle),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    if (radians % (pi * 2) == 0.0) {
      textPainter.paint(
        canvas,
        Offset(offset.dx - textPainter.width / 2.0, offset.dy),
      );
    } else {
      final pivotOffset = Offset(offset.dx - textPainter.width / 2, offset.dy);
      final pivotCenter = textPainter.size.center(pivotOffset);
      canvas.save();
      canvas.translate(pivotCenter.dx, pivotCenter.dy);
      canvas.rotate(radians);
      textPainter.paint(
        canvas,
        Offset(
          pivotOffset.dx - pivotCenter.dx + textPainter.height / 2,
          pivotOffset.dy - pivotCenter.dy + textPainter.height / 2,
        ),
      );
      canvas.restore();
    }
  }
}
