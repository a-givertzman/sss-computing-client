import 'dart:async';
import 'package:hmi_core/hmi_core.dart' hide Result;
import 'package:hmi_core/hmi_core_result_new.dart';
import 'package:sss_computing_client/core/models/stowage/container/freight_container.dart';
/// Interface for controlling collection of [FreightContainer].
abstract interface class FreightContainers {
  ///
  /// Get all [FreightContainer] in [FreightContainers] collection.
  Future<Result<List<FreightContainer>, Failure<String>>> fetchAll();
}
