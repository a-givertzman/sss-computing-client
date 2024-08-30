import 'dart:async';
import 'package:hmi_core/hmi_core.dart' hide Result;
import 'package:hmi_core/hmi_core_result_new.dart';
import 'package:sss_computing_client/core/models/bulkheads/bulkhead_place.dart';
/// Interface for controlling collection of [BulkheadPlace].
abstract interface class BulkheadPlaces {
  ///
  /// Get all [BulkheadPlace] in [BulkheadPlace] collection.
  Future<Result<List<BulkheadPlace>, Failure<String>>> fetchAll();
  ///
  /// Get [BulkheadPlace] by id.
  Future<Result<BulkheadPlace, Failure<String>>> fetchById(int id);
  ///
  Future<Result<BulkheadPlace, Failure<String>>> updateWithId(
    int id,
    BulkheadPlace bulkheadPlace,
  );
}
