import 'package:hmi_core/hmi_core.dart';
import 'package:sss_computing_client/core/models/weight/displacement_weight.dart';
///
/// Collection of [DisplacementWeight]
abstract interface class DisplacementWeights {
  ///
  /// Fetches and returns all [DisplacementWeight] from collection.
  Future<Result<List<DisplacementWeight>, Failure<String>>> fetchAll();
}
