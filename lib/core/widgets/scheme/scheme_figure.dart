import 'package:flutter/cupertino.dart';
import 'package:sss_computing_client/core/models/figure/figure.dart';
///
class SchemeFigure extends StatelessWidget {
  final FigurePlane _plane;
  final Figure _figure;
  final Matrix4 _layoutTransform;
  ///
  const SchemeFigure({
    super.key,
    required FigurePlane plane,
    required Figure figure,
    required Matrix4 layoutTransform,
  })  : _plane = plane,
        _figure = figure,
        _layoutTransform = layoutTransform;
  //
  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _SchemeFigurePainter(
        figure: _figure,
        plane: _plane,
        transform: _layoutTransform,
      ),
    );
  }
}
class _SchemeFigurePainter extends CustomPainter {
  final FigurePlane plane;
  final Figure figure;
  final Matrix4 transform;
  const _SchemeFigurePainter({
    required this.plane,
    required this.figure,
    required this.transform,
  });
  @override
  void paint(Canvas canvas, Size size) {
    final path = figure
        .orthoProjection(
          plane,
        )
        .transform(
          transform.storage,
        );
    for (final paint in figure.paints) {
      canvas.drawPath(path, paint);
    }
  }
  @override
  bool shouldRepaint(covariant _SchemeFigurePainter oldDelegate) {
    return plane != oldDelegate.plane ||
        figure != oldDelegate.figure ||
        transform != oldDelegate.transform;
  }
}
