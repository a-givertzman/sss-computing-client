import 'package:flutter/material.dart';
///
/// Simple representation of waypoint for ship voyage.
abstract interface class Waypoint {
  ///
  /// Unique identifier of container.
  int get id;
  ///
  /// Unique identifier of ship.
  int get shipId;
  ///
  /// Unique identifier of project.
  int? get projectId;
  ///
  /// Name of port.
  String get portName;
  ///
  /// Code of port.
  String get portCode;
  ///
  /// ETA of the waypoint (elapsed time of arrival)
  DateTime get eta;
  ///
  /// ETD of the waypoint (elapsed time of departure)
  DateTime get etd;
  ///
  /// Color of the waypoint.
  Color get color;
  ///
  /// Draft limit for ship at this waypoint, measured in meters.
  double get draftLimit;
  ///
  /// Either [draftLimit] is used or not.
  bool get useDraftLimit;
  ///
  /// Returns waypoint as map.
  Map<String, dynamic> asMap();
}
