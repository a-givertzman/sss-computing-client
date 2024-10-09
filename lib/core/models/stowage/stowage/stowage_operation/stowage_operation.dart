import 'package:hmi_core/hmi_core_result_new.dart';
import 'package:sss_computing_client/core/models/stowage/stowage/stowage_collection/stowage_collection.dart';
///
/// Operation to execute with stowage collection.
abstract interface class StowageOperation {
  ///
  /// Execute operation to modify slots in given [stowageCollection].
  ///
  /// If operation executed successfully, returns [Ok] with `null` value.
  /// Otherwise returns [Err] with [Failure] indicating the reason of error.
  ResultF<void> execute(StowageCollection stowageCollection);
}
