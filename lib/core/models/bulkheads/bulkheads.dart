import 'dart:async';
import 'package:hmi_core/hmi_core.dart' hide Result;
import 'package:hmi_core/hmi_core_result_new.dart';
import 'package:sss_computing_client/core/models/bulkheads/bulkhead.dart';
/// Interface for controlling collection of [Bulkhead].
abstract interface class Bulkheads {
  ///
  /// Get all [Bulkhead] in [Bulkhead] collection.
  Future<Result<List<Bulkhead>, Failure<String>>> fetchAll();
  ///
  /// Get [Bulkhead] by id.
  Future<Result<Bulkhead, Failure<String>>> fetchById(int id);
}
