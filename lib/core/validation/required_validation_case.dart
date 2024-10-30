import 'package:hmi_core/hmi_core.dart';
import 'package:hmi_core/hmi_core_result_new.dart';
import 'package:hmi_widgets/hmi_widgets.dart';
///
/// [ValidationCase] that passed if value is not null.
class RequiredValidationCase implements ValidationCase {
  final bool _trimText;
  ///
  /// Creates [ValidationCase] that passed if value is not null.
  ///
  /// If [trimText] is true, text value will be trimmed before validation.
  const RequiredValidationCase({
    bool trimText = true,
  }) : _trimText = trimText;
  //
  @override
  ResultF<void> isSatisfiedBy(String? value) {
    if (value != null && (_trimText ? value.trim().isNotEmpty : true)) {
      return const Ok(null);
    }
    return Err(Failure(
      message: const Localized('Value is required').v,
      stackTrace: StackTrace.current,
    ));
  }
}
