import 'dart:ui';
import 'package:sss_computing_client/core/models/figure/figure_plane.dart';
///
/// Object that give access to [Path] projections onto three main planes.
abstract interface class PathProjections {
  ///
  /// Returns map with [Path] projections onto three main planes.
  Map<FigurePlane, Path> toPathMap();
  ///
  /// Return [Path] projections onto three main planes as json.
  Map<String, dynamic> toJson();
}
