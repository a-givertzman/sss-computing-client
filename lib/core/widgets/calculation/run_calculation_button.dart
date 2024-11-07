import 'package:ext_rw/ext_rw.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core.dart';
import 'package:hmi_core/hmi_core_app_settings.dart';
import 'package:hmi_widgets/hmi_widgets.dart';
import 'package:sss_computing_client/core/models/calculation/calculation.dart';
import 'package:sss_computing_client/core/models/calculation/calculation_status.dart';
import 'package:sss_computing_client/core/models/calculation/calculation_status_state.dart';
///
/// Button that sends a request to backend to perform
/// calculations and triggers update event when calculation is completed.
class RunCalculationButton extends StatefulWidget {
  final void Function() _fireRefreshEvent;
  final CalculationStatus _calculationStatusNotifier;
  ///
  /// Button that sends a request to backend to perform
  /// calculations and triggers update event when calculation is completed.
  ///
  /// [fireRefreshEvent] – callback for triggering refresh event, called
  /// when calculation succeeds or fails;
  /// [calculationStatusNotifier] – passed to control calculation status
  /// between many instances of calculation button.
  const RunCalculationButton({
    super.key,
    required void Function() fireRefreshEvent,
    required CalculationStatus calculationStatusNotifier,
  })  : _fireRefreshEvent = fireRefreshEvent,
        _calculationStatusNotifier = calculationStatusNotifier;
  //
  @override
  State<RunCalculationButton> createState() => _RunCalculationButtonState(
        fireRefreshEvent: _fireRefreshEvent,
        calculationStatusNotifier: _calculationStatusNotifier,
      );
}
///
class _RunCalculationButtonState extends State<RunCalculationButton> {
  final void Function() _fireRefreshEvent;
  final CalculationStatus _calculationStatusNotifier;
  late final ApiAddress _apiAddress;
  late final String _authToken;
  late final String _scriptName;
  ///
  _RunCalculationButtonState({
    required void Function() fireRefreshEvent,
    required CalculationStatus calculationStatusNotifier,
  })  : _fireRefreshEvent = fireRefreshEvent,
        _calculationStatusNotifier = calculationStatusNotifier;
  //
  @override
  void initState() {
    _apiAddress = ApiAddress(
      host: const Setting('api-host').toString(),
      port: const Setting('api-port').toInt,
    );
    _authToken = const Setting('api-auth-token').toString();
    _scriptName = 'sss-computing-strength';
    super.initState();
  }
  //
  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _calculationStatusNotifier,
      builder: (context, _) {
        final calculationStatus = CalculationStatusState.fromStatus(
          _calculationStatusNotifier,
        );
        return _StatusBadge(
          status: calculationStatus,
          child: _CalculationButton(
            status: calculationStatus,
            onPressed: _runCalculation,
          ),
        );
      },
    );
  }
  //
  void _runCalculation() {
    _calculationStatusNotifier.start();
    Calculation(
      apiAddress: _apiAddress,
      authToken: _authToken,
      scriptName: _scriptName,
    )
        .fetch()
        .then(
          (reply) => switch (reply) {
            Ok() => _calculationStatusNotifier.complete(
                message: const Localized('Calculation completed').v,
              ),
            Err(:final error) => _calculationStatusNotifier.complete(
                errorMessage: error.message,
              ),
          },
        )
        .onError(
          (error, stackTrace) => _calculationStatusNotifier.complete(
            errorMessage: '$error',
          ),
        )
        .whenComplete(_fireRefreshEvent);
  }
}
///
/// Badge indicating status of calculation.
class _StatusBadge extends StatelessWidget {
  final CalculationStatusState status;
  final Widget child;
  ///
  const _StatusBadge({
    required this.status,
    required this.child,
  });
  //
  @override
  Widget build(BuildContext context) {
    const iconSize = 16.0;
    final theme = Theme.of(context);
    return Badge(
      padding: EdgeInsets.zero,
      isLabelVisible: switch (status) {
        CalculationStatusLoading() => false,
        _ => true,
      },
      backgroundColor: switch (status) {
        CalculationStatusWithMessage() => theme.stateColors.on,
        CalculationStatusWithError() => theme.stateColors.error,
        CalculationStatusNothing() => theme.stateColors.obsolete,
        _ => null,
      },
      label: switch (status) {
        CalculationStatusWithMessage(:final message) => Tooltip(
            message: message,
            child: const Icon(Icons.done_rounded, size: iconSize),
          ),
        CalculationStatusWithError(:final errorMessage) => Tooltip(
            message: errorMessage,
            child: const Icon(Icons.priority_high_rounded, size: iconSize),
          ),
        CalculationStatusNothing() =>
          const Icon(Icons.question_mark_rounded, size: iconSize),
        _ => null,
      },
      child: child,
    );
  }
}
///
/// Button that starts calculation if it is not in progress.
class _CalculationButton extends StatelessWidget {
  final CalculationStatusState status;
  final void Function() onPressed;
  ///
  const _CalculationButton({
    required this.status,
    required this.onPressed,
  });
  //
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return FloatingActionButton(
      heroTag: null,
      elevation: 0.0,
      backgroundColor: theme.colorScheme.primary,
      foregroundColor: theme.colorScheme.onPrimary,
      tooltip: switch (status) {
        CalculationStatusLoading() =>
          const Localized('Сalculations in progress').v,
        _ => const Localized('Run calculations').v
      },
      onPressed: switch (status) {
        CalculationStatusLoading() => null,
        _ => onPressed,
      },
      child: switch (status) {
        CalculationStatusLoading() =>
          CupertinoActivityIndicator(color: theme.colorScheme.onPrimary),
        _ => const Icon(Icons.calculate_rounded),
      },
    );
  }
}
