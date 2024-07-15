import 'dart:convert';
import 'package:flutter/painting.dart';
import 'package:sss_computing_client/core/models/cargo/cargo.dart';
import 'package:sss_computing_client/core/models/figure/figure.dart';
import 'package:sss_computing_client/core/models/figure/svg_path_figure.dart';
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
    return SVGPathFigure(
      paints: [
        Paint()
          ..color = color
          ..style = PaintingStyle.stroke,
        Paint()
          ..color = color.withOpacity(0.25)
          ..style = PaintingStyle.fill,
      ],
      pathProjections: {
        FigurePlane.xy: jsonDecode(cargo.path ?? '{}')['xy'],
        FigurePlane.xz: jsonDecode(cargo.path ?? '{}')['xz'],
        FigurePlane.yz: jsonDecode(cargo.path ?? '{}')['yz'],
      },
    );
  }
}