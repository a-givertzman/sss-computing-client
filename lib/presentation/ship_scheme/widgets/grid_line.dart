import 'package:flutter/material.dart';

///
enum Direction {
  vertical,
  horizontal,
}

///
/// Vertical or horizontal line
class GridLine extends StatelessWidget {
  final Direction _direction;
  final Color _color;
  final double _thickness;

  /// Creates vertical or horizontal line
  const GridLine({
    super.key,
    required Direction direction,
    Color color = Colors.black,
    double thickness = 1,
  })  : _direction = direction,
        _color = color,
        _thickness = thickness;

  ///
  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(
        switch (_direction) {
          Direction.vertical => _thickness,
          Direction.horizontal => double.infinity,
        },
        switch (_direction) {
          Direction.vertical => double.infinity,
          Direction.horizontal => _thickness,
        },
      ),
      painter: _GridLinePainter(
        color: _color,
        thickness: _thickness,
        direction: _direction,
      ),
    );
  }
}

///
/// Paints vertical or horizontal line on canvas
/// in the middle of the sized box
class _GridLinePainter extends CustomPainter {
  final Color _color;
  final double _thickness;
  final Direction _direction;
  const _GridLinePainter({
    required Color color,
    required double thickness,
    required Direction direction,
  })  : _color = color,
        _thickness = thickness,
        _direction = direction;

  ///
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..isAntiAlias = false
      ..color = _color
      ..strokeWidth = _thickness;
    canvas.drawLine(
      Offset(
        switch (_direction) {
          Direction.horizontal => 0,
          Direction.vertical => size.width / 2,
        },
        switch (_direction) {
          Direction.horizontal => size.height / 2,
          Direction.vertical => 0,
        },
      ),
      Offset(
        switch (_direction) {
          Direction.horizontal => size.width,
          Direction.vertical => size.width / 2,
        },
        switch (_direction) {
          Direction.horizontal => size.height / 2,
          Direction.vertical => size.height,
        },
      ),
      paint,
    );
  }

  ///
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
