import 'package:hmi_core/hmi_core.dart' hide Result;
import 'package:hmi_core/hmi_core_result_new.dart';
import 'package:sss_computing_client/core/models/number_math_relation/equal_to.dart';
import 'package:sss_computing_client/core/models/number_math_relation/greater_than.dart';
import 'package:sss_computing_client/core/models/number_math_relation/less_than.dart';
import 'package:sss_computing_client/core/models/number_math_relation/less_than_or_equal_to.dart';
import 'package:sss_computing_client/core/models/number_math_relation/number_math_relation.dart';
///
/// [NumberMathRelation] for '≥' relation
final class GreaterThanOrEqualTo implements NumberMathRelation {
  ///
  /// Creates instance of [NumberMathRelation] for '≥' relation
  const GreaterThanOrEqualTo();
  //
  @override
  String get operator => '≥';
  //
  @override
  Ok<bool, Failure<String>> process<T extends num>(
    T firstValue,
    T secondValue,
  ) {
    final greaterResult = const GreaterThan().process(firstValue, secondValue);
    final equalResult = const EqualTo().process(firstValue, secondValue);
    return Ok(greaterResult.value || equalResult.value);
  }
  //
  @override
  LessThanOrEqualTo swaped() => const LessThanOrEqualTo();
  //
  @override
  LessThan inversed() => const LessThan();
}
