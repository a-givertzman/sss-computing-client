import 'package:flutter/material.dart';
import 'package:sss_computing_client/core/models/ship_scheme/figure.dart';

///
class ShipSchemeFigure extends StatelessWidget {
  final (FigureAxis, FigureAxis) _projection;
  final Figure _figure;
  final double? _thickness;
  final Matrix4 _transform;
  final void Function()? _onTap;

  ///
  const ShipSchemeFigure({
    super.key,
    required (FigureAxis, FigureAxis) projection,
    required Figure figure,
    double? thickness,
    required Matrix4 transform,
    void Function()? onTap,
  })  : _projection = projection,
        _figure = figure,
        _thickness = thickness,
        _transform = transform,
        _onTap = onTap;

  ///
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.deferToChild,
      onTap: () {
        _onTap?.call();
      },
      child: CustomPaint(
        painter: _FigurePainter(
          projection: _projection,
          transform: _transform,
          figure: _figure,
          thickness: _thickness ?? 1.0,
        ),
        willChange: true,
      ),
    );
  }
}

///
class _FigurePainter extends CustomPainter {
  final (FigureAxis, FigureAxis) _projection;
  final Figure _figure;
  final double _thickness;
  final Matrix4 _transform;

  ///
  const _FigurePainter({
    required (FigureAxis, FigureAxis) projection,
    required Figure figure,
    required double thickness,
    required Matrix4 transform,
  })  : _projection = projection,
        _figure = figure,
        _thickness = thickness,
        _transform = transform;

  ///
  @override
  bool? hitTest(Offset position) {
    return _figure
        .getOrthoProjection(_projection.$1, _projection.$2)
        .transform(_transform.storage)
        .contains(position);
  }

  ///
  @override
  void paint(Canvas canvas, Size size) {
    final (xAxis, yAxis) = _projection;
    final path = _figure
        .getOrthoProjection(
          xAxis,
          yAxis,
        )
        .transform(_transform.storage);
    final borderColor = _figure.borderColor;
    if (borderColor != null) {
      final strokePaint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = _thickness
        ..color = borderColor
        ..isAntiAlias = true;
      canvas.drawPath(path, strokePaint);
    }
    final fillColor = _figure.fillColor;
    if (fillColor != null) {
      final fillPaint = Paint()
        ..style = PaintingStyle.fill
        ..color = fillColor
        ..isAntiAlias = true;
      canvas.drawPath(path, fillPaint);
    }
  }

  ///
  @override
  bool shouldRepaint(covariant _FigurePainter oldDelegate) {
    return (_figure != oldDelegate._figure ||
        _transform != oldDelegate._transform ||
        _projection != oldDelegate._projection);
  }
}
