import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:sss_computing_client/presentation/ship_scheme_refactored/widgets/chart_axis.dart';

///
class _ChartAxisLabels {
  final ChartAxis axis;
  final List<(double, String)> labels;
  const _ChartAxisLabels({
    required this.axis,
    required this.labels,
  });
}

///
class ShipSchemeLayoutPainter extends CustomPainter {
  final ChartAxis _xAxis;
  final ChartAxis _yAxis;
  final double _minX;
  final double _maxX;
  final double _minY;
  final double _maxY;
  final double _shiftX;
  final double _scaleX;
  final double _shiftY;
  final double _scaleY;
  final Color _color;
  final TextStyle? _labelStyle;
  final double _thickness;

  ///
  const ShipSchemeLayoutPainter({
    required ChartAxis xAxis,
    required ChartAxis yAxis,
    required double maxX,
    required double minX,
    required double minY,
    required double maxY,
    required double shiftX,
    required double scaleX,
    required double shiftY,
    required double scaleY,
    required Color color,
    double thickness = 1.0,
    TextStyle? labelStyle,
  })  : _scaleY = scaleY,
        _shiftY = shiftY,
        _scaleX = scaleX,
        _shiftX = shiftX,
        _maxY = maxY,
        _minY = minY,
        _maxX = maxX,
        _minX = minX,
        _thickness = thickness,
        _color = color,
        _yAxis = yAxis,
        _xAxis = xAxis,
        _labelStyle = labelStyle,
        super();

  ///
  @override
  void paint(Canvas canvas, Size size) {
    _paintVerticalAxis(
      canvas,
      size,
      offsetLeft: 0.0,
      axisLabels: _ChartAxisLabels(
        axis: _yAxis,
        labels: _getAxisLabels(_minY, _maxY, _yAxis),
      ),
    );
    _paintHorizontalAxis(
      canvas,
      size,
      offsetBottom: 0.0,
      axisLabels: _ChartAxisLabels(
        axis: _xAxis,
        labels: _getAxisLabels(_minX, _maxX, _xAxis),
      ),
    );
  }

  ///
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }

  void _paintVerticalAxis(
    Canvas canvas,
    Size size, {
    required double offsetLeft,
    required _ChartAxisLabels axisLabels,
  }) {
    final axisColor = _color;
    final gridColor = _color.withOpacity(0.2);
    final paint = Paint()
      ..isAntiAlias = false
      ..color = axisColor
      ..strokeWidth = _thickness;
    final endX = offsetLeft + axisLabels.axis.labelsSpaceReserved;
    final centerX = offsetLeft + axisLabels.axis.labelsSpaceReserved / 2.0;
    canvas.drawLine(
      Offset(endX, 0.0),
      Offset(endX, size.height - _xAxis.labelsSpaceReserved),
      paint,
    );
    for (final label in axisLabels.labels) {
      final (offsetY, text) = label;
      final dy = (offsetY + _shiftY) * _scaleY;
      if (dy < 0.0 || dy > size.height - _xAxis.labelsSpaceReserved) continue;
      canvas.drawLine(
        Offset(
          centerX,
          dy,
        ),
        Offset(
          endX,
          dy,
        ),
        paint,
      );
      if (axisLabels.axis.isGridVisible) {
        paint.color = gridColor;
        canvas.drawLine(
          Offset(_yAxis.labelsSpaceReserved, dy),
          Offset(size.width, dy),
          paint,
        );
        paint.color = axisColor;
      }
      _paintText(
        canvas,
        text: text,
        offset: Offset(
          offsetLeft,
          (offsetY + _shiftY) * _scaleY,
        ),
        radians: -pi / 2,
      );
    }
  }

  /// Paints horizontal axis with offset from bottom
  void _paintHorizontalAxis(
    Canvas canvas,
    Size size, {
    required double offsetBottom,
    required _ChartAxisLabels axisLabels,
  }) {
    final axisColor = _color;
    final gridColor = _color.withOpacity(0.2);
    final paint = Paint()
      ..isAntiAlias = false
      ..color = axisColor
      ..strokeWidth = _thickness;
    final startY =
        size.height - offsetBottom - axisLabels.axis.labelsSpaceReserved;
    final centerY = startY + axisLabels.axis.labelsSpaceReserved / 2.0;
    canvas.drawLine(
      Offset(_yAxis.labelsSpaceReserved, startY),
      Offset(size.width, startY),
      paint,
    );
    for (final label in axisLabels.labels) {
      final (offsetX, text) = label;
      final dx = _yAxis.labelsSpaceReserved + (offsetX + _shiftX) * _scaleX;
      if (dx < _yAxis.labelsSpaceReserved || dx > size.width) continue;
      canvas.drawLine(
        Offset(
          dx,
          startY,
        ),
        Offset(
          dx,
          centerY,
        ),
        paint,
      );
      if (axisLabels.axis.isGridVisible) {
        paint.color = gridColor;
        canvas.drawLine(
          Offset(dx, 0.0),
          Offset(dx, size.height - _xAxis.labelsSpaceReserved),
          paint,
        );
        paint.color = axisColor;
      }
      _paintText(
        canvas,
        text: text,
        offset: Offset(
          _yAxis.labelsSpaceReserved + (offsetX + _shiftX) * _scaleX,
          centerY,
        ),
      );
    }
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

  /// Get multiples of [divisor] less than or equal to [max]
  List<double> _getMultiples(double divisor, double max) {
    return List<double>.generate(
      max ~/ divisor + 1,
      (idx) => (idx * divisor),
    );
  }

  ///
  List<(double, String)> _getAxisLabels(
    double minValue,
    double maxValue,
    ChartAxis axis,
  ) {
    final valueOffset = minValue.abs() % axis.valueInterval;
    return _getMultiples(
      axis.valueInterval,
      (maxValue - minValue) - axis.valueInterval,
    )
        .map((multiple) => (
              multiple + valueOffset + axis.valueInterval / 2,
              '${(minValue + multiple + valueOffset).toInt()}${axis.caption}',
            ))
        .toList();
  }
}
