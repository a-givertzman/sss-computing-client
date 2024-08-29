import 'dart:ui';
import 'package:sss_computing_client/core/models/figure/figure.dart';
import 'package:sss_computing_client/core/models/figure/figure_plane.dart';
import 'package:vector_math/vector_math_64.dart';
///
/// Construct [Figure] by transforming another
/// using geometric transformations.
class TransformedProjectionFigure implements Figure {
  final Figure _figure;
  final Matrix4 _transform;
  ///
  /// Construct [Figure] by transforming another
  /// using geometric transformations.
  const TransformedProjectionFigure({
    required Figure figure,
    required Matrix4 transform,
  })  : _figure = figure,
        _transform = transform;
  //
  @override
  List<Paint> get paints => _figure.paints;
  //
  @override
  Path orthoProjection(FigurePlane plane) {
    return _figure.orthoProjection(plane).transform(_transform.storage);
  }
  //
  @override
  Figure copyWith({List<Paint>? paints}) {
    return TransformedProjectionFigure(
      figure: _figure.copyWith(paints: paints),
      transform: _transform.clone(),
    );
  }
}
