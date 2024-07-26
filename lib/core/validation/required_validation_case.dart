import 'package:hmi_core/hmi_core.dart';
import 'package:hmi_core/hmi_core_result_new.dart';
import 'package:hmi_widgets/hmi_widgets.dart';
///
class RequiredValidationCase implements ValidationCase {
  ///
  const RequiredValidationCase();
  //
  @override
  ResultF<void> isSatisfiedBy(String? value) {
    if (value != null && value.trim() != '') return const Ok(null);
    return Err(
      Failure(
        message: const Localized('Value is required').v,
        stackTrace: StackTrace.current,
      ),
    );
  }
}
