import 'package:hmi_core/hmi_core.dart';
import 'package:hmi_core/hmi_core_result_new.dart';
import 'package:hmi_widgets/hmi_widgets.dart';
import 'package:sss_computing_client/core/models/number_math_relation/number_math_relation.dart';
///
class NumberMathRelationValidationCase<T extends num>
    implements ValidationCase {
  final NumberMathRelation _relation;
  final T _secondValue;
  final T Function(String text) _toValue;
  final String? _customMessage;
  ///
  NumberMathRelationValidationCase({
    required NumberMathRelation relation,
    required T secondValue,
    required T Function(String text) toValue,
    String? customMessage,
  })  : _relation = relation,
        _secondValue = secondValue,
        _toValue = toValue,
        _customMessage = customMessage;
  @override
  ResultF<void> isSatisfiedBy(String? value) {
    if (value == null) {
      return Err(Failure(
        message: const Localized('Value is required').v,
        stackTrace: StackTrace.current,
      ));
    }
    return switch (_relation.process<T>(
      _toValue(value),
      _secondValue,
    )) {
      Ok(value: final isValid) => isValid
          ? const Ok(null)
          : Err(Failure(
              message:
                  _customMessage ?? const Localized('Value is not valid').v,
              stackTrace: StackTrace.current,
            )),
      Err(:final error) => Err(error),
    };
  }
}
