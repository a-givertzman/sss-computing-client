import 'package:flutter/widgets.dart';
import 'package:hmi_core/hmi_core.dart' hide Result;
import 'package:hmi_core/hmi_core_result_new.dart';
import 'package:hmi_widgets/hmi_widgets.dart';
///
typedef TECValidationCase = TextEditingControllerValidationCase;
///
/// [ValidationCase] that compares value with [TextEditingController] text.
class TextEditingControllerValidationCase implements ValidationCase {
  final TextEditingController _controller;
  final ResultF<void> Function(String, String) _compareValues;
  ///
  /// Creates [ValidationCase] that compares value
  /// with [TextEditingController] text.
  ///
  /// `controller` - controller whose text is used for comparison;
  /// `compareValues` - used to determine validity of value,
  /// returns [Ok] if value is valid and [Err] otherwise.
  const TextEditingControllerValidationCase({
    required TextEditingController controller,
    required Result<void, Failure<dynamic>> Function(
      String value,
      String controllerValue,
    ) compareValues,
  })  : _controller = controller,
        _compareValues = compareValues;
  //
  @override
  ResultF<void> isSatisfiedBy(String? value) {
    if (value != null) return _compareValues(value, _controller.text);
    return Err(
      Failure(
        message: const Localized('Value is required').v,
        stackTrace: StackTrace.current,
      ),
    );
  }
}
