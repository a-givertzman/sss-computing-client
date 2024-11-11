///
/// Common data for correspodnig [Bulkhead]
abstract interface class Bulkhead {
  ///
  /// ID of ship for the [Bulkhead]
  int get shipId;
  ///
  /// ID of project for the [Bulkhead]
  int? get projectId;
  ///
  /// ID of the [Bulkhead]
  int get id;
  ///
  /// Name of the [Bulkhead]
  String get name;
  ///
  /// Mass of the [Bulkhead]
  double? get mass;
  ///
  /// Longitudinal center of gravity of the [Bulkhead]
  double? get lcg;
  ///
  /// Transverse center of gravity of the [Bulkhead]
  double? get tcg;
  ///
  /// Vertical center of gravity of the [Bulkhead]
  double? get vcg;
  ///
  /// Returns [Bulkhead] as map
  Map<String, dynamic> asMap();
}
