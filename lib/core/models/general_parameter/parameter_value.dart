///
/// Common data for corresponding [ParameterValue].
abstract interface class ParameterValue {
  ///
  /// Name of [ParameterValue]
  String get name;
  ///
  /// Value of [ParameterValue]
  double get value;
  ///
  /// Unit of value for [ParameterValue]
  String? get unit;
  ///
  /// Additional description for [ParameterValue]
  String? get description;
  ///
  /// Returns [Map] representation of [ParameterValue]
  Map<String, dynamic> asMap();
}
