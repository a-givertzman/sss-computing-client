import 'dart:convert';
import 'package:flutter/painting.dart';
import 'package:sss_computing_client/core/models/cargo/cargo.dart';
import 'package:sss_computing_client/core/models/figure/combined_figure.dart';
import 'package:sss_computing_client/core/models/figure/figure.dart';
import 'package:sss_computing_client/core/models/figure/line_segment_3d_figure.dart';
import 'package:sss_computing_client/core/models/figure/rectangular_cuboid_figure.dart';
import 'package:sss_computing_client/core/models/figure/svg_path_figure.dart';
import 'package:vector_math/vector_math_64.dart';
///
/// Extract [Figure] from [Cargo]
class CargoFigure {
  final Cargo cargo;
  ///
  /// Creates object that extract [Figure] from [Cargo]
  const CargoFigure({required this.cargo});
  ///
  /// Extract [Cargo] figure
  Figure figure() {
    final color = cargo.type.color;
    return switch (cargo.path) {
      final String path => SVGPathFigure(
          paints: [
            Paint()
              ..color = color
              ..style = PaintingStyle.stroke,
            Paint()
              ..color = color.withOpacity(0.25)
              ..style = PaintingStyle.fill,
          ],
          pathProjections: {
            FigurePlane.xy: jsonDecode(path)['xy'],
            FigurePlane.xz: jsonDecode(path)['xz'],
            FigurePlane.yz: jsonDecode(path)['yz'],
          },
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
            start: Vector3(cargo.x1, cargo.tcg ?? 0.0, cargo.vcg ?? 0.0),
            end: Vector3(cargo.x2, cargo.tcg ?? 0.0, cargo.vcg ?? 0.0),
          ),
          figureTwo: RectangularCuboidFigure.fromCenter(
            center: Vector3(
              cargo.lcg ?? 0.0,
              cargo.tcg ?? 0.0,
              cargo.vcg ?? 0.0,
            ),
            length: 1.0,
            width: 1.0,
            height: 1.0,
          ),
        ),
    };
  }
}
