/// Common data for correspodnig [HoldGroup]
abstract interface class HoldGroup {
  ///
  /// ID of ship for the [HoldGroup]
  int get shipId;
  ///
  /// ID of project for the [HoldGroup]
  int? get projectId;
  ///
  /// ID of the [HoldGroup]
  int? get id;
  ///
  /// Name of the [HoldGroup]
  String get name;
  ///
  /// Returns [HoldGroup] as map
  Map<String, dynamic> asMap();
}
