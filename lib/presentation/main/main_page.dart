import 'dart:async';
import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core.dart';
import 'package:sss_computing_client/core/widgets/navigation_panel.dart';
import 'package:sss_computing_client/core/widgets/run_calculation_button.dart';
import 'package:sss_computing_client/presentation/main/widgets/main_page_body.dart';
///
class MainPage extends StatelessWidget {
  final Stream<DsDataPoint<bool>> _appRefreshStream;
  final void Function() _fireRefreshEvent;
  ///
  const MainPage({
    super.key,
    required Stream<DsDataPoint<bool>> appRefreshStream,
    required void Function() fireRefreshEvent,
  })  : _appRefreshStream = appRefreshStream,
        _fireRefreshEvent = fireRefreshEvent;
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
      ),
    );
  }
}
