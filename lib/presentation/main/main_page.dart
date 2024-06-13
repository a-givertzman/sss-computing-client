import 'dart:async';
import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core.dart';
import 'package:sss_computing_client/core/widgets/calculation/calculation_status.dart';
import 'package:sss_computing_client/core/widgets/navigation_panel.dart';
import 'package:sss_computing_client/core/widgets/calculation/run_calculation_button.dart';
import 'package:sss_computing_client/presentation/main/widgets/main_page_body.dart';
///
class MainPage extends StatelessWidget {
  final Stream<DsDataPoint<bool>> _appRefreshStream;
  final void Function() _fireRefreshEvent;
  final CalculationStatus _calculationStatusNotifier;
  ///
  const MainPage({
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
    return Scaffold(
      body: Row(
        children: [
          NavigationPanel(
            selectedPageIndex: 0,
            appRefreshStream: _appRefreshStream,
            fireRefreshEvent: _fireRefreshEvent,
            calculationStatusNotifier: _calculationStatusNotifier,
          ),
          Expanded(
            child: MainPageBody(
              appRefreshStream: _appRefreshStream,
            ),
          ),
        ],
      ),
      floatingActionButton: RunCalculationButton(
        fireRefreshEvent: _fireRefreshEvent,
        calculationStatusNotifier: _calculationStatusNotifier,
      ),
    );
  }
}
