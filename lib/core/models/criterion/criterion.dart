///
/// Common data for corresponding [Criterion].
abstract interface class Criterion {
  /// Name of [Criterion]
  String get name;
  /// Value of [Criterion]
  double get value;
  /// Limit of value for [Criterion]
  double get limit;
  /// Relation between value and limit for [Criterion]
  String get relation;
  /// Unit of value for [Criterion]
  String? get unit;
  /// Additional description for [Criterion]
  String? get description;
  /// Returns [Map] representation of [Criterion]
  Map<String, dynamic> asMap();
}
