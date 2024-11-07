import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sss_computing_client/core/models/figure/figure.dart';
import 'package:sss_computing_client/core/models/figure/figure_plane.dart';
///
/// Render figure on scheme. Can handle figure tap
/// if corresponding callback has passed.
class SchemeFigure extends StatelessWidget {
  final FigurePlane _plane;
  final Figure _figure;
  final Matrix4 _layoutTransform;
  final void Function()? _onTap;
  final void Function()? _onDoubleTap;
  final void Function()? _onSecondaryTap;
  ///
  /// Render figure on scheme. Can handle figure tap
  /// if corresponding callback has passed.
  ///
  /// * [plane] – [FigurePlane] on which figure will be rendered.
  /// * [figure] - [Figure] that will be rendered.
  /// * [layoutTransform] – transformation of layout on which figure
  /// will be rendered.
  /// * [onTap] – callback for handling taps on figure.
  /// * [onDoubleTap] – callback for handling double taps on figure.
  /// * [onSecondaryTap] – callback for handling secondary taps on figure.
  const SchemeFigure({
    super.key,
    required FigurePlane plane,
    required Figure figure,
    required Matrix4 layoutTransform,
    void Function()? onTap,
    void Function()? onDoubleTap,
    void Function()? onSecondaryTap,
  })  : _plane = plane,
        _figure = figure,
        _layoutTransform = layoutTransform,
        _onTap = onTap,
        _onDoubleTap = onDoubleTap,
        _onSecondaryTap = onSecondaryTap;
  //
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.deferToChild,
      onTap: _onTap,
      onDoubleTap: _onDoubleTap,
      onSecondaryTap: _onSecondaryTap,
      child: MouseRegion(
        hitTestBehavior: HitTestBehavior.deferToChild,
        cursor: _isInteractive ? SystemMouseCursors.click : MouseCursor.defer,
        child: CustomPaint(
          painter: _SchemeFigurePainter(
            figure: _figure,
            plane: _plane,
            transform: _layoutTransform,
            isInteractive: _isInteractive,
          ),
          willChange: true,
        ),
      ),
    );
  }
  bool get _isInteractive =>
      _onTap != null || _onDoubleTap != null || _onSecondaryTap != null;
}
///
class _SchemeFigurePainter extends CustomPainter {
  final FigurePlane plane;
  final Figure figure;
  final Matrix4 transform;
  final bool isInteractive;
  ///
  const _SchemeFigurePainter({
    required this.plane,
    required this.figure,
    required this.transform,
    required this.isInteractive,
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
    return isInteractive
        ? figure
            .orthoProjection(plane)
            .transform(transform.storage)
            .contains(position)
        : null;
  }
  //
  @override
  bool shouldRepaint(covariant _SchemeFigurePainter oldDelegate) {
    return plane != oldDelegate.plane ||
        figure != oldDelegate.figure ||
        transform != oldDelegate.transform ||
        isInteractive != oldDelegate.isInteractive;
  }
}
