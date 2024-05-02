import 'package:flutter/cupertino.dart';
import 'package:hmi_core/hmi_core.dart';
import 'package:hmi_core/hmi_core_result_new.dart';
import 'package:sss_computing_client/core/widgets/error_message_widget.dart';
///
class FutureBuilderWidget<T> extends StatefulWidget {
  final Widget Function(BuildContext, T) _caseData;
  final Widget Function(BuildContext)? _caseLoading;
  final Widget Function(BuildContext, Object)? _caseError;
  final Widget Function(BuildContext)? _caseNothing;
  final bool Function(T)? _validateData;
  final Future<ResultF<T>> Function() _onFuture;
  final Widget? _retryLabel;
  ///
  const FutureBuilderWidget({
    super.key,
    required Future<ResultF<T>> Function() onFuture,
    required Widget Function(BuildContext context, T data) caseData,
    Widget Function(BuildContext context)? caseLoading,
    Widget Function(BuildContext context, Object error)? caseError,
    Widget Function(BuildContext context)? caseNothing,
    Widget? retryLabel,
    bool Function(T data)? validateData,
    double appBarHeight = 56.0,
    List<Widget> appBarLeftWidgets = const [],
    List<Widget> appBarRightWidgets = const [],
    bool alwaysShowAppBarWidgets = false,
  })  : _validateData = validateData,
        _caseLoading = caseLoading,
        _caseData = caseData,
        _caseError = caseError,
        _caseNothing = caseNothing,
        _onFuture = onFuture,
        _retryLabel = retryLabel;
  ///
  @override
  State<FutureBuilderWidget> createState() => _FutureBuilderWidgetState<T>(
        retryLabel: _retryLabel,
        caseData: _caseData,
        caseLoading: _caseLoading,
        caseError: _caseError,
        caseNothing: _caseNothing,
        onFuture: _onFuture,
        validateData: _validateData,
      );
}
///
class _FutureBuilderWidgetState<T> extends State<FutureBuilderWidget<T>> {
  final Widget Function(BuildContext, T) caseData;
  final Widget Function(BuildContext)? caseLoading;
  final Widget Function(BuildContext, Object)? caseError;
  final Widget Function(BuildContext)? caseNothing;
  final bool Function(T)? validateData;
  final Future<ResultF<T>> Function() onFuture;
  final Widget? retryLabel;
  late Future<ResultF<T>> future;
  ///
  _FutureBuilderWidgetState({
    required this.retryLabel,
    required this.caseData,
    required this.caseLoading,
    required this.caseError,
    required this.caseNothing,
    required this.validateData,
    required this.onFuture,
  });
  ///
  @override
  void initState() {
    future = onFuture();
    super.initState();
  }
  ///
  void _reload() {
    setState(() {
      future = onFuture();
    });
  }
  ///
  /// Default indicator builder for [FutureBuilderWidget] loading state
  Widget defaultCaseLoading(BuildContext _) => const Center(
        child: CupertinoActivityIndicator(),
      );
  ///
  /// Default indicator builder for [FutureBuilderWidget]  error state
  Widget defaultCaseError(BuildContext _, Failure<String> error) =>
      ErrorMessageWidget(
        message: const Localized('Error loading data').v,
        error: error,
        onConfirm: _reload,
      );
  ///
  /// Default indicator builder for [FutureBuilderWidget] empty-data state
  Widget defaultCaseNothing(BuildContext _) => ErrorMessageWidget(
        message: const Localized('No data').v,
        onConfirm: _reload,
      );
  ///
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: future,
      builder: (context, snapshot) {
        final snapshotState = _AsyncSnapshotState.fromSnapshot(
          snapshot,
          validateData,
        );
        return switch (snapshotState) {
          _WithDataState<T>(:final data) => caseData(context, data),
          _LoadingState() =>
            caseLoading?.call(context) ?? defaultCaseLoading(context),
          _WithErrorState(:final error) => caseError?.call(context, error) ??
              defaultCaseError(
                context,
                Failure<String>(
                  message: '${error.message}',
                  stackTrace: StackTrace.current,
                ),
              ),
          _NothingState() =>
            caseNothing?.call(context) ?? defaultCaseNothing(context),
        };
      },
    );
  }
}
///
sealed class _AsyncSnapshotState<T> {
  ///
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
              true => _WithDataState(value),
              false => _WithErrorState(
                  Failure<String>(
                    message: 'Invalid data',
                    stackTrace: StackTrace.current,
                  ),
                ) as _AsyncSnapshotState<T>,
            },
          Err(:final error) => _WithErrorState(error),
        },
      AsyncSnapshot(
        connectionState: != ConnectionState.waiting,
        hasData: false,
        hasError: true,
        :final error,
        :final stackTrace,
      ) =>
        _WithErrorState(
          Failure<String>(
            message: error?.toString() ?? 'Something went wrong',
            stackTrace: stackTrace ?? StackTrace.current,
          ),
        ),
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
final class _WithDataState<T> implements _AsyncSnapshotState<T> {
  final T data;
  const _WithDataState(this.data);
}
///
final class _WithErrorState implements _AsyncSnapshotState<Never> {
  final Failure error;
  const _WithErrorState(this.error);
}
