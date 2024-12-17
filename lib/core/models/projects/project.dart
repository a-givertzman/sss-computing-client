///
/// Common data for corresponding [Project].
abstract interface class Project {
  ///
  /// ID of [Project]
  int get id;
  ///
  /// Name of [Project]
  String get name;
  ///
  /// Creation date of [Project]
  DateTime get createdAt;
  ///
  /// Last loaded date of [Project]
  DateTime? get loadedAt;
  ///
  /// Either [Project] is source of currently loaded data or not
  bool get isLoaded;
  ///
  /// Either [Project] can be deleted or not
  bool get isDeletable;
  ///
  /// Returns [Map] representation of [Project]
  Map<String, dynamic> asMap();
}
