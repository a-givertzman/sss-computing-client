import 'package:sss_computing_client/core/models/frame/frame.dart';
///
/// Common data for corresponding [StrengthForce].
abstract interface class StrengthForce {
  /// id of the ship for corresponding [StrengthForce]
  int get shipId;
  /// id of the project for corresponding [StrengthForce]
  int? get projectId;
  /// [Frame] for corresponding [StrengthForce]
  Frame get frame;
  /// value of [StrengthForce]
  double get value;
}
///
/// [StrengthForce] that parses itself from json map.
final class JsonStrengthForce implements StrengthForce {
  final Map<String, dynamic> _json;
  /// [StrengthForce] that parses itself from json map.
  const JsonStrengthForce({
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
  double get value => _json['value'];
}
