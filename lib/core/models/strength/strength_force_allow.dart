import 'package:sss_computing_client/core/models/strength/strength_force_limited.dart';
///
///
class StrengthForceAllow {
  final StrengthForceLimited _force;
  ///
  const StrengthForceAllow({
    required StrengthForceLimited force,
  }) : _force = force;
  ///
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
