import 'package:hmi_core/hmi_core_result_new.dart';
import 'package:hmi_core/hmi_core_failure.dart';
import 'package:hmi_widgets/hmi_widgets.dart';

///
class RealValidationCase implements ValidationCase {
  ///
  const RealValidationCase();
  //
  @override
  ResultF<void> isSatisfiedBy(String? value) {
    if (value != null && value.isNotEmpty) {
      if (double.tryParse(value) != null) {
        return const Ok(null);
      }
    }
    return Err(
      Failure(
        message: 'Only real number allowed',
        stackTrace: StackTrace.current,
      ),
    );
  }
}
