import 'dart:math';
import 'package:flutter/material.dart';
import 'package:sss_computing_client/core/models/ship_scheme/chart_axis.dart';
///
class ShipSchemeFramesTheoretic extends StatelessWidget {
  final ChartAxis _axis;
  final Color _color;
  final double _thickness;
  final TextStyle? _labelStyle;
  final List<(double, double, int)> _frames;
  final double Function(double) _transformValue;
  ///
  const ShipSchemeFramesTheoretic({
    super.key,
    required ChartAxis axis,
    required Color color,
    double thickness = 1.0,
    TextStyle? labelStyle,
    required List<(double, double, int)> frames,
    required double Function(double) transformValue,
  })  : _axis = axis,
        _color = color,
        _thickness = thickness,
        _labelStyle = labelStyle,
        _frames = frames,
        _transformValue = transformValue;
  //
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: _axis.labelsSpaceReserved,
      child: CustomPaint(
        painter: _AxisPainter(
          axis: _axis,
          color: _color,
          thickness: _thickness,
          labelStyle: _labelStyle,
          transformValue: _transformValue,
          frames: _frames,
        ),
      ),
    );
  }
}
///
class _AxisPainter extends CustomPainter {
  final ChartAxis _axis;
  final Color _color;
  final double _thickness;
  final List<(double, double, int)> _frames;
  final TextStyle? _labelStyle;
  final double Function(double) _transformValue;
  ///
  const _AxisPainter({
    required ChartAxis axis,
    required Color color,
    double thickness = 1.0,
    required List<(double, double, int)> frames,
    TextStyle? labelStyle,
    required double Function(double) transformValue,
  })  : _axis = axis,
        _color = color,
        _thickness = thickness,
        _labelStyle = labelStyle,
        _frames = frames,
        _transformValue = transformValue,
        super();
  //
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..isAntiAlias = false
      ..color = _color
      ..strokeWidth = _thickness;
    final dyStart = size.height - _axis.labelsSpaceReserved;
    for (final frame in _frames) {
      final (offsetLeft, offsetRight, idx) = frame;
      final dxLeft = _transformValue(offsetLeft);
      final dxRight = _transformValue(offsetRight);
      final dxCenter = (dxLeft + dxRight) / 2.0;
      final dyEnd = dyStart + _axis.labelsSpaceReserved;
      if (dxCenter < 0.0 || dxCenter > size.width) continue;
      canvas.drawLine(Offset(dxLeft, dyStart), Offset(dxLeft, dyEnd), paint);
      canvas.drawLine(Offset(dxRight, dyStart), Offset(dxRight, dyEnd), paint);
      _paintText(
        canvas,
        text: '$idx${_axis.caption}',
        offset: Offset(dxCenter, dyStart),
      );
    }
  }
  //
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
