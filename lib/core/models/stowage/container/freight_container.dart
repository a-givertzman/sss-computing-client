import 'package:sss_computing_client/core/models/stowage/container/freight_container_type.dart';
///
/// Simple representation of freight container;
abstract interface class FreightContainer {
  ///
  /// Unique identifier of container.
  int get id;
  ///
  /// Serial code of container.
  int get serialCode;
  ///
  /// Type code of container.
  String get typeCode;
  ///
  /// Owner code of container.
  String get ownerCode;
  ///
  /// Size of container along the longitudinal axis, measured in m.
  double get width;
  ///
  /// Check digit of container.
  int get checkDigit;
  ///
  /// Size of container along the transverse axis, measured in m.
  double get length;
  ///
  /// Size of container along the vertical axis, measured in m.
  double get height;
  ///
  /// Weight of empty container, measured in t.
  double get tareWeight;
  ///
  /// Weight of cargo inside container, measured in t.
  double get cargoWeight;
  ///
  /// Combined weight of container plus cargo, measured in t;
  double get grossWeight;
  ///
  /// Maximum possible gross weight of container, measured in t.
  double get maxGrossWeight;
  ///
  /// Type of container.
  /// In accordance with [ISO 668](https://www.iso.org/ru/standard/76912.html)
  FreightContainerType get type;
  ///
  /// ID of pol (port of loading) [Waypoint].
  int? get polWaypointId;
  ///
  /// Order of pol (port of loading) [Waypoint] in voyage.
  int? get polWaypointOrder;
  ///
  /// ID of pod (port of departure) [Waypoint].
  int? get podWaypointId;
  ///
  /// Order of pod (port of departure) [Waypoint] in voyage.
  int? get podWaypointOrder;
  ///
  /// Returns container as a [Map].
  Map<String, dynamic> asMap();
}
