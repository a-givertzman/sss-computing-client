import 'package:flutter/material.dart';
import 'package:sss_computing_client/core/models/figure/figure.dart';
///
/// Construct [Figure] as combined paths of figure 1 and 2.
class CombinedFigure implements Figure {
  final List<Paint> _paints;
  final Figure _figureOne;
  final Figure _figureTwo;
  ///
  /// Construct [Figure] as combined paths of figure 1 and 2.
  const CombinedFigure({
    List<Paint> paints = const [],
    required Figure figureOne,
    required Figure figureTwo,
  })  : _paints = paints,
        _figureOne = figureOne,
        _figureTwo = figureTwo;
  //
  @override
  List<Paint> get paints => _paints;
  //
  @override
  Path orthoProjection(FigurePlane plane) {
    return Path()
      ..addPath(_figureOne.orthoProjection(plane), Offset.zero)
      ..addPath(_figureTwo.orthoProjection(plane), Offset.zero);
  }
  //
  @override
  Figure copyWith({List<Paint>? paints}) {
    return CombinedFigure(
      paints: paints ?? _paints,
      figureOne: _figureOne,
      figureTwo: _figureTwo,
    );
  }
}
