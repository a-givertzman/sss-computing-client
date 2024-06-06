import 'package:ext_rw/ext_rw.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core.dart' hide Result;
import 'package:hmi_core/hmi_core_app_settings.dart';
import 'package:hmi_core/hmi_core_result_new.dart';
import 'package:hmi_widgets/hmi_widgets.dart';
///
class RunCalculationButton extends StatefulWidget {
  final void Function() _fireRefreshEvent;
  ///
  const RunCalculationButton({
    super.key,
    required void Function() fireRefreshEvent,
  }) : _fireRefreshEvent = fireRefreshEvent;
  //
  @override
  State<RunCalculationButton> createState() => _RunCalculationButtonState(
        fireRefreshEvent: _fireRefreshEvent,
      );
}
///
class _RunCalculationButtonState extends State<RunCalculationButton> {
  final void Function() _fireRefreshEvent;
  late final ApiAddress _apiAddress;
  late final String _authToken;
  late final String _scriptName;
  late bool _isLoading;
  ///
  _RunCalculationButtonState({
    required void Function() fireRefreshEvent,
  }) : _fireRefreshEvent = fireRefreshEvent;
  //
  @override
  void initState() {
    _apiAddress = ApiAddress(
      host: const Setting('api-host').toString(),
      port: const Setting('api-port').toInt,
    );
    _scriptName = 'sss-computing-strength';
    _authToken = const Setting('api-auth-token').toString();
    _isLoading = false;
    super.initState();
  }
  //
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return FloatingActionButton.small(
      heroTag: 'fab_calculation',
      backgroundColor: theme.colorScheme.primary,
      foregroundColor: theme.colorScheme.onPrimary,
      tooltip: _isLoading
          ? const Localized('Calculations in progress').v
          : const Localized('Run calculations').v,
      onPressed: _isLoading ? null : _handlePress,
      child: _isLoading
          ? CupertinoActivityIndicator(
              color: theme.colorScheme.onPrimary,
            )
          : const Icon(Icons.calculate),
    );
  }
  //
  void _handlePress() {
    setState(() {
      _isLoading = true;
    });
    ApiRequest(
      authToken: _authToken,
      address: _apiAddress,
      timeout: const Duration(seconds: 10),
      query: ExecutableQuery(
        script: _scriptName,
        params: {
          "message": "start",
        },
      ),
    )
        .fetch()
        .then(
          (result) => switch (result) {
            Ok(value: final reply) =>
              reply.data.any((data) => data['status'] != 'ok')
                  ? _showErrorMessage(
                      context,
                      '${reply.data.firstWhere((data) => data['status'] != 'ok')['message']}',
                    )
                  : _showInfoMessage(
                      context,
                      const Localized('Calculation completed.').v,
                    ),
            Err(:final error) => _showErrorMessage(context, '$error'),
          },
        )
        .onError(
          (error, stackTrace) => _showErrorMessage(context, '$error'),
        )
        .whenComplete(
          () => setState(() {
            _isLoading = false;
            _fireRefreshEvent();
          }),
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
