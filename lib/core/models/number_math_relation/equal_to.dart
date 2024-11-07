import 'package:hmi_core/hmi_core.dart';
import 'package:sss_computing_client/core/models/number_math_relation/not_equal_to.dart';
import 'package:sss_computing_client/core/models/number_math_relation/number_math_relation.dart';
///
/// [NumberMathRelation] for '=' relation
final class EqualTo implements NumberMathRelation {
  ///
  /// Creates instance of [NumberMathRelation] for '=' relation
  const EqualTo();
  //
  @override
  String get operator => '=';
  //
  @override
  Ok<bool, Failure<String>> process<T extends num>(
    T firstValue,
    T secondValue,
  ) {
    return Ok(firstValue == secondValue);
  }
  //
  @override
  EqualTo swaped() => const EqualTo();
  //
  @override
  NotEqualTo inversed() => const NotEqualTo();
}
