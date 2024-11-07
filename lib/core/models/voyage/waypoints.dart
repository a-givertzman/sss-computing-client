import 'dart:async';
import 'package:hmi_core/hmi_core.dart';
import 'package:sss_computing_client/core/models/voyage/waypoint.dart';
///
/// Interface for controlling collection of [Waypoint].
abstract interface class Waypoints {
  ///
  /// Get all [Waypoint] in [Waypoints] collection.
  Future<Result<List<Waypoint>, Failure<String>>> fetchAll();
}
