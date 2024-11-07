import 'package:hmi_core/hmi_core.dart';
import 'package:sss_computing_client/core/models/number_math_relation/equal_to.dart';
import 'package:sss_computing_client/core/models/number_math_relation/number_math_relation.dart';
///
/// [NumberMathRelation] for '≠' relation
final class NotEqualTo implements NumberMathRelation {
  ///
  /// Creates instance of [NumberMathRelation] for '≠' relation
  const NotEqualTo();
  //
  @override
  String get operator => '≠';
  //
  @override
  Ok<bool, Failure<String>> process<T extends num>(
    T firstValue,
    T secondValue,
  ) {
    return Ok(firstValue != secondValue);
  }
  //
  @override
  NotEqualTo swapped() => const NotEqualTo();
  //
  @override
  EqualTo inverted() => const EqualTo();
}
