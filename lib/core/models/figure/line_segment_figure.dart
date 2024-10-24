import 'package:flutter/material.dart';
import 'package:sss_computing_client/core/models/figure/figure.dart';
import 'package:sss_computing_client/core/models/figure/figure_plane.dart';
///
/// Construct [Figure] of line segment between points,
/// treating them as vectors from the origin.
class LineSegmentFigure implements Figure {
  final List<Paint> _paints;
  final Offset _start;
  final Offset _end;
  ///
  /// Construct [Figure] of line segment between points,
  /// treating them as vectors from the origin.
  const LineSegmentFigure({
    List<Paint> paints = const [],
    required Offset start,
    required Offset end,
  })  : _paints = paints,
        _start = start,
        _end = end;
  //
  @override
  List<Paint> get paints => _paints;
  //
  @override
  Path orthoProjection(FigurePlane plane) {
    return Path()
      ..moveTo(_start.dx, _start.dy)
      ..lineTo(_end.dx, _end.dy);
  }
  //
  @override
  Figure copyWith({List<Paint>? paints}) {
    return LineSegmentFigure(
      paints: paints ?? List.from(_paints),
      start: Offset(_start.dx, _start.dy),
      end: Offset(_end.dx, _end.dy),
    );
  }
}
