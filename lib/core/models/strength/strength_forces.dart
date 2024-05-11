import 'dart:math';
import 'package:hmi_core/hmi_core.dart';
import 'package:hmi_core/hmi_core_result_new.dart';
import 'package:sss_computing_client/core/models/frames/frame_space.dart';
import 'package:sss_computing_client/core/models/strength/strength_force.dart';
///
/// Interface for controlling collection of [StrengthForces].
abstract interface class StrengthForces {
  /// Get all [StrengthForce] in [StrengthForces] collection.
  Future<ResultF<List<StrengthForce>>> fetchAll();
}
///
/// Fake implementation for [StrengthForces] that generate
/// collection of [StrengthForce]
class FakeStrengthForces implements StrengthForces {
  final int _valueRange;
  final int _nParts;
  final int _firstLimit;
  final int _minY;
  final int _maxY;
  final int _minX;
  ///
  const FakeStrengthForces({
    required int valueRange,
    required int nParts,
    required int firstLimit,
    required int minY,
    required int maxY,
    required int minX,
  })  : _valueRange = valueRange,
        _nParts = nParts,
        _firstLimit = firstLimit,
        _minY = minY,
        _maxY = maxY,
        _minX = minX;
  //
  @override
  Future<Ok<List<StrengthForce>, Failure>> fetchAll() {
    const shipId = 1;
    const projectId = null;
    final minYValue = _minY + _valueRange;
    final maxYValue = _maxY - _valueRange;
    final firstYValue =
        minYValue + Random().nextInt(maxYValue - minYValue).toDouble();
    final forces = List<StrengthForce>.generate(_nParts, (idx) {
      final value = firstYValue -
          _valueRange / 2 +
          Random().nextInt(_valueRange).toDouble();
      final valueLowLimit =
          -(_firstLimit.toDouble() + (idx < 10 ? idx : 20 - idx) * 10);
      final valueHighLimit =
          _firstLimit.toDouble() + (idx < 10 ? idx : 20 - idx) * 10;
      final leftFrameOffset = (_minX + 10 * idx).toDouble();
      final rightFrameOffset = (_minX + 10 * (idx + 1)).toDouble();
      return JsonStrengthForce(json: {
        'shipId': shipId,
        'projectId': projectId,
        'frameSpace': JsonFrameSpace(
          json: {
            'index': idx,
            'shipId': shipId,
            'projectId': projectId,
            'start': leftFrameOffset,
            'end': rightFrameOffset,
          },
        ),
        'value': value,
        'lowLimit': valueLowLimit,
        'highLimit': valueHighLimit,
      });
    });
    return Future.delayed(const Duration(milliseconds: 500), () => Ok(forces));
  }
}
