import 'package:flutter/painting.dart';
import 'package:path_drawing/path_drawing.dart';
import 'package:sss_computing_client/core/models/figure/figure.dart';
///
/// Construct [Figure] of custom form from map of projections,
/// treating them as svg path element.
class SVGPathFigure implements Figure {
  final List<Paint> _paints;
  final Map<FigurePlane, String?> _pathProjections;
  ///
  /// Construct [Figure] of custom form from map of projections,
  /// treating them as svg path element.
  const SVGPathFigure({
    List<Paint> paints = const [],
    required Map<FigurePlane, String?> pathProjections,
  })  : _paints = paints,
        _pathProjections = pathProjections;
  //
  @override
  List<Paint> get paints => _paints;
  //
  @override
  Path orthoProjection(FigurePlane plane) {
    return parseSvgPathData(_pathProjections[plane] ?? '');
  }
  //
  @override
  SVGPathFigure copyWith({List<Paint>? paints}) {
    return SVGPathFigure(
      paints: paints ?? _paints,
      pathProjections: _pathProjections,
    );
  }
}
