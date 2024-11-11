import 'dart:ui';
import 'package:sss_computing_client/core/models/figure/figure_plane.dart';
import 'package:vector_math/vector_math_64.dart';
///
/// Item of [StowagePlanNumberingAxes].
class StowagePlanNumberingItem {
  final int number;
  final Vector3 _start;
  final Vector3 _end;
  ///
  /// Creates item of [StowagePlanNumberingAxes].
  ///
  /// Contains [number] to display along on of stowage plan axis (bay, row, or tier)
  /// and it [start] and [end] coordinates in 3D space
  /// (the smallest rectangular cuboid that encloses slots in stowage plan
  /// along certain axis at this [number]).
  const StowagePlanNumberingItem({
    required this.number,
    required Vector3 start,
    required Vector3 end,
  })  : _start = start,
        _end = end;
  ///
  /// Returns coordinates of center point of this [StowagePlanNumberingItem]
  /// on provided [plane].
  Offset center(FigurePlane plane) => switch (plane) {
        FigurePlane.xy =>
          Offset((_start.x + _end.x) / 2.0, (_start.y + _end.y) / 2.0),
        FigurePlane.xz =>
          Offset((_start.x + _end.x) / 2.0, (_start.z + _end.z) / 2.0),
        FigurePlane.yz =>
          Offset((_start.y + _end.y) / 2.0, (_start.z + _end.z) / 2.0),
      };
}
