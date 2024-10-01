import 'package:flutter/painting.dart';
import 'package:sss_computing_client/core/models/figure/figure.dart';
import 'package:sss_computing_client/core/models/figure/figure_plane.dart';
import 'package:sss_computing_client/core/models/figure/json_svg_path_projections.dart';
import 'package:sss_computing_client/core/models/figure/path_projections.dart';
///
/// Construct [Figure] of custom form from [PathProjections].
class PathProjectionsFigure implements Figure {
  final List<Paint> _paints;
  final PathProjections _pathProjections;
  ///
  /// Construct [Figure] of custom form from [PathProjections].
  const PathProjectionsFigure({
    List<Paint> paints = const [],
    required PathProjections pathProjections,
  })  : _paints = paints,
        _pathProjections = pathProjections;
  //
  @override
  List<Paint> get paints => _paints;
  //
  @override
  Path orthoProjection(FigurePlane plane) {
    return _pathProjections.toPathMap()[plane] ?? Path();
  }
  //
  @override
  PathProjectionsFigure copyWith({List<Paint>? paints}) {
    return PathProjectionsFigure(
      paints: paints ?? List.from(_paints),
      pathProjections: JsonSvgPathProjections(
        json: _pathProjections.toJson(),
      ),
    );
  }
}
