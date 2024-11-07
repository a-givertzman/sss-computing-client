import 'dart:async';
import 'package:hmi_core/hmi_core.dart';
import 'package:sss_computing_client/core/models/bulkheads/bulkhead_place.dart';
///
/// Interface for controlling collection of [BulkheadPlace].
abstract interface class BulkheadPlaces {
  ///
  /// Get all [BulkheadPlace] in [BulkheadPlace] collection.
  Future<Result<List<BulkheadPlace>, Failure<String>>> fetchAll();
  ///
  /// Get [BulkheadPlace] by id.
  Future<Result<BulkheadPlace, Failure<String>>> fetchById(int id);
  ///
  /// Install bulkhead into bulkhead place
  Future<Result<void, Failure<String>>> installBulkheadWithId(
    int placeId,
    int bulkheadId,
  );
  ///
  /// Search and uninstall bulkhead from bulkhead place
  Future<Result<void, Failure<String>>> removeBulkheadWithId(
    int bulkheadId,
  );
}
