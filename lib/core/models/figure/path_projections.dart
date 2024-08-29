import 'dart:ui';
import 'package:sss_computing_client/core/models/figure/figure_plane.dart';
///
abstract interface class PathProjections {
  ///
  Map<FigurePlane, Path> toPathMap();
  ///
  String toJson();
}
