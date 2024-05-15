import 'package:sss_computing_client/core/models/frame/frame.dart';
enum LimitType { low, high }
///
/// Common data for corresponding [StrengthForceLimit].
abstract interface class StrengthForceLimit {
  /// id of the ship for corresponding [StrengthForceLimit]
  int get shipId;
  /// id of the project for corresponding [StrengthForceLimit]
  int? get projectId;
  /// frame for correspondig [StrengthForceLimit]
  Frame get frame;
  /// type of [StrengthForceLimit]
  LimitType get type;
  /// value of [StrengthForceLimit]
  double? get value;
}
///
/// [StrengthForceLimit] that parses itself from json map.
final class JsonStrengthForceLimit implements StrengthForceLimit {
  final Map<String, dynamic> _json;
  /// [StrengthForceLimit] that parses itself from json map.
  const JsonStrengthForceLimit({
    required Map<String, dynamic> json,
  }) : _json = json;
  //
  @override
  int get shipId => _json['shipId'];
  //
  @override
  int? get projectId => _json['projectId'];
  //
  @override
  Frame get frame => _json['frame'];
  //
  @override
  LimitType get type => _json['type'];
  //
  @override
  double? get value => _json['value'];
}
