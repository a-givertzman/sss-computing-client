import 'package:sss_computing_client/core/models/strength/strength_force.dart';
import 'package:sss_computing_client/core/models/strength/strength_force_limit.dart';
///
/// Common data for corresponding [StrengthForceLimited].
abstract interface class StrengthForceLimited {
  /// [StrengthForceLimit] limited by low and high limits
  StrengthForce get force;
  /// lower limit for value of [StrengthForceLimited]
  StrengthForceLimit get lowLimit;
  /// upper limit for value of [StrengthForceLimited]
  StrengthForceLimit get highLimit;
}
///
/// [StrengthForceLimited] that parses itself from json map.
final class JsonStrengthForceLimited implements StrengthForceLimited {
  final Map<String, dynamic> _json;
  /// [StrengthForceLimited] that parses itself from json map.
  const JsonStrengthForceLimited({
    required Map<String, dynamic> json,
  }) : _json = json;
  //
  @override
  StrengthForce get force => _json['force'];
  //
  @override
  StrengthForceLimit get lowLimit => _json['lowLimit'];
  //
  @override
  StrengthForceLimit get highLimit => _json['highLimit'];
}
