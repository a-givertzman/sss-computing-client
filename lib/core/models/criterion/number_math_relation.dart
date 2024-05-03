import 'package:hmi_core/hmi_core_failure.dart';
import 'package:hmi_core/hmi_core_result_new.dart';
///
/// Represenation of mathematical relation between two numbers
abstract interface class NumberMathRelation {
  ///
  /// String representaion of [NumberMathRelation] operator
  String get operator;
  ///
  /// Returns [ResultF] with true value
  /// if provided values satisfy [NumberMathRelation]
  /// and [ResultF] with false value otherwise
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
///
/// [NumberMathRelation] that returns [Err] if process() called
class UnimplementedMathRelation implements NumberMathRelation {
  final String _stringRepresentaion;
  ///
  /// Creates instance of [NumberMathRelation] for unimplemented relation
  const UnimplementedMathRelation({
    required String stringRepresentaion,
  }) : _stringRepresentaion = stringRepresentaion;
  //
  @override
  String get operator => _stringRepresentaion;
  //
  @override
  Result<bool, Failure<String>> process<T extends num>(
    T firstValue,
    T secondValue,
  ) {
    return Err(Failure<String>(
      message:
          'No implementation of [NumberMathRelation] for provided [stringRepresentaion]: $_stringRepresentaion',
      stackTrace: StackTrace.current,
    ));
  }
  //
  @override
  UnimplementedMathRelation swaped() => UnimplementedMathRelation(
        stringRepresentaion: _stringRepresentaion,
      );
  //
  @override
  UnimplementedMathRelation inversed() => UnimplementedMathRelation(
        stringRepresentaion: _stringRepresentaion,
      );
}
///
/// [NumberMathRelation] for '<' relation
class LessThan implements NumberMathRelation {
  ///
  /// Creates instance of [NumberMathRelation] for '<' relation
  const LessThan();
  //
  @override
  String get operator => '<';
  //
  @override
  Result<bool, Failure<String>> process<T extends num>(
    T firstValue,
    T secondValue,
  ) {
    return Ok(firstValue < secondValue);
  }
  //
  @override
  GreaterThan swaped() => const GreaterThan();
  //
  @override
  GreaterThanOrEqualTo inversed() => const GreaterThanOrEqualTo();
}
///
/// [NumberMathRelation] for '>' relation
class GreaterThan implements NumberMathRelation {
  ///
  /// Creates instance of [NumberMathRelation] for '>' relation
  const GreaterThan();
  //
  @override
  String get operator => '>';
  //
  @override
  Result<bool, Failure<String>> process<T extends num>(
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
///
/// [NumberMathRelation] for '=' relation
class EqualTo implements NumberMathRelation {
  ///
  /// Creates instance of [NumberMathRelation] for '=' relation
  const EqualTo();
  //
  @override
  String get operator => '=';
  //
  @override
  Result<bool, Failure<String>> process<T extends num>(
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
///
/// [NumberMathRelation] for '≠' relation
class NotEqualTo implements NumberMathRelation {
  ///
  /// Creates instance of [NumberMathRelation] for '≠' relation
  const NotEqualTo();
  //
  @override
  String get operator => '≠';
  //
  @override
  Result<bool, Failure<String>> process<T extends num>(
    T firstValue,
    T secondValue,
  ) {
    final equalResult = const EqualTo().process(firstValue, secondValue) as Ok;
    return Ok(!equalResult.value);
  }
  //
  @override
  NotEqualTo swaped() => const NotEqualTo();
  //
  @override
  EqualTo inversed() => const EqualTo();
}
///
/// [NumberMathRelation] for '≤' relation
class LessThanOrEqualTo implements NumberMathRelation {
  ///
  /// Creates instance of [NumberMathRelation] for '≤' relation
  const LessThanOrEqualTo();
  //
  @override
  String get operator => '≤';
  //
  @override
  Result<bool, Failure<String>> process<T extends num>(
    T firstValue,
    T secondValue,
  ) {
    final lessResult = const LessThan().process(firstValue, secondValue) as Ok;
    final equalResult = const EqualTo().process(firstValue, secondValue) as Ok;
    return Ok(lessResult.value || equalResult.value);
  }
  //
  @override
  GreaterThanOrEqualTo swaped() => const GreaterThanOrEqualTo();
  //
  @override
  GreaterThan inversed() => const GreaterThan();
}
///
/// [NumberMathRelation] for '≥' relation
class GreaterThanOrEqualTo implements NumberMathRelation {
  ///
  /// Creates instance of [NumberMathRelation] for '≥' relation
  const GreaterThanOrEqualTo();
  //
  @override
  String get operator => '≥';
  //
  @override
  Result<bool, Failure<String>> process<T extends num>(
    T firstValue,
    T secondValue,
  ) {
    final greaterResult =
        const GreaterThan().process(firstValue, secondValue) as Ok;
    final equalResult = const EqualTo().process(firstValue, secondValue) as Ok;
    return Ok(greaterResult.value || equalResult.value);
  }
  //
  @override
  LessThanOrEqualTo swaped() => const LessThanOrEqualTo();
  //
  @override
  LessThan inversed() => const LessThan();
}
