import 'package:flutter/painting.dart';
import 'package:hmi_core/hmi_core_app_settings.dart';
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
    final fillOpacity = const Setting('opacityHigh').toDouble;
    return switch (_cargo.paths) {
      final PathProjections projections => _pathFigure(
          projections,
          color,
          fillOpacity,
        ),
      _ => _cuboidFigure(
          color,
          fillOpacity,
        ),
    };
  }
  //
  Figure _pathFigure(
    PathProjections projections,
    Color color,
    double fillOpacity,
  ) =>
      PathProjectionsFigure(
        paints: [
          Paint()
            ..color = color
            ..style = PaintingStyle.stroke,
          Paint()
            ..color = color.withOpacity(fillOpacity)
            ..style = PaintingStyle.fill,
        ],
        pathProjections: projections,
      );
  //
  Figure _cuboidFigure(
    Color color,
    double fillOpacity,
  ) {
    final paints = [
      Paint()
        ..color = color
        ..strokeWidth = const Setting('strokeWidth').toDouble
        ..style = PaintingStyle.stroke,
      Paint()
        ..color = color.withOpacity(fillOpacity)
        ..style = PaintingStyle.fill,
    ];
    return switch (_cargo) {
      Cargo(
        :final double x1,
        :final double x2,
        :final double y1,
        :final double y2,
        :final double z1,
        :final double z2,
      ) =>
        RectangularCuboidFigure(
          paints: paints,
          start: Vector3(x1, y1, z1),
          end: Vector3(x2, y2, z2),
        ),
      _ => CombinedFigure(
          paints: paints,
          figureOne: LineSegment3DFigure(
            start: Vector3(
              _cargo.x1,
              _cargo.tcg ?? 0.0,
              _cargo.vcg ?? 0.0,
            ),
            end: Vector3(
              _cargo.x2,
              _cargo.tcg ?? 0.0,
              _cargo.vcg ?? 0.0,
            ),
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
