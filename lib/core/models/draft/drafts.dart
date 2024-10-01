import 'dart:async';
import 'package:hmi_core/hmi_core_result_new.dart';
import 'package:sss_computing_client/core/models/draft/draft.dart';
///
/// Interface for controlling collection of [Draft].
abstract interface class Drafts {
  ///
  /// Get all [Draft] in [Drafts] collection.
  Future<ResultF<List<Draft>>> fetchAll();
}
