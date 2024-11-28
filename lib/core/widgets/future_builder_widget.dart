import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:hmi_core/hmi_core.dart';
import 'error_message_widget.dart';
///
/// Function called to request data again. Returns Future with value [Ok]
/// if the data was received successfully, and Future with the value [Failure]
/// otherwise (e.g.,if future completed with error or was aborted).
typedef Retry = Future<ResultF<void>> Function();
///
class FutureBuilderWidget<T> extends StatefulWidget {
  final Widget Function(BuildContext) _caseLoading;
  final Widget Function(BuildContext, T, Retry) _caseData;
  final Widget Function(BuildContext, Object, Retry) _caseError;
  final Widget Function(BuildContext, Retry) _caseNothing;
  final bool Function(T)? _validateData;
  final Future<ResultF<T>> Function() _onFuture;
  final Stream<DsDataPoint<bool>>? _refreshStream;
  ///
  const FutureBuilderWidget({
    super.key,
    required Future<ResultF<T>> Function() onFuture,
    Widget Function(BuildContext context) caseLoading = _defaultCaseLoading,
    required Widget Function(
      BuildContext context,
      T data,
      Retry retry,
    ) caseData,
    Widget Function(
      BuildContext context,
      Object error,
      Retry retry,
    ) caseError = _defaultCaseError,
    Widget Function(
      BuildContext context,
      Retry retry,
    ) caseNothing = _defaultCaseNothing,
    bool Function(T data)? validateData,
    Stream<DsDataPoint<bool>>? refreshStream,
  })  : _validateData = validateData,
        _caseLoading = caseLoading,
        _caseData = caseData,
        _caseError = caseError,
        _caseNothing = caseNothing,
        _onFuture = onFuture,
        _refreshStream = refreshStream;
  //
  @override
  State<FutureBuilderWidget> createState() => _FutureBuilderWidgetState<T>(
        caseLoading: _caseLoading,
        caseData: _caseData,
        caseError: _caseError,
        caseNothing: _caseNothing,
        onFuture: _onFuture,
        validateData: _validateData,
        refreshStream: _refreshStream,
      );
}
///
class _FutureBuilderWidgetState<T> extends State<FutureBuilderWidget<T>> {
  final Widget Function(BuildContext) _caseLoading;
  final Widget Function(BuildContext, T, Retry) _caseData;
  final Widget Function(BuildContext, Object, Retry) _caseError;
  final Widget Function(BuildContext, Retry) _caseNothing;
  final bool Function(T)? _validateData;
  final Future<ResultF<T>> Function() _onFuture;
  final Stream<DsDataPoint<bool>>? _refreshStream;
  late Future<ResultF<T>> _future;
  late StreamSubscription<DsDataPoint<bool>>? _refreshSubscription;
  ///
  _FutureBuilderWidgetState({
    required Widget Function(BuildContext) caseLoading,
    required Widget Function(BuildContext, T, Retry) caseData,
    required Widget Function(BuildContext, Object, Retry) caseError,
    required Widget Function(BuildContext, Retry) caseNothing,
    required bool Function(T)? validateData,
    required Future<ResultF<T>> Function() onFuture,
    required Stream<DsDataPoint<bool>>? refreshStream,
  })  : _caseLoading = caseLoading,
        _caseData = caseData,
        _caseError = caseError,
        _caseNothing = caseNothing,
        _onFuture = onFuture,
        _validateData = validateData,
        _refreshStream = refreshStream;
  //
  @override
  void initState() {
    _future = _onFuture();
    _refreshSubscription = _refreshStream?.listen(
      (_) => setState(() {
        _future = _onFuture();
      }),
    );
    super.initState();
  }
  //
  @override
  void dispose() {
    _refreshSubscription?.cancel();
    super.dispose();
  }
  //
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _future,
      builder: (context, snapshot) {
        final snapshotState = _AsyncSnapshotState.fromSnapshot(
          snapshot,
          _validateData,
        );
        return switch (snapshotState) {
          _LoadingState() => _caseLoading.call(context),
          _NothingState() => _caseNothing.call(
              context,
              _retry,
            ),
          _DataState<T>(:final data) => _caseData.call(
              context,
              data,
              _retry,
            ),
          _ErrorState(:final error) => _caseError.call(
              context,
              error,
              _retry,
            ),
        };
      },
    );
  }
  ///
  Future<ResultF<void>> _retry() {
    setState(() {
      _future = _onFuture();
    });
    return _future
        .then<ResultF<void>>(
          (result) => switch (result) {
            Ok() => const Ok(null),
            Err(:final error) => Err(error),
          },
        )
        .onError(
          (error, stackTrace) => Err(Failure(
            message: '$error',
            stackTrace: stackTrace,
          )),
        );
  }
}
///
/// Default indicator builder for [FutureBuilderWidget] loading state
Widget _defaultCaseLoading(BuildContext _) => const Center(
      child: CupertinoActivityIndicator(),
    );
///
/// Default indicator builder for [FutureBuilderWidget] error state
Widget _defaultCaseError(BuildContext _, Object error, void Function() retry) =>
    ErrorMessageWidget(
      error: Failure(
        message: Localized('$error').v,
        stackTrace: StackTrace.current,
      ),
      message: '',
    );
///
/// Default indicator builder for [FutureBuilderWidget] empty-data state
Widget _defaultCaseNothing(BuildContext _, void Function() retry) =>
    ErrorMessageWidget(
      message: const Localized('No data').v,
      onConfirm: retry,
    );
///
sealed class _AsyncSnapshotState<T> {
  factory _AsyncSnapshotState.fromSnapshot(
    AsyncSnapshot<ResultF<T>> snapshot,
    bool Function(T)? validateData,
  ) {
    return switch (snapshot) {
      AsyncSnapshot(
        connectionState: ConnectionState.waiting,
      ) =>
        const _LoadingState(),
      AsyncSnapshot(
        connectionState: != ConnectionState.waiting,
        hasData: true,
        requireData: final result,
      ) =>
        switch (result) {
          Ok(:final value) => switch (validateData?.call(value) ?? true) {
              true => _DataState(value),
              false => _ErrorState(Failure(
                  message: 'Invalid data',
                  stackTrace: StackTrace.current,
                )) as _AsyncSnapshotState<T>,
            },
          Err(:final error) => _ErrorState(error),
        },
      AsyncSnapshot(
        connectionState: != ConnectionState.waiting,
        hasData: false,
        hasError: true,
        :final error,
        :final stackTrace,
      ) =>
        _ErrorState(Failure(
          message: error?.toString() ?? 'Something went wrong',
          stackTrace: stackTrace ?? StackTrace.current,
        )),
      _ => const _NothingState(),
    };
  }
}
///
final class _LoadingState implements _AsyncSnapshotState<Never> {
  const _LoadingState();
}
///
final class _NothingState implements _AsyncSnapshotState<Never> {
  const _NothingState();
}
///
final class _DataState<T> implements _AsyncSnapshotState<T> {
  final T data;
  const _DataState(this.data);
}
///
final class _ErrorState implements _AsyncSnapshotState<Never> {
  final Failure error;
  const _ErrorState(this.error);
}
