///
/// Common data for corresponding [MetacentricHeightLimit].
abstract interface class MetacentricHeightLimit {
  /// Id of the ship for corresponding [MetacentricHeightLimit]
  int get shipId;
  /// Id of the project for corresponding [MetacentricHeightLimit]
  int? get projectId;
  /// Displacement for correspondig [MetacentricHeightLimit] in tonnes.
  double get displacement;
  /// Bottom limit value of [MetacentricHeightLimit] in meters.
  double? get low;
  /// Upper limit value of [MetacentricHeightLimit] in meters.
  double? get high;
}
