import 'package:flutter/material.dart';
import 'package:sss_computing_client/presentation/core/models/ship_scheme/figure.dart';

///
class ShipSchemeFigure extends StatelessWidget {
  // for tests TODO: remove
  final String projection;
  //
  final Figure _figure;
  final double? _thickness;
  final double Function(double)? _transformX;
  final double Function(double)? _transformY;

  ///
  const ShipSchemeFigure({
    super.key,
    required this.projection,
    required Figure figure,
    double? thickness,
    double Function(double)? transformX,
    double Function(double)? transformY,
  })  : _figure = figure,
        _thickness = thickness,
        _transformX = transformX,
        _transformY = transformY;

  ///
  // @override
  // void initState() {
  //   _figurePath = Path();
  //   _figurePath.addPolygon(
  //     widget._figure.getOrthoProjectionXY(),
  //     true,
  //   );
  //   super.initState();
  // }

  ///
  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _FigurePainter(
        // path: _figurePath,
        // borderColor: widget._figure.borderColor,
        // fillColor: widget._figure.fillColor,
        projection: projection,
        figure: _figure,
        thickness: _thickness ?? 1.0,
        transformX: _transformX ?? _defaultTransform,
        transformY: _transformY ?? _defaultTransform,
      ),
    );
  }
}

///
double _defaultTransform(double value) {
  return value;
}

///
class _FigurePainter extends CustomPainter {
  // final Path _path;
  // final Color? _borderColor;
  // final Color? _fillColor;
  // for tests TODO: remove
  final String projection;
  //
  final Figure _figure;
  final double _thickness;
  final double Function(double) _transformX;
  final double Function(double) _transformY;

  ///
  const _FigurePainter({
    // required Path path,
    // Color? borderColor,
    // Color? fillColor,
    required this.projection,
    required Figure figure,
    required double thickness,
    required double Function(double) transformX,
    required double Function(double) transformY,
  })  :
        // _path = path,
        // _borderColor = borderColor,
        // _fillColor = fillColor,
        _figure = figure,
        _thickness = thickness,
        _transformX = transformX,
        _transformY = transformY;

  @override
  void paint(Canvas canvas, Size size) {
    final rawProjection = switch (projection) {
      'xy' => _figure.getOrthoProjectionXY(),
      'xz' => _figure.getOrthoProjectionXZ(),
      'yz' => _figure.getOrthoProjectionYZ(),
      _ => [],
    };
    final transformedProjection = rawProjection.map((offset) {
      final Offset(:dx, :dy) = offset;
      return Offset(_transformX(dx), _transformY(dy));
    }).toList();
    final path = Path()..addPolygon(transformedProjection, true);
    final borderColor = _figure.borderColor;
    if (borderColor != null) {
      final strokePaint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = _thickness
        ..color = borderColor
        ..isAntiAlias = false;
      canvas.drawPath(path, strokePaint);
    }
    final fillColor = _figure.fillColor;
    if (fillColor != null) {
      final fillPaint = Paint()
        ..style = PaintingStyle.fill
        ..color = fillColor
        ..isAntiAlias = false;
      canvas.drawPath(path, fillPaint);
    }
  }

  ///
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
