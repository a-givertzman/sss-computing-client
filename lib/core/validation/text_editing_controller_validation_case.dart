import 'package:flutter/widgets.dart';
import 'package:hmi_core/hmi_core.dart';
import 'package:hmi_core/hmi_core_result_new.dart';
import 'package:hmi_widgets/hmi_widgets.dart';
///
typedef TECValidationCase = TextEditingControllerValidationCase;
///
class TextEditingControllerValidationCase implements ValidationCase {
  final TextEditingController controller;
  final ResultF<void> Function(
    String value,
    String controllerValue,
  ) compareValues;
  ///
  const TextEditingControllerValidationCase({
    required this.controller,
    required this.compareValues,
  });
  //
  @override
  ResultF<void> isSatisfiedBy(String? value) {
    if (value != null) return compareValues(value, controller.text);
    return Err(
      Failure(
        message: const Localized('Value is required').v,
        stackTrace: StackTrace.current,
      ),
    );
  }
}
