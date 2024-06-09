import 'package:flutter/cupertino.dart';
import 'package:sss_computing_client/core/models/figure/figure.dart';
///
/// Render figure on scheme. Can handle figure tap
/// if corresponding callback has passed.
class SchemeFigure extends StatelessWidget {
  final FigurePlane _plane;
  final Figure _figure;
  final Matrix4 _layoutTransform;
  final void Function()? _onTap;
  ///
  /// Render figure on scheme. Can handle figure tap
  /// if corresponding callback has passed.
  ///
  /// `plane` - [FigurePlane] on which figure will be rendred.
  /// `figure` - which will be rendered.
  /// `layoutTransform` - transformation of layout on which figure
  /// will be rendered.
  /// `onTap` - callback for handling taps on figure.
  const SchemeFigure({
    super.key,
    required FigurePlane plane,
    required Figure figure,
    required Matrix4 layoutTransform,
    void Function()? onTap,
  })  : _plane = plane,
        _figure = figure,
        _layoutTransform = layoutTransform,
        _onTap = onTap;
  //
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.deferToChild,
      onTap: _onTap,
      child: MouseRegion(
        hitTestBehavior: HitTestBehavior.deferToChild,
        cursor: _onTap != null ? SystemMouseCursors.click : MouseCursor.defer,
        child: CustomPaint(
          painter: _SchemeFigurePainter(
            figure: _figure,
            plane: _plane,
            transform: _layoutTransform,
            onTap: _onTap,
          ),
          willChange: true,
        ),
      ),
    );
  }
}
///
class _SchemeFigurePainter extends CustomPainter {
  final FigurePlane plane;
  final Figure figure;
  final Matrix4 transform;
  final void Function()? onTap;
  ///
  const _SchemeFigurePainter({
    required this.plane,
    required this.figure,
    required this.transform,
    required this.onTap,
  });
  //
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
  //
  @override
  bool? hitTest(Offset position) {
    return switch (onTap) {
      null => null,
      final _ => figure
          .orthoProjection(plane)
          .transform(transform.storage)
          .contains(position),
    };
  }
  //
  @override
  bool shouldRepaint(covariant _SchemeFigurePainter oldDelegate) {
    return plane != oldDelegate.plane ||
        figure != oldDelegate.figure ||
        transform != oldDelegate.transform ||
        onTap != oldDelegate.onTap;
  }
}
