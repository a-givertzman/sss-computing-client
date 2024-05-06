import 'package:flutter/material.dart';
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
  /// onto plane parallel to axes one and two
  Path getOrthoProjection(FigureAxis x, FigureAxis y);

  /// Returns copy of [Figure]
  Figure copyWith({Color? borderColor, Color? fillColor});
}

///
class RectFigure implements Figure {
  final Color? _borderColor;
  final Color? _fillColor;
  final (double dx, double dy, double dz) _point1;
  final (double dx, double dy, double dz) _point2;

  ///
  const RectFigure({
    Color? borderColor,
    Color? fillColor,
    double dx1 = 0.0,
    double dy1 = 0.0,
    double dz1 = 0.0,
    double dx2 = 0.0,
    double dy2 = 0.0,
    double dz2 = 0.0,
  })  : _borderColor = borderColor,
        _fillColor = fillColor,
        _point1 = (dx1, dy1, dz1),
        _point2 = (dx2, dy2, dz2);

  ///
  @override
  Color? get borderColor => _borderColor;

  ///
  @override
  Color? get fillColor => _fillColor;

  ///
  @override
  Path getOrthoProjection(FigureAxis x, FigureAxis y) {
    final point1 = Vector3(_point1.$1, _point1.$2, _point1.$3);
    final point2 = Vector3(_point2.$1, _point2.$2, _point2.$3);
    return Path()
      ..addRect(Rect.fromPoints(
        Offset(point1[x.index], point1[y.index]),
        Offset(point2[x.index], point2[y.index]),
      ));
  }

  /// TODO: remove
  @override
  String toString() {
    final point1 = Vector3(_point1.$1, _point1.$2, _point1.$3);
    final point2 = Vector3(_point2.$1, _point2.$2, _point2.$3);
    final (center, size) = ((point1 + point2) / 2, (point2 - point1));
    return '''\n
      center: $center ,
      size: $size,
      x1, x2: ($point1.x, $point2.x)
      y1, y2: ($point1.y, $point2.y)
      z1, z2: ($point1.z, $point2.z)
    ''';
  }

  ///
  @override
  Figure copyWith({Color? borderColor, Color? fillColor}) {
    return RectFigure(
      borderColor: borderColor ?? _borderColor,
      fillColor: fillColor ?? _fillColor,
      dx1: _point1.$1,
      dy1: _point1.$2,
      dz1: _point1.$3,
      dx2: _point2.$1,
      dy2: _point2.$2,
      dz2: _point2.$3,
    );
  }
}

class BoundedFigure implements Figure {
  final Figure _figure;
  final Figure _bounder;

  ///
  const BoundedFigure({
    required Figure figure,
    required Figure bounder,
  })  : _figure = figure,
        _bounder = bounder;

  ///
  @override
  Color? get borderColor => _figure.borderColor;

  ///
  @override
  Color? get fillColor => _figure.fillColor;

  ///
  @override
  Path getOrthoProjection(FigureAxis x, FigureAxis y) {
    return Path.combine(
      PathOperation.intersect,
      _figure.getOrthoProjection(x, y),
      _bounder.getOrthoProjection(x, y),
    );
  }

  ///
  @override
  String toString() {
    return _figure.toString();
  }

  ///
  @override
  Figure copyWith({Color? borderColor, Color? fillColor}) {
    return BoundedFigure(
      figure: _figure.copyWith(
        borderColor: borderColor,
        fillColor: fillColor,
      ),
      bounder: _bounder,
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

  ///
  @override
  Figure copyWith({Color? borderColor, Color? fillColor}) {
    return BarellFigure(
      borderColor: borderColor ?? _borderColor,
      fillColor: fillColor ?? _fillColor,
      dx: _center.$1,
      dy: _center.$2,
      dz: _center.$3,
      width: _size.$1,
      length: _size.$2,
      height: _size.$3,
      axis: _axis,
    );
  }
}

class WaterineFigure implements Figure {
  final Color? _borderColor;
  final Color? _fillColor;
  final Offset _begin;
  final Offset _end;
  final (FigureAxis, FigureAxis) _axes;

  ///
  const WaterineFigure({
    Color? borderColor,
    Color? fillColor,
    required Offset begin,
    required Offset end,
    required (FigureAxis, FigureAxis) axes,
  })  : _borderColor = borderColor,
        _fillColor = fillColor,
        _begin = begin,
        _end = end,
        _axes = axes;

  ///
  @override
  Color? get borderColor => _borderColor;

  ///
  @override
  Color? get fillColor => _fillColor ?? _borderColor?.withOpacity(0.15);

  ///
  @override
  Path getOrthoProjection(FigureAxis x, FigureAxis y) {
    final height = _end.dx - _begin.dx;
    if (_axes.$1 == x && _axes.$2 == y) {
      return Path()
        ..addPolygon(
          [
            _begin, _end, //
            _end.translate(0.0, -height), _begin.translate(0.0, -height), //
          ],
          true,
        );
    }
    if (_axes.$1 == y && _axes.$2 == x) {
      final beginTranspose = Offset(_begin.dy, _begin.dx);
      final endTranspose = Offset(_end.dy, _end.dx);
      return Path()
        ..addPolygon(
          [
            beginTranspose, endTranspose, //
            endTranspose.translate(-height, 0.0),
            beginTranspose.translate(-height, 0.0),
          ],
          true,
        );
    }
    return Path();
  }

  @override
  Figure copyWith({Color? borderColor, Color? fillColor}) {
    return WaterineFigure(
      borderColor: borderColor ?? _borderColor,
      fillColor: fillColor ?? _fillColor,
      begin: _begin,
      end: _end,
      axes: _axes,
    );
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

  ///
  @override
  Figure copyWith({Color? borderColor, Color? fillColor}) {
    return PathFigure(
      borderColor: borderColor ?? _borderColor,
      fillColor: fillColor ?? _fillColor,
      pathProjection: _pathProjection,
    );
  }
}
