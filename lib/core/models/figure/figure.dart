import 'package:flutter/painting.dart';
import 'package:sss_computing_client/core/models/figure/figure_plane.dart';
///
/// Construct [Path] as orthographic projection onto three main planes
/// and store paints needed to draw it on cavas.
abstract interface class Figure {
  ///
  /// List of [Paint] used to draw a figure
  List<Paint> get paints;
  ///
  /// Returns orthographic projection of [Figure]
  /// onto passed plane.
  ///
  ///   [plane] – [FigurePlane] of orthogonal projection
  Path orthoProjection(FigurePlane plane);
  ///
  /// Returns copy of [Figure] with new paints.
  Figure copyWith({List<Paint>? paints});
}
