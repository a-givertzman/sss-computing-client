import 'dart:async';
import 'package:hmi_core/hmi_core.dart' hide Result;
import 'package:hmi_core/hmi_core_result_new.dart';
import 'package:sss_computing_client/core/models/cargo/cargo.dart';
/// Interface for controlling collection of [Cargo].
abstract interface class Cargos {
  ///
  /// Get all [Cargo] in [Cargos] collection.
  Future<Result<List<Cargo>, Failure<String>>> fetchAll();
  ///
  /// Get [Cargo] by id.
  Future<Result<Cargo, Failure<String>>> fetchById(int id);
}
