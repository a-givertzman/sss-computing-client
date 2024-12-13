import 'dart:async';
import 'package:hmi_core/hmi_core.dart';
import 'package:sss_computing_client/core/models/stowage_plan/container/freight_container.dart';
///
/// Interface for controlling collection of [FreightContainer].
abstract interface class FreightContainers {
  ///
  /// Get all [FreightContainer] in [FreightContainers] collection.
  Future<Result<List<FreightContainer>, Failure<String>>> fetchAll();
  ///
  /// Add all [containers] to [FreightContainers] collection.
  Future<Result<void, Failure<String>>> addAll(
    List<FreightContainer> containers,
  );
  ///
  /// Remove all [containers] from [FreightContainers] collection.
  Future<Result<void, Failure<String>>> removeAll(
    List<FreightContainer> containers,
  );
  ///
  /// Remove entry by [id] from [FreightContainers] collection.
  Future<Result<void, Failure<String>>> removeById(int id);
  ///
  /// Update entry in [FreightContainers] collection from [oldData] to [newData].
  Future<Result<void, Failure<String>>> update(
    FreightContainer newData,
    FreightContainer oldData,
  );
}
