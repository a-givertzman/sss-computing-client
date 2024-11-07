import 'package:hmi_core/hmi_core.dart';
import 'package:sss_computing_client/core/models/metacentric_height/metacentric_height_limit.dart';
///
/// Interface for controlling collection of [MetacentricHeightLimits].
abstract interface class MetacentricHeightLimits {
  ///
  /// Get all [MetacentricHeightLimit] in [MetacentricHeightLimits] collection.
  Future<Result<List<MetacentricHeightLimit>, Failure<String>>> fetchAll();
}
