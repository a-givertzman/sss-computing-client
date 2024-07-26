import 'package:hmi_core/hmi_core_failure.dart';
import 'package:hmi_core/hmi_core_result_new.dart';
import 'package:hmi_widgets/hmi_widgets.dart';
///
class ValidatorValidationCase implements ValidationCase {
  final Validator? _validator;
  ///
  const ValidatorValidationCase({
    required Validator? validator,
  }) : _validator = validator;
  //
  @override
  ResultF<void> isSatisfiedBy(String? value) {
    final validator = _validator;
    if (validator == null) return const Ok(null);
    final errorMessage = validator.editFieldValidator(value);
    if (errorMessage == null) return const Ok(null);
    return Err(
      Failure(
        message: errorMessage,
        stackTrace: StackTrace.current,
      ),
    );
  }
}
