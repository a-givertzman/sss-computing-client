import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core.dart';
///
/// Function called to request data again. Returns Future with value [Ok]
/// if the data was received successfully, and Future with the value [Failure]
/// otherwise (e.g.,if future completed with error or was aborted).
typedef Retry = Future<ResultF<void>> Function();
///
/// State of [AsyncSnapshot] for [AsyncBuilderWidget]
sealed class AsyncSnapshotState<T> {
  factory AsyncSnapshotState.fromSnapshot(
    AsyncSnapshot<ResultF<T>> snapshot,
    bool Function(T)? validateData,
  ) {
    return switch (snapshot) {
      AsyncSnapshot(
        connectionState: ConnectionState.waiting,
      ) =>
        const AsyncLoadingState(),
      AsyncSnapshot(
        connectionState: != ConnectionState.waiting,
        hasData: true,
        requireData: final result,
      ) =>
        switch (result) {
          Ok(:final value) => switch (validateData?.call(value) ?? true) {
              true => AsyncDataState(value),
              false => AsyncErrorState(Failure(
                  message: 'Invalid data',
                  stackTrace: StackTrace.current,
                )) as AsyncSnapshotState<T>,
            },
          Err(:final error) => AsyncErrorState(error),
        },
      AsyncSnapshot(
        connectionState: != ConnectionState.waiting,
        hasData: false,
        hasError: true,
        :final error,
        :final stackTrace,
      ) =>
        AsyncErrorState(Failure(
          message: error?.toString() ?? 'Something went wrong',
          stackTrace: stackTrace ?? StackTrace.current,
        )),
      _ => const AsyncNothingState(),
    };
  }
}
///
/// Loading state for [AsyncBuilderWidget]
/// - when [AsyncSnapshot.connectionState] is [ConnectionState.waiting]
final class AsyncLoadingState implements AsyncSnapshotState<Never> {
  const AsyncLoadingState();
}
///
/// Nothing state for [AsyncBuilderWidget]
final class AsyncNothingState implements AsyncSnapshotState<Never> {
  const AsyncNothingState();
}
///
/// Data state for [AsyncBuilderWidget]
/// - when [AsyncSnapshot.connectionState] is [ConnectionState.done]
/// - and [AsyncSnapshot.hasData] is true.
final class AsyncDataState<T> implements AsyncSnapshotState<T> {
  /// The actual data.
  final T data;
  //
  const AsyncDataState(this.data);
}
///
/// Error state for [AsyncBuilderWidget]
/// - when [AsyncSnapshot.connectionState] is [ConnectionState.done]
/// - and [AsyncSnapshot.hasData] is false
final class AsyncErrorState implements AsyncSnapshotState<Never> {
  /// The error that occurred.
  final Failure error;
  const AsyncErrorState(this.error);
}
