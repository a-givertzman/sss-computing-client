///
/// Common data for corresponding [HeelTrim].
abstract interface class HeelTrim {
  ///
  /// Id of the ship for corresponding [HeelTrim].
  int get shipId;
  ///
  /// Id of the project for corresponding [HeelTrim].
  int? get projectId;
  ///
  /// Heel angle in degrees.
  double get heel;
  ///
  /// Trim angle in degrees.
  double get trim;
  ///
  /// Offset from midship and value of draft at afterward perpendicular.
  ({double offset, double value}) get draftAP;
  ///
  /// Offset from midship and value of draft at average perpendicular.
  ({double offset, double value}) get draftAvg;
  ///
  /// Offset from midship and value of draft at forward perpendicular.
  ({double offset, double value}) get draftFP;
}
