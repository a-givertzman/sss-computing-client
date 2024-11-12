import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core.dart';
import 'package:sss_computing_client/core/models/calculation/calculation_status.dart';
import 'package:sss_computing_client/core/widgets/navigation_panel.dart';
import 'package:sss_computing_client/presentation/stability/widgets/stability_body.dart';
///
class StabilityPage extends StatelessWidget {
  final Stream<DsDataPoint<bool>> _appRefreshStream;
  final void Function() _fireRefreshEvent;
  final CalculationStatus _calculationStatusNotifier;
  ///
  const StabilityPage({
    super.key,
    required Stream<DsDataPoint<bool>> appRefreshStream,
    required void Function() fireRefreshEvent,
    required CalculationStatus calculationStatusNotifier,
  })  : _appRefreshStream = appRefreshStream,
        _fireRefreshEvent = fireRefreshEvent,
        _calculationStatusNotifier = calculationStatusNotifier;
  //
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      // ignore: deprecated_member_use
      backgroundColor: theme.colorScheme.background,
      body: Row(
        children: [
          NavigationPanel(
            selectedPageIndex: 2,
            appRefreshStream: _appRefreshStream,
            fireRefreshEvent: _fireRefreshEvent,
            calculationStatusNotifier: _calculationStatusNotifier,
          ),
          Expanded(
            child: StabilityBody(appRefreshStream: _appRefreshStream),
          ),
        ],
      ),
    );
  }
}
