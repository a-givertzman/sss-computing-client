import 'package:flutter/material.dart';
///
class ShipSchemeGrid extends StatelessWidget {
  final Color _color;
  final double _thickness;
  final List<double> _axisGrid;
  final double Function(double) _transformValue;
  ///
  const ShipSchemeGrid({
    super.key,
    required Color color,
    double thickness = 1.0,
    required List<double> axisGrid,
    required double Function(double) transformValue,
  })  : _transformValue = transformValue,
        _color = color,
        _thickness = thickness,
        _axisGrid = axisGrid;
  //
  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _GridPainter(
        color: _color,
        thickness: _thickness,
        transformValue: _transformValue,
        axisGrid: _axisGrid,
      ),
    );
  }
}
///
class _GridPainter extends CustomPainter {
  final Color _color;
  final double _thickness;
  final List<double> _axisGrid;
  final double Function(double) _transformValue;
  ///
  const _GridPainter({
    required Color color,
    double thickness = 1.0,
    required List<double> axisGrid,
    required double Function(double) transformValue,
  })  : _transformValue = transformValue,
        _axisGrid = axisGrid,
        _color = color,
        _thickness = thickness,
        super();
  //
  @override
  void paint(Canvas canvas, Size size) {
    final axisPaint = Paint()
      ..isAntiAlias = false
      ..color = _color
      ..strokeWidth = _thickness;
    for (final lineOffset in _axisGrid) {
      final dx = _transformValue(lineOffset);
      if (dx < 0.0 || dx > size.width) continue;
      canvas.drawLine(Offset(dx, 0.0), Offset(dx, size.height), axisPaint);
    }
  }
  //
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
