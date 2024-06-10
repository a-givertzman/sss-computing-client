import 'package:flutter/material.dart';
///
class SchemeGrid extends StatelessWidget {
  final Color _color;
  final double _thickness;
  final List<double>? _offsets;
  final double Function(double) _transformValue;
  ///
  const SchemeGrid({
    super.key,
    required Color color,
    double thickness = 1.0,
    List<double>? offsets,
    required double Function(double) transformValue,
  })  : _transformValue = transformValue,
        _color = color,
        _thickness = thickness,
        _offsets = offsets;
  //
  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _GridPainter(
        paint: Paint()
          ..color = _color
          ..strokeWidth = _thickness
          ..isAntiAlias = true,
        offsets: _offsets ?? const [],
        transformValue: _transformValue,
      ),
    );
  }
}
///
class _GridPainter extends CustomPainter {
  final Paint _paint;
  final List<double> _offsets;
  final double Function(double) _transformValue;
  ///
  const _GridPainter({
    required Paint paint,
    required List<double> offsets,
    required double Function(double value) transformValue,
  })  : _paint = paint,
        _offsets = offsets,
        _transformValue = transformValue,
        super();
  //
  @override
  void paint(Canvas canvas, Size size) {
    for (final offset in _offsets) {
      _paintGridLine(
        canvas,
        size,
        offset: offset,
      );
    }
  }
  //
  void _paintGridLine(Canvas canvas, Size size, {required double offset}) {
    final dx = _transformValue(offset);
    if (dx < 0.0 || dx > size.width) return;
    final start = Offset(dx, 0.0);
    final end = Offset(dx, size.height);
    canvas.drawLine(start, end, _paint);
  }
  //
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
