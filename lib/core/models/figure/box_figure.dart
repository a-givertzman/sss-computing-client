import 'dart:ui';
import 'package:sss_computing_client/core/models/figure/figure.dart';
import 'package:vector_math/vector_math_64.dart';
///
/// Construct [Figure] of the smallest rectangular cuboid that
/// encloses the given points, treating them as vectors from the origin.
class RectangularCuboid implements Figure {
  final Vector3 _start;
  final Vector3 _end;
  final List<Paint> _paints;
  ///
  ///  Construct [Figure] of the smallest rectangular cuboid that
  /// encloses the given points, treating them as vectors from the origin.
  const RectangularCuboid({
    required Vector3 start,
    required Vector3 end,
    required List<Paint> paints,
  })  : _start = start,
        _end = end,
        _paints = paints;
  //
  @override
  List<Paint> get paints => _paints;
  //
  @override
  Path orthoProjection(FigurePlane plane) {
    return switch (plane) {
      FigurePlane.xy => Path()
        ..addRect(Rect.fromPoints(
          Offset(_start.x, _start.y),
          Offset(_end.x, _end.y),
        )),
      FigurePlane.xz => Path()
        ..addRect(Rect.fromPoints(
          Offset(_start.x, _start.z),
          Offset(_end.x, _end.z),
        )),
      FigurePlane.yz => Path()
        ..addRect(Rect.fromPoints(
          Offset(_start.y, _start.z),
          Offset(_end.y, _end.z),
        )),
    };
  }
  //
  @override
  Figure copyWith({List<Paint>? paints}) {
    return RectangularCuboid(
      start: _start,
      end: _end,
      paints: paints ?? _paints,
    );
  }
}
