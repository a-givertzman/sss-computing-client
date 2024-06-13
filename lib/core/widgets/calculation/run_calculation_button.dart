import 'package:ext_rw/ext_rw.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core.dart' hide Result;
import 'package:hmi_core/hmi_core_app_settings.dart';
import 'package:hmi_core/hmi_core_result_new.dart';
import 'package:hmi_widgets/hmi_widgets.dart';
import 'package:sss_computing_client/core/models/calculation/calculation.dart';
import 'package:sss_computing_client/core/widgets/calculation/calculation_status.dart';
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
  /// `fireRefreshEvent` - callback for triggering refresh event, called
  /// when calculation succeeds or fails;
  /// `calculationStatusNotifier` - passed to control calculation status
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
    final theme = Theme.of(context);
    return ListenableBuilder(
      listenable: _calculationStatusNotifier,
      builder: (context, _) => FloatingActionButton.small(
        heroTag: 'fab_calculation',
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: theme.colorScheme.onPrimary,
        tooltip: _calculationStatusNotifier.isInProcess
            ? const Localized('Сalculations in progress').v
            : const Localized('Run calculations').v,
        onPressed: _calculationStatusNotifier.isInProcess ? null : _handlePress,
        child: _calculationStatusNotifier.isInProcess
            ? CupertinoActivityIndicator(
                color: theme.colorScheme.onPrimary,
              )
            : const Icon(Icons.calculate),
      ),
    );
  }
  //
  void _handlePress() {
    _calculationStatusNotifier.start();
    Calculation(
      apiAddress: _apiAddress,
      authToken: _authToken,
      scriptName: _scriptName,
    )
        .fetch()
        .then(
          (reply) => switch (reply) {
            Ok() => _showInfoMessage(
                context,
                const Localized('Calculation completed.').v,
              ),
            Err(:final error) => _showErrorMessage(context, '$error'),
          },
        )
        .onError(
          (error, stackTrace) => _showErrorMessage(
            context,
            '${const Localized('Error').v}: $error',
          ),
        )
        .whenComplete(
      () {
        _calculationStatusNotifier.stop();
        // TODO: remove delay (api-server needs this time gap between calculations and data refetching)
        Future.delayed(
          const Duration(milliseconds: 150),
          _fireRefreshEvent,
        );
      },
    );
  }
  //
  void _showInfoMessage(BuildContext context, String message) {
    if (!context.mounted) return;
    BottomMessage.info(
      displayDuration: const Duration(milliseconds: 1500),
      message: message,
    ).show(context);
  }
  //
  void _showErrorMessage(BuildContext context, String message) {
    if (!context.mounted) return;
    BottomMessage.error(
      displayDuration: const Duration(milliseconds: 2000),
      message: message,
    ).show(context);
  }
}
