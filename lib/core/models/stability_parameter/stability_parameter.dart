///
/// Common data for corresponding [StabilityParameter].
abstract interface class StabilityParameter {
  /// Name of [StabilityParameter]
  String get name;
  /// Value of [StabilityParameter]
  double get value;
  /// Unit of value for [StabilityParameter]
  String? get unit;
  /// Additional description for [StabilityParameter]
  String? get description;
  /// Returns [Map] representation of [StabilityParameter]
  Map<String, dynamic> asMap();
}
