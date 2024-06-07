import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core.dart';
import 'package:sss_computing_client/core/widgets/navigation_panel.dart';
///
class LoadingPage extends StatelessWidget {
  final Stream<DsDataPoint<bool>> _appRefreshStream;
  final void Function() _fireRefreshEvent;
  ///
  const LoadingPage({
    super.key,
    required Stream<DsDataPoint<bool>> appRefreshStream,
    required void Function() fireRefreshEvent,
  })  : _appRefreshStream = appRefreshStream,
        _fireRefreshEvent = fireRefreshEvent;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          NavigationPanel(
            selectedPageIndex: 3,
            appRefreshStream: _appRefreshStream,
            fireRefreshEvent: _fireRefreshEvent,
          ),
          const Expanded(
            child: Center(child: Text('[Loading empty]')),
          ),
        ],
      ),
    );
  }
}
