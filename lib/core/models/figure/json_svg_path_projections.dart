import 'dart:convert';
import 'dart:ui';
import 'package:path_drawing/path_drawing.dart';
import 'package:sss_computing_client/core/models/figure/figure_plane.dart';
import 'package:sss_computing_client/core/models/figure/path_projections.dart';
///
class JsonSvgPathProjections implements PathProjections {
  final String _json;
  ///
  const JsonSvgPathProjections({
    required String json,
  }) : _json = json;
  //
  @override
  Map<FigurePlane, Path> toPathMap() {
    return switch (json.decode(_json)) {
      {
        'xy': String xySvg,
        'yz': String yzSvg,
        'xz': String xzSvg,
      } =>
        {
          FigurePlane.xy: parseSvgPathData(xySvg),
          FigurePlane.yz: parseSvgPathData(yzSvg),
          FigurePlane.xz: parseSvgPathData(xzSvg),
        },
      _ => throw const FormatException(),
    };
  }
  //
  @override
  String toJson() => _json;
  //
  @override
  String toString() => _json;
}
