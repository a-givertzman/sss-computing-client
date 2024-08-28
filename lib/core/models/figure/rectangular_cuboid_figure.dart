import 'dart:ui';
import 'package:sss_computing_client/core/models/figure/figure.dart';
import 'package:vector_math/vector_math_64.dart';
///
/// Construct [Figure] of the smallest rectangular cuboid that
/// encloses the given points, treating them as vectors from the origin.
class RectangularCuboidFigure implements Figure {
  final List<Paint> _paints;
  final Vector3 _start;
  final Vector3 _end;
  ///
  /// Construct [Figure] of the smallest rectangular cuboid that
  /// encloses the given points, treating them as vectors from the origin.
  const RectangularCuboidFigure({
    List<Paint> paints = const [],
    required Vector3 start,
    required Vector3 end,
  })  : _paints = paints,
        _start = start,
        _end = end;
  ///
  /// Construct [Figure] of rectangular cuboid fromt it center point,
  /// length, width and height.
  RectangularCuboidFigure.fromCenter({
    List<Paint> paints = const [],
    required Vector3 center,
    required double length,
    required double width,
    required double height,
  }) : this(
          paints: paints,
          start: center - Vector3(length, width, height) / 2.0,
          end: center + Vector3(length, width, height) / 2.0,
        );
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
    return RectangularCuboidFigure(
      paints: paints ?? List.from(_paints),
      start: _start.clone(),
      end: _end.clone(),
    );
  }
}
