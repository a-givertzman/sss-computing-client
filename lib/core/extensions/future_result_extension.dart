import 'package:hmi_core/hmi_core.dart';

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
  ///
  /// By default, the [Failure] message will be a string representation of the original error.
  /// Using [errorMessage] this behavior can be changed.
  Future<Result<T, Failure<String>>> convertFailure({
    String Function(Failure error)? errorMessage,
  }) {
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
        message: errorMessage?.call(error) ?? '$error',
        stackTrace: StackTrace.current,
      )),
    );
  }

  ///
  /// Logs the result of the future and returns the original future untouched.
  ///
  /// By default, the [Future] will log the value and the error as its string representation.
  ///
  /// Using [infoMessage] and [errorMessage] this behavior can be changed.
  Future<Result<T, Failure<dynamic>>> logResult(
    Log log, {
    String Function(T value)? infoMessage,
    String Function(Failure error)? errorMessage,
  }) =>
      then(
        (result) => result
            .inspect(
              (value) => log.info(
                infoMessage?.call(value) ?? 'value: $value',
              ),
            )
            .inspectErr(
              (error) => log.error(
                errorMessage?.call(error) ?? 'error: $error',
              ),
            ),
      );
}
