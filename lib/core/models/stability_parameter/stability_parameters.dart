import 'dart:async';
import 'package:hmi_core/hmi_core.dart';
import 'package:sss_computing_client/core/models/stability_parameter/stability_parameter.dart';
///
/// Interface for controlling collection of [StabilityParameter].
abstract interface class StabilityParameters {
  ///
  /// Get all [StabilityParameter] in [StabilityParameters] collection.
  Future<ResultF<List<StabilityParameter>>> fetchAll();
}
