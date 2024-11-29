///
/// Simple representation for weight related data.
abstract interface class DisplacementWeight {
  ///
  /// Returns weight name
  String get name;
  ///
  /// Returns weight value, measured in tonnes.
  double? get value;
  ///
  /// Returns longitudinal center of gravity, measured in meters.
  double? get lcg;
  ///
  /// Returns vertical center of gravity, measured in meters.
  double? get vcg;
  ///
  /// Returns transverse center of gravity, measured in meters.
  double? get tcg;
  ///
  /// Returns correction to vertical center of gravity, measured in meters.
  double? get vcgCorrection;
}
