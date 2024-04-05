import 'dart:ui';
import 'package:vector_math/vector_math_64.dart';

/// Used to obtain orthogonal projection onto three main planes
/// and store data about figure.
abstract interface class Figure {
  /// Border color of [Figure]
  Color? get borderColor;

  /// Fill color of [Figure]
  Color? get fillColor;

  /// Returns orthogonal projection of [Figure]
  /// onto plane parallel to X and Y axes
  List<Offset> getOrthoProjectionXY();

  /// Returns orthogonal projection of [Figure]
  /// onto plane parallel to X and Z axes
  List<Offset> getOrthoProjectionXZ();

  /// Returns orthogonal projection of [Figure]
  /// onto plane parallel to Y and Z axes
  List<Offset> getOrthoProjectionYZ();
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

  @override
  Color? get borderColor => _borderColor;

  @override
  Color? get fillColor => _fillColor;

  @override
  List<Offset> getOrthoProjectionXY() {
    final center = Vector3(_center.$1, _center.$2, _center.$3);
    final size = Vector3(_size.$1, _size.$2, _size.$3);
    final (leftOffset, rightOffset) = (center - size / 2, center + size / 2);
    return [
      Offset(leftOffset.x, rightOffset.y),
      Offset(rightOffset.x, rightOffset.y),
      Offset(rightOffset.x, leftOffset.y),
      Offset(leftOffset.x, leftOffset.y),
    ];
  }

  @override
  List<Offset> getOrthoProjectionYZ() {
    final center = Vector3(_center.$1, _center.$2, _center.$3);
    final size = Vector3(_size.$1, _size.$2, _size.$3);
    final (leftOffset, rightOffset) = (center - size / 2, center + size / 2);
    return [
      Offset(leftOffset.y, rightOffset.z),
      Offset(rightOffset.y, rightOffset.z),
      Offset(rightOffset.y, leftOffset.z),
      Offset(leftOffset.y, leftOffset.z),
    ];
  }

  @override
  List<Offset> getOrthoProjectionXZ() {
    final center = Vector3(_center.$1, _center.$2, _center.$3);
    final size = Vector3(_size.$1, _size.$2, _size.$3);
    final (leftOffset, rightOffset) = (center - size / 2, center + size / 2);
    return [
      Offset(leftOffset.x, rightOffset.z),
      Offset(rightOffset.x, rightOffset.z),
      Offset(rightOffset.x, leftOffset.z),
      Offset(leftOffset.x, leftOffset.z),
    ];
  }
}

///
class PathFigure implements Figure {
  final Color? _borderColor;
  final Color? _fillColor;
  final Map<String, List<Offset>> _pathProjection;

  ///
  const PathFigure({
    Color? borderColor,
    Color? fillColor,
    required Map<String, List<Offset>> pathProjection,
  })  : _borderColor = borderColor,
        _fillColor = fillColor,
        _pathProjection = pathProjection;

  @override
  Color? get borderColor => _borderColor;

  @override
  Color? get fillColor => _fillColor;

  @override
  List<Offset> getOrthoProjectionXY() {
    return _pathProjection['xy'] ?? [];
  }

  @override
  List<Offset> getOrthoProjectionYZ() {
    return _pathProjection['yz'] ?? [];
  }

  @override
  List<Offset> getOrthoProjectionXZ() {
    return _pathProjection['xz'] ?? [];
  }
}
