import 'package:hmi_core/hmi_core.dart';
///
/// Extension for [Future] returning [Result].
extension FutureResultExtension<V, E> on Future<Result<V, Failure<E>>> {
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
  /// By default, [Failure] message will be a string representation of the original error.
  /// Using [errorMessage] this behavior can be changed.
  Future<Result<V, Failure<String>>> convertFailure({
    String? errorMessage,
  }) {
    return then<Result<V, Failure<String>>>(
      (result) => switch (result) {
        Ok(:final value) => Ok(value),
        Err(:final error) => Err(Failure(
            message: errorMessage ?? '$error',
            stackTrace: StackTrace.current,
          )),
      },
    ).catchError(
      (error) => Err<V, Failure<String>>(Failure(
        message: errorMessage ?? '$error',
        stackTrace: StackTrace.current,
      )),
    );
  }
  ///
  /// Logs result of the future using the provided [log]
  /// and returns result of the original future untouched.
  ///
  /// By default, log value and error as its string representation.
  /// Using [okMessage] and [errorMessage] this behavior can be changed.
  ///
  /// If [message] is provided, it will be used as starting log message.
  Future<Result<V, Failure<E>>> logResult(
    Log log, {
    String? message,
    String Function(V value)? okMessage,
    String Function(Failure<E> error)? errorMessage,
  }) =>
      then((result) {
        if (message != null) log.info(message);
        return result
            .inspect(
              (value) => log.info(
                okMessage?.call(value) ?? 'value: $value',
              ),
            )
            .inspectErr(
              (error) => log.error(
                errorMessage?.call(error) ?? 'error: $error',
              ),
            );
      });
}
