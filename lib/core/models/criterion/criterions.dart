import 'dart:async';
import 'package:hmi_core/hmi_core_result_new.dart';
import 'package:sss_computing_client/core/models/criterion/criterion.dart';
///
/// Interface for controlling collection of [Criterion].
abstract interface class Criterions {
  ///
  /// Get all [Criterion] in [Criterions] collection.
  Future<ResultF<List<Criterion>>> fetchAll();
}
