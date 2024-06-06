import 'package:flutter/painting.dart';
///
/// Enum of three main planes for
/// orthogonal projections.
enum FigurePlane { xy, yz, xz }
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
  ///   `plane` - [FigurePlane] of orthogonal projection
  Path orthoProjection(FigurePlane plane);
  ///
  /// Returns copy of [Figure] with new paints.
  Figure copyWith({List<Paint>? paints});
}
