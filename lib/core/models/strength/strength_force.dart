///
/// Common data for corresponding [StrengthForce].
abstract interface class StrengthForce {
  /// id of the ship for corresponding [StrengthForce]
  int get shipId;
  /// id of the project for corresponding [StrengthForce]
  int? get projectId;
  /// frame index for corresponding [StrengthForce]
  int get frameIndex;
  /// value of [StrengthForce]
  double get value;
  /// lower limit for value of [StrengthForce]
  double get lowLimit;
  /// upper limit for value of [StrengthForce]
  double get highLimit;
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
  int get frameIndex => _json['frameIndex'];
  //
  @override
  double get value => _json['value'];
  //
  @override
  double get lowLimit => _json['lowLimit'];
  //
  @override
  double get highLimit => _json['highLimit'];
}
