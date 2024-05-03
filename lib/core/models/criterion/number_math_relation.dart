import 'package:hmi_core/hmi_core_failure.dart';
import 'package:hmi_core/hmi_core_result_new.dart';
/// Represenation of mathematical relation between two numbers
abstract interface class NumberMathRelation {
  /// String representaion of [NumberMathRelation]
  String get asString;
  /// Returns [ResultF] with true value
  /// if provided values satisfy [NumberMathRelation]
  /// and [ResultF] with false value otherwise
  Result<bool, Failure<String>> process<T extends num>(
    T firstValue,
    T secondValue,
  );
  /// Creates an instance of [NumberMathRelation] from its string representation;
  /// Creates [UnimplementedMathRelation] if [NumberMathRelation] doesn't exist
  /// for provided string representation
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
}
/// [NumberMathRelation] that returns [Err] if process() called
class UnimplementedMathRelation implements NumberMathRelation {
  final String _stringRepresentaion;
  /// Creates instance of [NumberMathRelation] for unimplemented relation
  const UnimplementedMathRelation({
    required String stringRepresentaion,
  }) : _stringRepresentaion = stringRepresentaion;
  //
  @override
  String get asString => _stringRepresentaion;
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
}
/// [NumberMathRelation] for '<' relation
class LessThan implements NumberMathRelation {
  /// Creates instance of [NumberMathRelation] for '<' relation
  const LessThan();
  //
  @override
  String get asString => '<';
  //
  @override
  Result<bool, Failure<String>> process<T extends num>(
    T firstValue,
    T secondValue,
  ) {
    return Ok(firstValue < secondValue);
  }
}
/// [NumberMathRelation] for '>' relation
class GreaterThan implements NumberMathRelation {
  /// Creates instance of [NumberMathRelation] for '>' relation
  const GreaterThan();
  //
  @override
  String get asString => '>';
  //
  @override
  Result<bool, Failure<String>> process<T extends num>(
    T firstValue,
    T secondValue,
  ) {
    return Ok(firstValue > secondValue);
  }
}
/// [NumberMathRelation] for '=' relation
class EqualTo implements NumberMathRelation {
  /// Creates instance of [NumberMathRelation] for '=' relation
  const EqualTo();
  //
  @override
  String get asString => '=';
  //
  @override
  Result<bool, Failure<String>> process<T extends num>(
    T firstValue,
    T secondValue,
  ) {
    return Ok(firstValue == secondValue);
  }
}
/// [NumberMathRelation] for '≠' relation
class NotEqualTo implements NumberMathRelation {
  /// Creates instance of [NumberMathRelation] for '≠' relation
  const NotEqualTo();
  //
  @override
  String get asString => '≠';
  //
  @override
  Result<bool, Failure<String>> process<T extends num>(
    T firstValue,
    T secondValue,
  ) {
    final equalResult = const EqualTo().process(firstValue, secondValue) as Ok;
    return Ok(!equalResult.value);
  }
}
/// [NumberMathRelation] for '≤' relation
class LessThanOrEqualTo implements NumberMathRelation {
  /// Creates instance of [NumberMathRelation] for '≤' relation
  const LessThanOrEqualTo();
  //
  @override
  String get asString => '≤';
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
}
/// [NumberMathRelation] for '≥' relation
class GreaterThanOrEqualTo implements NumberMathRelation {
  /// Creates instance of [NumberMathRelation] for '≥' relation
  const GreaterThanOrEqualTo();
  //
  @override
  String get asString => '≥';
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
}
