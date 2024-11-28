import 'dart:async';
import 'package:hmi_core/hmi_core.dart';
import 'package:sss_computing_client/core/models/voyage/waypoint.dart';
///
/// Interface for controlling collection of [Waypoint].
abstract interface class Waypoints {
  ///
  /// Get all [Waypoint] in [Waypoints] collection.
  Future<Result<List<Waypoint>, Failure<String>>> fetchAll();
  ///
  /// Add [Waypoint] to [Waypoints] collection.
  Future<Result<Waypoint, Failure<String>>> add(Waypoint waypoint);
  ///
  /// Remove [Waypoint] from [Waypoints] collection.
  Future<Result<void, Failure<String>>> remove(Waypoint waypoint);
  ///
  /// Update [Waypoint] in [Waypoints] collection.
  Future<Result<Waypoint, Failure<String>>> update(
    Waypoint newData,
    Waypoint oldData,
  );
  ///
  /// Check if there are any containers with this waypoint as POL or POD and
  /// returns [Result] with number of references;
  Future<Result<int, Failure<String>>> validateContainerReference(
    Waypoint waypoint,
  );
}
