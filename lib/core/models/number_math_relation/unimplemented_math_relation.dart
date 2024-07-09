import 'package:hmi_core/hmi_core.dart' hide Result;
import 'package:hmi_core/hmi_core_result_new.dart';
import 'package:sss_computing_client/core/models/number_math_relation/number_math_relation.dart';
///
/// [NumberMathRelation] that returns [Err] if process() called
final class UnimplementedMathRelation implements NumberMathRelation {
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
  Err<bool, Failure<String>> process<T extends num>(
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
