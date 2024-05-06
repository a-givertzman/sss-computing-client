import 'package:flutter/material.dart';
import 'package:path_drawing/path_drawing.dart';
import 'package:vector_math/vector_math_64.dart' hide Colors;
enum FigureAxes { x, y, z }
/// Used to obtain orthogonal projection onto three main planes
/// and store data about figure.
abstract interface class Figure {
  /// Border color of [Figure]
  Color? get borderColor;
  /// Fill color of [Figure]
  Color? get fillColor;
  /// Returns orthogonal projection of [Figure]
  /// onto plane parallel to axes one and two
  Path getOrthoProjection(FigureAxes x, FigureAxes y);
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
  //
  @override
  Color? get borderColor => _borderColor;
  //
  @override
  Color? get fillColor => _fillColor;
  //
  @override
  Path getOrthoProjection(FigureAxes x, FigureAxes y) {
    final point1 = Vector3(_point1.$1, _point1.$2, _point1.$3);
    final point2 = Vector3(_point2.$1, _point2.$2, _point2.$3);
    return Path()
      ..addRect(Rect.fromPoints(
        Offset(point1[x.index], point1[y.index]),
        Offset(point2[x.index], point2[y.index]),
      ));
  }
  //
  @override
  Figure copyWith({Color? borderColor, Color? fillColor}) {
    return RectFigure(
      borderColor: borderColor ?? _borderColor,
      fillColor: fillColor ?? _fillColor,
      dx1: _point1.$1, dx2: _point2.$1, //
      dy1: _point1.$2, dy2: _point2.$2, //
      dz1: _point1.$3, dz2: _point2.$3, //
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
  //
  @override
  Color? get borderColor => _figure.borderColor;
  //
  @override
  Color? get fillColor => _figure.fillColor;
  //
  @override
  Path getOrthoProjection(FigureAxes x, FigureAxes y) {
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
  //
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
///
class TransformedProjectionFigure implements Figure {
  final Color? _borderColor;
  final Color? _fillColor;
  final Figure _figure;
  final Matrix4 _transform;
  ///
  const TransformedProjectionFigure({
    Color? borderColor,
    Color? fillColor,
    required Figure figure,
    required Matrix4 transform,
  })  : _borderColor = borderColor,
        _fillColor = fillColor,
        _figure = figure,
        _transform = transform;
  //
  @override
  Color? get borderColor => _borderColor ?? _figure.borderColor;
  //
  @override
  Color? get fillColor => _fillColor ?? _figure.fillColor;
  //
  @override
  Path getOrthoProjection(FigureAxes x, FigureAxes y) {
    return _figure.getOrthoProjection(x, y).transform(_transform.storage);
  }
  //
  @override
  Figure copyWith({Color? borderColor, Color? fillColor}) {
    return TransformedProjectionFigure(
      borderColor: borderColor ?? _borderColor,
      fillColor: fillColor ?? _fillColor,
      figure: _figure,
      transform: _transform,
    );
  }
}
class WaterineFigure implements Figure {
  final Color? _borderColor;
  final Color? _fillColor;
  final Offset _begin;
  final Offset _end;
  final (FigureAxes, FigureAxes) _axes;
  ///
  const WaterineFigure({
    Color? borderColor,
    Color? fillColor,
    required Offset begin,
    required Offset end,
    required (FigureAxes, FigureAxes) axes,
  })  : _borderColor = borderColor,
        _fillColor = fillColor,
        _begin = begin,
        _end = end,
        _axes = axes;
  //
  @override
  Color? get borderColor => _borderColor;
  //
  @override
  Color? get fillColor => _fillColor ?? _borderColor?.withOpacity(0.15);
  //
  @override
  Path getOrthoProjection(FigureAxes x, FigureAxes y) {
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
class PolygonFigure implements Figure {
  final Color? _borderColor;
  final Color? _fillColor;
  final Map<(FigureAxes, FigureAxes), List<Offset>> _pathProjection;
  ///
  const PolygonFigure({
    Color? borderColor,
    Color? fillColor,
    required Map<(FigureAxes, FigureAxes), List<Offset>> pathProjection,
  })  : _borderColor = borderColor,
        _fillColor = fillColor,
        _pathProjection = pathProjection;
  //
  @override
  Color? get borderColor => _borderColor;
  //
  @override
  Color? get fillColor => _fillColor;
  //
  @override
  Path getOrthoProjection(FigureAxes x, FigureAxes y) {
    final projection = (x, y);
    return switch (projection) {
      (FigureAxes.x, FigureAxes.y) => Path()
        ..addPolygon(
          _pathProjection[(FigureAxes.x, FigureAxes.y)] ?? [],
          true,
        ),
      (FigureAxes.y, FigureAxes.z) => Path()
        ..addPolygon(
          _pathProjection[(FigureAxes.y, FigureAxes.z)] ?? [],
          true,
        ),
      (FigureAxes.x, FigureAxes.z) => Path()
        ..addPolygon(
          _pathProjection[(FigureAxes.x, FigureAxes.z)] ?? [],
          true,
        ),
      _ => Path(),
    };
  }
  //
  @override
  Figure copyWith({Color? borderColor, Color? fillColor}) {
    return PolygonFigure(
      borderColor: borderColor ?? _borderColor,
      fillColor: fillColor ?? _fillColor,
      pathProjection: _pathProjection,
    );
  }
}
///
class ProjectionPathFigure implements Figure {
  final Color? _borderColor;
  final Color? _fillColor;
  final Path _path;
  ///
  const ProjectionPathFigure({
    Color? borderColor,
    Color? fillColor,
    required Path path,
  })  : _borderColor = borderColor,
        _fillColor = fillColor,
        _path = path;
  //
  @override
  Color? get borderColor => _borderColor;
  //
  @override
  Color? get fillColor => _fillColor;
  //
  @override
  Path getOrthoProjection(FigureAxes x, FigureAxes y) {
    return _path;
  }
  //
  @override
  Figure copyWith({Color? borderColor, Color? fillColor}) {
    return ProjectionPathFigure(
      borderColor: borderColor ?? _borderColor,
      fillColor: fillColor ?? _fillColor,
      path: _path,
    );
  }
}
///
class SVGPathFigure implements Figure {
  final Color? _borderColor;
  final Color? _fillColor;
  final Map<(FigureAxes, FigureAxes), String> _projectionPath;
  ///
  const SVGPathFigure({
    Color? borderColor,
    Color? fillColor,
    required Map<(FigureAxes, FigureAxes), String> projectionPath,
  })  : _borderColor = borderColor,
        _fillColor = fillColor,
        _projectionPath = projectionPath;
  //
  @override
  Color? get borderColor => _borderColor;
  //
  @override
  Color? get fillColor => _fillColor;
  //
  @override
  Path getOrthoProjection(FigureAxes x, FigureAxes y) {
    final projection = (x, y);
    return switch (projection) {
      (FigureAxes.x, FigureAxes.y) => parseSvgPathData(
          _projectionPath[(FigureAxes.x, FigureAxes.y)] ?? '',
        ),
      (FigureAxes.y, FigureAxes.z) => parseSvgPathData(
          _projectionPath[(FigureAxes.y, FigureAxes.z)] ?? '',
        ),
      (FigureAxes.x, FigureAxes.z) => parseSvgPathData(
          _projectionPath[(FigureAxes.x, FigureAxes.z)] ?? '',
        ),
      _ => Path(),
    };
  }
  //
  @override
  Figure copyWith({Color? borderColor, Color? fillColor}) {
    return SVGPathFigure(
      borderColor: borderColor ?? _borderColor,
      fillColor: fillColor ?? _fillColor,
      projectionPath: _projectionPath,
    );
  }
}
