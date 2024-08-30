/// Common data for correspodnig [BulkheadPlace]
abstract interface class BulkheadPlace {
  ///
  /// ID of ship for the [BulkheadPlace]
  int get shipId;
  ///
  /// ID of project for the [BulkheadPlace]
  int? get projectId;
  ///
  /// ID of the [BulkheadPlace]
  int? get id;
  ///
  /// Name of the [BulkheadPlace]
  String get name;
  ///
  /// ID of the installed into this place bulkhead;
  int? get bulkheadId;
  ///
  /// ID of the hold group to which this [BulkheadPlace] belongs;
  int get holdGroupId;
  ///
  /// Returns [BulkheadPlace] as map
  Map<String, dynamic> asMap();
}
