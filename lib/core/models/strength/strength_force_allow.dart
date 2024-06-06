import 'package:sss_computing_client/core/models/strength/strength_force_limited.dart';
///
/// Representation of allow values for [StrengthForceLimited].
class StrengthForceAllow {
  final StrengthForceLimited _force;
  ///
  /// Creates representation of allow value for [StrengthForceLimited].
  ///
  /// `force` - the [StrengthForceLimited] force for which
  /// allow value is calculated.
  const StrengthForceAllow({
    required StrengthForceLimited force,
  }) : _force = force;
  ///
  /// Returns value of allow.
  double? value() {
    final lowLimit = _force.lowLimit.value;
    final highLimit = _force.highLimit.value;
    final value = _force.force.value;
    return switch (value) {
      >= 0.0 => highLimit != null ? value / highLimit * 100.0 : null,
      < 0.0 => lowLimit != null ? value / lowLimit * 100.0 : null,
      _ => null,
    };
  }
}
