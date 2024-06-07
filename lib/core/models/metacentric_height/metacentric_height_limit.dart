///
/// Common data for corresponding [MetacentricHeightLimit].
abstract interface class MetacentricHeightLimit {
  ///
  /// Id of the ship for corresponding [MetacentricHeightLimit]
  int get shipId;
  ///
  /// Id of the project for corresponding [MetacentricHeightLimit]
  int? get projectId;
  ///
  /// The value on which the metacentric height limit depends.
  double get dependentValue;
  ///
  /// Limit value of [MetacentricHeightLimit] in meters.
  double? get value;
}
