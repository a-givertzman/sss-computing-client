import 'dart:ui';
import 'package:vector_math/vector_math_64.dart';

enum FigureAxis { x, y, z }

/// Used to obtain orthogonal projection onto three main planes
/// and store data about figure.
abstract interface class Figure {
  /// Border color of [Figure]
  Color? get borderColor;

  /// Fill color of [Figure]
  Color? get fillColor;

  /// Returns orthogonal projection of [Figure]
  /// onto plane parallel to axis one and two to XY-plane
  Path getOrthoProjection(FigureAxis x, FigureAxis y);
}

///
class RectFigure implements Figure {
  final Color? _borderColor;
  final Color? _fillColor;
  final (double dx, double dy, double dz) _center;
  final (double widht, double length, double height) _size;

  ///
  const RectFigure({
    Color? borderColor,
    Color? fillColor,
    double dx = 0.0,
    double dy = 0.0,
    double dz = 0.0,
    double width = 0.0,
    double length = 0.0,
    double height = 0.0,
  })  : _borderColor = borderColor,
        _fillColor = fillColor,
        _center = (dx, dy, dz),
        _size = (width, length, height);

  ///
  @override
  Color? get borderColor => _borderColor;

  ///
  @override
  Color? get fillColor => _fillColor;

  ///
  @override
  Path getOrthoProjection(FigureAxis x, FigureAxis y) {
    final center = Vector3(_center.$1, _center.$2, _center.$3);
    final size = Vector3(_size.$1, _size.$2, _size.$3);
    final (leftOffset, rightOffset) = (center - size / 2, center + size / 2);
    return Path()
      ..addPolygon(
        [
          Offset(leftOffset[x.index], rightOffset[y.index]),
          Offset(rightOffset[x.index], rightOffset[y.index]),
          Offset(rightOffset[x.index], leftOffset[y.index]),
          Offset(leftOffset[x.index], leftOffset[y.index]),
        ],
        true,
      );
  }
}

class BarellFigure implements Figure {
  final Color? _borderColor;
  final Color? _fillColor;
  final (double dx, double dy, double dz) _center;
  final (double widht, double length, double height) _size;
  final FigureAxis _axis;

  ///
  const BarellFigure({
    Color? borderColor,
    Color? fillColor,
    double dx = 0.0,
    double dy = 0.0,
    double dz = 0.0,
    double width = 0.0,
    double length = 0.0,
    double height = 0.0,
    required FigureAxis axis,
  })  : _borderColor = borderColor,
        _fillColor = fillColor,
        _center = (dx, dy, dz),
        _size = (width, length, height),
        _axis = axis;

  ///
  @override
  Color? get borderColor => _borderColor;

  ///
  @override
  Color? get fillColor => _fillColor;

  ///
  @override
  Path getOrthoProjection(FigureAxis x, FigureAxis y) {
    final center = Vector3(_center.$1, _center.$2, _center.$3);
    final size = Vector3(_size.$1, _size.$2, _size.$3);
    final (leftOffset, rightOffset) = (center - size / 2, center + size / 2);
    if (x == _axis || y == _axis) {
      return Path()
        ..addPolygon(
          [
            Offset(leftOffset[x.index], rightOffset[y.index]),
            Offset(rightOffset[x.index], rightOffset[y.index]),
            Offset(rightOffset[x.index], leftOffset[y.index]),
            Offset(leftOffset[x.index], leftOffset[y.index]),
          ],
          true,
        );
    } else {
      return Path()
        ..addOval(
          Rect.fromPoints(
            Offset(leftOffset[x.index], rightOffset[y.index]),
            Offset(rightOffset[x.index], leftOffset[y.index]),
          ),
        );
    }
  }
}

///
class PathFigure implements Figure {
  final Color? _borderColor;
  final Color? _fillColor;
  final Map<(FigureAxis, FigureAxis), List<Offset>> _pathProjection;

  ///
  const PathFigure({
    Color? borderColor,
    Color? fillColor,
    required Map<(FigureAxis, FigureAxis), List<Offset>> pathProjection,
  })  : _borderColor = borderColor,
        _fillColor = fillColor,
        _pathProjection = pathProjection;

  ///
  @override
  Color? get borderColor => _borderColor;

  ///
  @override
  Color? get fillColor => _fillColor;

  ///
  @override
  Path getOrthoProjection(FigureAxis x, FigureAxis y) {
    final projection = (x, y);
    return switch (projection) {
      (FigureAxis.x, FigureAxis.y) => Path()
        ..addPolygon(
          _pathProjection[(FigureAxis.x, FigureAxis.y)] ?? [],
          true,
        ),
      (FigureAxis.y, FigureAxis.z) => Path()
        ..addPolygon(
          _pathProjection[(FigureAxis.y, FigureAxis.z)] ?? [],
          true,
        ),
      (FigureAxis.x, FigureAxis.z) => Path()
        ..addPolygon(
          _pathProjection[(FigureAxis.x, FigureAxis.z)] ?? [],
          true,
        ),
      _ => Path(),
    };
  }
}
