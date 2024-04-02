import 'dart:math';
import 'package:flutter/material.dart';
import 'package:sss_computing_client/presentation/ship_scheme_refactored/widgets/chart_axis.dart';

///
class AxisPainter extends CustomPainter {
  final ChartAxis _axis;
  final double _crossAxisOffset;
  final Color _color;
  final Color? _gridColor;
  final double _valueShift;
  final double _valueScale;
  final double _thickness;
  final bool _reversed;
  final List<(double, String)> _majorAxisTicks;
  final List<double>? _minorAxisTicks;
  final TextStyle? _labelStyle;

  ///
  const AxisPainter({
    required ChartAxis axis,
    required double crossAxisOffset,
    required Color color,
    Color? gridColor,
    double valueShift = 0.0,
    double valueScale = 1.0,
    double thickness = 1.0,
    bool reversed = false,
    required List<(double, String)> majorAxisTicks,
    List<double>? minorAxisTicks,
    TextStyle? labelStyle,
  })  : _reversed = reversed,
        _crossAxisOffset = crossAxisOffset,
        _gridColor = gridColor,
        _majorAxisTicks = majorAxisTicks,
        _minorAxisTicks = minorAxisTicks,
        _axis = axis,
        _valueShift = valueShift,
        _valueScale = valueScale,
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
    final valueShift = _reversed
        ? (size.width - _valueShift * _valueScale) / _valueScale
        : _valueShift;
    canvas.drawLine(
      Offset(0.0, startY),
      Offset(size.width, startY),
      axisPaint,
    );
    for (final majorTick in _majorAxisTicks) {
      final (offsetX, text) = majorTick;
      final dx = _reversed
          ? size.width - (offsetX + valueShift) * _valueScale
          : (offsetX + valueShift) * _valueScale;
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
        final dx = _reversed
            ? size.width - (offsetX + valueShift) * _valueScale
            : (offsetX + valueShift) * _valueScale;
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
