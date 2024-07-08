import 'package:sss_computing_client/core/widgets/calculation/calculation_status.dart';
///
/// Immutable object that represents state of [CalculationStatus].
sealed class CalculationStatusState {
  ///
  /// Creates [CalculationStatusState] from passed [CalculationStatus].
  factory CalculationStatusState.fromStatus(CalculationStatus status) =>
      switch (status) {
        CalculationStatus(
          isInProcess: true,
        ) =>
          const CalculationStatusLoading(),
        CalculationStatus(
          errorMessage: final String errorMessage,
        ) =>
          CalculationStatusWithError(errorMessage),
        CalculationStatus(
          message: final String message,
        ) =>
          CalculationStatusWithMessage(message),
        _ => const CalculationStatusNothing(),
      };
}
///
/// [CalculationStatusState] for calculation that is not in progress
/// and compeleted successfully with reply message.
final class CalculationStatusWithMessage implements CalculationStatusState {
  final String message;
  ///
  /// Creates [CalculationStatusState] for successfully completed calculations.
  const CalculationStatusWithMessage(this.message);
}
///
/// [CalculationStatusState] for calculation that is not in progress
/// and completed with error.
final class CalculationStatusWithError implements CalculationStatusState {
  final String errorMessage;
  ///
  /// Creates [CalculationStatusState] for error case.
  const CalculationStatusWithError(this.errorMessage);
}
///
/// [CalculationStatusState] for calculation that is in progress.
final class CalculationStatusLoading implements CalculationStatusState {
  ////
  /// Creates [CalculationStatusState] for loading case.
  const CalculationStatusLoading();
}
///
/// [CalculationStatusState] for calculation that is not in progress
/// and doesn't have message or errorMessage.
final class CalculationStatusNothing implements CalculationStatusState {
  ////
  /// Creates [CalculationStatusNothing] for nothing case.
  const CalculationStatusNothing();
}
