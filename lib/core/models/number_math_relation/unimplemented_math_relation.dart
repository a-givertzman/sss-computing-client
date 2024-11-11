import 'package:hmi_core/hmi_core.dart';
import 'package:sss_computing_client/core/models/number_math_relation/number_math_relation.dart';
///
/// [NumberMathRelation] that returns [Err] if process() called
final class UnimplementedMathRelation implements NumberMathRelation {
  final String _stringRepresentation;
  ///
  /// Creates instance of [NumberMathRelation] for unimplemented relation
  const UnimplementedMathRelation({
    required String stringRepresentation,
  }) : _stringRepresentation = stringRepresentation;
  //
  @override
  String get operator => _stringRepresentation;
  //
  @override
  Err<bool, Failure<String>> process<T extends num>(
    T firstValue,
    T secondValue,
  ) {
    return Err(Failure<String>(
      message:
          'No implementation of [NumberMathRelation] for provided [stringRepresentaion]: $_stringRepresentation',
      stackTrace: StackTrace.current,
    ));
  }
  //
  @override
  UnimplementedMathRelation swapped() => UnimplementedMathRelation(
        stringRepresentation: _stringRepresentation,
      );
  //
  @override
  UnimplementedMathRelation inverted() => UnimplementedMathRelation(
        stringRepresentation: _stringRepresentation,
      );
}
