import 'package:flutter/painting.dart';
import 'package:sss_computing_client/core/models/cargo/cargo.dart';
import 'package:sss_computing_client/core/models/figure/combined_figure.dart';
import 'package:sss_computing_client/core/models/figure/figure.dart';
import 'package:sss_computing_client/core/models/figure/line_segment_3d_figure.dart';
import 'package:sss_computing_client/core/models/figure/rectangular_cuboid_figure.dart';
import 'package:sss_computing_client/core/models/figure/path_projections_figure.dart';
import 'package:sss_computing_client/core/models/figure/path_projections.dart';
import 'package:vector_math/vector_math_64.dart';
///
/// Object that extracts [Figure] from [Cargo]
class CargoFigure {
  final Cargo _cargo;
  ///
  /// Creates object that extracts [Figure] from [Cargo]
  const CargoFigure({
    required Cargo cargo,
  }) : _cargo = cargo;
  ///
  /// Returns [Figure] for cargo.
  Figure figure() {
    final color = _cargo.type.color;
    return switch (_cargo.paths) {
      final PathProjections projections => PathProjectionsFigure(
          paints: [
            Paint()
              ..color = color
              ..style = PaintingStyle.stroke,
            Paint()
              ..color = color.withOpacity(0.25)
              ..style = PaintingStyle.fill,
          ],
          pathProjections: projections,
        ),
      _ => CombinedFigure(
          paints: [
            Paint()
              ..color = color
              ..strokeWidth = 2.0
              ..style = PaintingStyle.stroke,
            Paint()
              ..color = color.withOpacity(0.25)
              ..style = PaintingStyle.fill,
          ],
          figureOne: LineSegment3DFigure(
            start: Vector3(_cargo.x1, _cargo.tcg ?? 0.0, _cargo.vcg ?? 0.0),
            end: Vector3(_cargo.x2, _cargo.tcg ?? 0.0, _cargo.vcg ?? 0.0),
          ),
          figureTwo: RectangularCuboidFigure.fromCenter(
            center: Vector3(
              _cargo.lcg ?? 0.0,
              _cargo.tcg ?? 0.0,
              _cargo.vcg ?? 0.0,
            ),
            length: 1.0,
            width: 1.0,
            height: 1.0,
          ),
        ),
    };
  }
}
