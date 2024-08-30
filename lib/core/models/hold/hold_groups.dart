import 'dart:async';
import 'package:hmi_core/hmi_core.dart' hide Result;
import 'package:hmi_core/hmi_core_result_new.dart';
import 'package:sss_computing_client/core/models/hold/hold_group.dart';
/// Interface for controlling collection of [HoldGroup].
abstract interface class HoldGroups {
  ///
  /// Get all [HoldGroup] in [HoldGroup] collection.
  Future<Result<List<HoldGroup>, Failure<String>>> fetchAll();
  ///
  /// Get [HoldGroup] by id.
  Future<Result<HoldGroup, Failure<String>>> fetchById(int id);
}
