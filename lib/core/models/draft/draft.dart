///
/// Common data for corresponding [Draft].
abstract interface class Draft {
  ///
  /// Id of the ship for corresponding [Draft].
  int get shipId;
  ///
  /// Id of the project for corresponding [Draft].
  int? get projectId;
  ///
  ///
  String get label;
  ///
  /// Draft value.
  double? get value;
  ///
  /// Offset from midship.
  double get x;
  ///
  /// Offset from OP.
  double get y;
  ///
  /// Returns [Map] representation of [Draft]
  Map<String, dynamic> asMap();
}
