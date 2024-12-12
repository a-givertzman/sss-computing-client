import 'package:hmi_core/hmi_core.dart';
import 'package:hmi_widgets/hmi_widgets.dart';
///
/// [ValidationCase] to validate file name.
class FileNameValidationCase implements ValidationCase {
  ///
  /// Creates [ValidationCase] to validate file name.
  ///
  /// Returns [Err] if name contains any characters other than `A-Z, a-z, А-Я, а-я, 0-9, ), (, _, -.`,
  /// and [Ok] otherwise.
  const FileNameValidationCase();
  //
  @override
  ResultF<void> isSatisfiedBy(String? value) {
    final validNamePattern = RegExp(r'^[A-Za-zА-Яа-я0-9\(\)_-]*$');
    return switch (value) {
      null => const Ok(null),
      final String name => validNamePattern.hasMatch(name)
          ? const Ok(null)
          : Err(Failure(
              message:
                  'Invalid characters found. Available for use: A-Z, a-z, А-Я, а-я, 0-9, ), (, _, -',
              stackTrace: StackTrace.current,
            ))
    };
  }
}
