import 'package:hmi_core/hmi_core_failure.dart';
import 'package:hmi_core/hmi_core_result_new.dart';
import 'package:hmi_widgets/hmi_widgets.dart';
///
/// [ValidationCase] which is created based on [Validator].
class ValidatorValidationCase implements ValidationCase {
  final Validator _validator;
  ///
  /// Creates [ValidationCase] which is created based on provided [Validator].
  const ValidatorValidationCase({
    required Validator validator,
  }) : _validator = validator;
  //
  @override
  ResultF<void> isSatisfiedBy(String? value) {
    final errorMessage = _validator.editFieldValidator(value);
    if (errorMessage == null) return const Ok(null);
    return Err(Failure(
      message: errorMessage,
      stackTrace: StackTrace.current,
    ));
  }
}
