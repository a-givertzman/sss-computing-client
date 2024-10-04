import 'package:hmi_core/hmi_core.dart' hide Result;
import 'package:hmi_core/hmi_core_result_new.dart';
///
/// Extension for [Future] returning [Result].
extension FutureResultExtension<T> on Future<Result<T, Failure<dynamic>>> {
  ///
  /// Returns new future with transformed [Result].
  ///
  /// If the original [Result] is [Ok], the returned [Future] will contain a
  /// [Result] with the same value.
  ///
  /// If the original [Result] is [Err], the returned [Future] will contain a
  /// [Result] with a [Failure] containing a string representation of the original error.
  ///
  /// If an error occurs during the execution of this [Future] (e.g., due to a timeout),
  /// the returned [Future] will be completed with a [Result] containing
  /// a [Failure] with a string representation of this error.
  Future<Result<T, Failure<String>>> convertFailure() {
    return then<Result<T, Failure<String>>>(
      (result) => switch (result) {
        Ok(:final value) => Ok(value),
        Err(:final error) => Err(Failure(
            message: '$error',
            stackTrace: StackTrace.current,
          )),
      },
    ).catchError(
      (error) => Err<T, Failure<String>>(Failure(
        message: '$error',
        stackTrace: StackTrace.current,
      )),
    );
  }
}
