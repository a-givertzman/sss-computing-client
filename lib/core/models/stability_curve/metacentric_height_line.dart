import 'dart:math';
import 'dart:ui';
import 'package:hmi_core/hmi_core.dart' hide Result;
import 'package:hmi_core/hmi_core_result_new.dart';
import 'package:sss_computing_client/core/models/stability_curve/curve.dart';
import 'package:vector_math/vector_math_64.dart';
///
/// [Curve] object for metacentric height. Line connecting two point
/// on plane with righting arm as y-axis and angle of heel as x-axis.
/// Starting point is (theta0, 0.0), where theta0 is initial static heel angle.
/// Ending point is (theta0 + 1 radian, h), where h is corrected metacentric height (GM).
final class MetacentricHeightLine implements Curve {
  final double _minX;
  final double _maxX;
  final double _theta0;
  final double _h;
  final double _valueInterval;
  ///
  /// Creates a metacentric height [Curve] as maximum possible line segment
  /// with starting point (`theta0`, 0,0) and ending point (`theta0` + 1 radian, `h`),
  /// limited in x by interval [`minX`, `maxX`]. `valueInterval` - x interval
  /// between two adjacent points of the curve (x interval between last two points
  /// of the curve may be less than this value).
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
