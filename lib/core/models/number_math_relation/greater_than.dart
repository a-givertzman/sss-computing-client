import 'package:hmi_core/hmi_core.dart';
import 'package:sss_computing_client/core/models/number_math_relation/less_than.dart';
import 'package:sss_computing_client/core/models/number_math_relation/less_than_or_equal_to.dart';
import 'package:sss_computing_client/core/models/number_math_relation/number_math_relation.dart';
///
/// [NumberMathRelation] for '>' relation
final class GreaterThan implements NumberMathRelation {
  ///
  /// Creates instance of [NumberMathRelation] for '>' relation
  const GreaterThan();
  //
  @override
  String get operator => '>';
  //
  @override
  Ok<bool, Failure<String>> process<T extends num>(
    T firstValue,
    T secondValue,
  ) {
    return Ok(firstValue > secondValue);
  }
  //
  @override
  LessThan swaped() => const LessThan();
  //
  @override
  LessThanOrEqualTo inversed() => const LessThanOrEqualTo();
}
