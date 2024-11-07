import 'package:hmi_core/hmi_core.dart';
import 'package:sss_computing_client/core/models/number_math_relation/equal_to.dart';
import 'package:sss_computing_client/core/models/number_math_relation/greater_than.dart';
import 'package:sss_computing_client/core/models/number_math_relation/greater_than_or_equal_to.dart';
import 'package:sss_computing_client/core/models/number_math_relation/less_than.dart';
import 'package:sss_computing_client/core/models/number_math_relation/less_than_or_equal_to.dart';
import 'package:sss_computing_client/core/models/number_math_relation/not_equal_to.dart';
import 'package:sss_computing_client/core/models/number_math_relation/unimplemented_math_relation.dart';
///
/// Representation of mathematical relation between two numbers
abstract interface class NumberMathRelation {
  ///
  /// String representation of [NumberMathRelation] operator
  String get operator;
  ///
  /// Returns [ResultF] with `true` value
  /// if provided values satisfy [NumberMathRelation]
  /// and [ResultF] with `false` value otherwise
  Result<bool, Failure<String>> process<T extends num>(
    T firstValue,
    T secondValue,
  );
  ///
  /// Creates an instance of [NumberMathRelation] from its string representation;
  /// Creates [UnimplementedMathRelation] if [NumberMathRelation] doesn't exist
  /// for provided string representation of operator
  factory NumberMathRelation.fromString(String str) {
    return switch (str.trim()) {
      '<' => const LessThan(),
      '>' => const GreaterThan(),
      '=' => const EqualTo(),
      '!=' || '≠' || '<>' => const NotEqualTo(),
      '<=' || '≤' => const LessThanOrEqualTo(),
      '>=' || '≥' => const GreaterThanOrEqualTo(),
      _ => UnimplementedMathRelation(stringRepresentaion: str),
    };
  }
  ///
  /// Returns [NumberMathRelation] for which values
  /// order of operands has been reversed
  NumberMathRelation swaped();
  ///
  /// Returns [NumberMathRelation] with inversed operator
  NumberMathRelation inversed();
}
