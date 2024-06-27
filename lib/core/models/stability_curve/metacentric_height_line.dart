import 'dart:math';
import 'dart:ui';
import 'package:hmi_core/hmi_core.dart' hide Result;
import 'package:hmi_core/hmi_core_result_new.dart';
import 'package:sss_computing_client/core/models/stability_curve/curve.dart';
import 'package:vector_math/vector_math_64.dart';
///
final class MetacentricHeightLine implements Curve {
  final double _minX;
  final double _maxX;
  final double _theta0;
  final double _h;
  final double _valueInterval;
  ///
  const MetacentricHeightLine({
    required double minX,
    required double maxX,
    required double theta0,
    required double h,
    double valueInterval = 1.0,
  })  : _minX = minX,
        _maxX = maxX,
        _theta0 = theta0,
        _h = h,
        _valueInterval = valueInterval;
  //
  @override
  Ok<List<Offset>, Failure<String>> points() {
    final minX = min(_minX, _theta0);
    final maxX = min(_maxX, _theta0 + radians2Degrees);
    final generatingSize = max(maxX - minX, 0) ~/ _valueInterval;
    final line = List<Offset>.generate(
      generatingSize,
      (i) => Offset(
        minX + i.toDouble(),
        (minX + i.toDouble() - _theta0) * _h / radians2Degrees,
      ),
    );
    if (line[generatingSize - 1].dx != _theta0 + radians2Degrees) {
      line.add(Offset(_theta0 + radians2Degrees, _h));
    }
    return Ok(line);
  }
}
