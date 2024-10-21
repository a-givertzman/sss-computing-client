import 'package:flutter/material.dart';
import 'package:sss_computing_client/core/models/figure/figure.dart';
import 'package:sss_computing_client/core/models/figure/figure_plane.dart';
import 'package:vector_math/vector_math_64.dart';
///
/// Construct [Figure] of line segment between points in 3D space,
/// treating them as vectors from the origin.
class LineSegment3DFigure implements Figure {
  final List<Paint> _paints;
  final Vector3 _start;
  final Vector3 _end;
  ///
  /// Construct [Figure] of line segment between points in 3D space,
  /// treating them as vectors from the origin.
  const LineSegment3DFigure({
    List<Paint> paints = const [],
    required Vector3 start,
    required Vector3 end,
  })  : _paints = paints,
        _start = start,
        _end = end;
  //
  @override
  List<Paint> get paints => _paints;
  //
  @override
  Path orthoProjection(FigurePlane plane) {
    return switch (plane) {
      FigurePlane.xy => Path()
        ..moveTo(_start.x, _start.y)
        ..lineTo(_end.x, _end.y),
      FigurePlane.xz => Path()
        ..moveTo(_start.x, _start.z)
        ..lineTo(_end.x, _end.z),
      FigurePlane.yz => Path()
        ..moveTo(_start.y, _start.z)
        ..lineTo(_end.y, _end.z),
    };
  }
  //
  @override
  Figure copyWith({List<Paint>? paints}) {
    return LineSegment3DFigure(
      paints: paints ?? List.from(_paints),
      start: _start.clone(),
      end: _end.clone(),
    );
  }
}
