import 'package:flutter/material.dart';
import 'package:sss_computing_client/core/models/chart/chart_axis.dart';
import 'package:sss_computing_client/core/models/scheme/canvas_text_centered.dart';
///
class SchemeAxis extends StatelessWidget {
  final ChartAxis _axis;
  final Color _color;
  final double _thickness;
  final TextStyle? _labelStyle;
  final List<({double offset, String? label})>? _majorTicks;
  final List<({double offset, String? label})>? _minorTicks;
  final double Function(double) _transformValue;
  ///
  const SchemeAxis({
    super.key,
    required ChartAxis axis,
    required Color color,
    double thickness = 1.0,
    TextStyle? labelStyle,
    List<({double offset, String? label})>? majorTicks,
    List<({double offset, String? label})>? minorTicks,
    required double Function(double) transformValue,
  })  : _transformValue = transformValue,
        _axis = axis,
        _color = color,
        _labelStyle = labelStyle,
        _thickness = thickness,
        _majorTicks = majorTicks,
        _minorTicks = minorTicks;
  //
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: _axis.labelsSpaceReserved,
      child: CustomPaint(
        painter: _AxisPainter(
          axis: _axis,
          paint: Paint()
            ..color = _color
            ..strokeWidth = _thickness
            ..isAntiAlias = false,
          labelStyle: _labelStyle,
          transformValue: _transformValue,
          majorTicks: _majorTicks ?? const [],
          minorTicks: _minorTicks ?? const [],
        ),
      ),
    );
  }
}
///
class _AxisPainter extends CustomPainter {
  final ChartAxis _axis;
  final Paint _paint;
  final List<({double offset, String? label})> _majorTicks;
  final List<({double offset, String? label})> _minorTicks;
  final TextStyle? _labelStyle;
  final double Function(double) _transformValue;
  ///
  const _AxisPainter({
    required ChartAxis axis,
    required Paint paint,
    required List<({double offset, String? label})> majorTicks,
    required List<({double offset, String? label})> minorTicks,
    TextStyle? labelStyle,
    required double Function(double value) transformValue,
  })  : _axis = axis,
        _paint = paint,
        _majorTicks = majorTicks,
        _minorTicks = minorTicks,
        _labelStyle = labelStyle,
        _transformValue = transformValue,
        super();
  //
  @override
  void paint(Canvas canvas, Size size) {
    final startY = size.height - _axis.labelsSpaceReserved;
    canvas.drawLine(
      Offset(0.0, startY),
      Offset(size.width, startY),
      _paint,
    );
    for (final majorTick in _majorTicks) {
      _paintTick(
        canvas,
        size,
        offset: Offset(majorTick.offset, startY),
        height: _axis.labelsSpaceReserved / 2.0,
        label: majorTick.label,
      );
    }
    for (final minorTick in _minorTicks) {
      _paintTick(
        canvas,
        size,
        offset: Offset(minorTick.offset, startY),
        height: _axis.labelsSpaceReserved / 4.0,
      );
    }
  }
  //
  void _paintTick(
    Canvas canvas,
    Size size, {
    required Offset offset,
    required double height,
    String? label,
  }) {
    final dx = _transformValue(offset.dx);
    if (dx < 0.0 || dx > size.width) return;
    final start = Offset(dx, offset.dy);
    final end = Offset(dx, start.dy + height);
    canvas.drawLine(start, end, _paint);
    if (label == null) return;
    CanvasText(
      text: label,
      offset: end,
      align: Alignment.bottomCenter,
      style: _labelStyle,
    ).paint(canvas);
  }
  //
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
