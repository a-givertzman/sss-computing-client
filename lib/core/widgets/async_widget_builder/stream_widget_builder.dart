import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:hmi_core/hmi_core.dart';
import 'package:sss_computing_client/core/widgets/async_widget_builder/async_snapshot_state.dart';

import 'package:sss_computing_client/core/widgets/error_message_widget.dart';

abstract class AsyncBuilderWidget<T> extends StatefulWidget {
  const AsyncBuilderWidget({
    super.key,
    this.caseLoading,
    required this.caseData,
    this.caseError,
    this.caseNothing,
    this.validateData,
    this.refreshStream,
  });
  final Widget Function(BuildContext)? caseLoading;
  final Widget Function(BuildContext, T, Retry? retry) caseData;

  final Widget Function(BuildContext, Object, {Retry? retry})? caseError;
  final Widget Function(BuildContext, {Retry? retry})? caseNothing;
  final bool Function(T)? validateData;
  final Stream<DsDataPoint<bool>>? refreshStream;

  Widget builder(
    BuildContext context,
    AsyncSnapshot<ResultF<T>> snapshot, {
    Retry? retry,
  }) {
    final snapshotState = AsyncSnapshotState.fromSnapshot(
      snapshot,
      validateData,
    );
    return switch (snapshotState) {
      AsyncLoadingState() =>
        caseLoading?.call(context) ?? _defaultCaseLoading(context),
      AsyncNothingState() => caseNothing?.call(
            context,
          ) ??
          _defaultCaseNothing(context, retry: retry),
      AsyncDataState<T>(:final data) => caseData.call(
          context,
          data,
          retry,
        ),
      AsyncErrorState(:final error) => caseError?.call(
            context,
            error,
            retry: retry,
          ) ??
          _defaultCaseError(context, error, retry: retry),
    };
  }
}

class StreamBuilderWidget<T> extends AsyncBuilderWidget<T> {
  const StreamBuilderWidget({
    super.key,
    required this.stream,
    required super.caseData,
  });
  final Stream<ResultF<T>> stream;
  @override
  State<StreamBuilderWidget<T>> createState() => _StreamBuilderWidgetState();
}

class _StreamBuilderWidgetState<T> extends State<StreamBuilderWidget<T>> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: widget.stream,
      builder: (context, snapshot) => widget.builder(
        context,
        snapshot,
      ),
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
Widget _defaultCaseError(
  BuildContext _,
  Object error, {
  void Function()? retry,
}) =>
    ErrorMessageWidget(
      error: Failure(message: '$error', stackTrace: StackTrace.current),
      message: const Localized('Data loading error').v,
      // onConfirm: retry,
    );

///
/// Default indicator builder for [FutureBuilderWidget] empty-data state
Widget _defaultCaseNothing(BuildContext _, {void Function()? retry}) =>
    ErrorMessageWidget(
      message: const Localized('No data').v,
      onConfirm: retry,
    );