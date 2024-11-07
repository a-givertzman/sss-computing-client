import 'package:hmi_core/hmi_core.dart';
import 'package:hmi_widgets/hmi_widgets.dart';
///
/// [RealValidationCase] for real numbers
class RealValidationCase implements ValidationCase {
  ///
  const RealValidationCase();
  //
  @override
  ResultF<void> isSatisfiedBy(String? value) {
    final realPattern = RegExp(r'^[+-]?[\d]*[.]?[\d]*$');
    if (value != null && realPattern.hasMatch(value)) {
      return const Ok(null);
    } else {
      return Err(
        Failure(
          message: const Localized('Only real numbers allowed').toString(),
          stackTrace: StackTrace.current,
        ),
      );
    }
  }
}
