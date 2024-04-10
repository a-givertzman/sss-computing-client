import 'package:hmi_core/hmi_core_result_new.dart';
import 'package:hmi_core/hmi_core_failure.dart';
import 'package:hmi_widgets/hmi_widgets.dart';

///
class IntValidationCase implements ValidationCase {
  ///
  const IntValidationCase();
  //
  @override
  ResultF<void> isSatisfiedBy(String? value) {
    if (value != null && value.isNotEmpty) {
      if (int.tryParse(value) != null) {
        return const Ok(null);
      }
    }
    return Err(
      Failure(
        message: 'Only integer number allowed',
        stackTrace: StackTrace.current,
      ),
    );
  }
}
