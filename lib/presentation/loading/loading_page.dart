import 'package:ext_rw/ext_rw.dart';
import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core.dart';
import 'package:hmi_core/hmi_core_app_settings.dart';
import 'package:sss_computing_client/core/widgets/navigation_panel.dart';
import 'package:sss_computing_client/core/widgets/run_calculation_button.dart';
import 'package:sss_computing_client/presentation/loading/widgets/loading_page_body.dart';
///
class LoadingPage extends StatefulWidget {
  final Stream<DsDataPoint<bool>> _appRefreshStream;
  final void Function() _fireRefreshEvent;
  ///
  const LoadingPage({
    super.key,
    required Stream<DsDataPoint<bool>> appRefreshStream,
    required void Function() fireRefreshEvent,
  })  : _appRefreshStream = appRefreshStream,
        _fireRefreshEvent = fireRefreshEvent;
  //
  @override
  State<LoadingPage> createState() => _LoadingPageState();
}
class _LoadingPageState extends State<LoadingPage> {
  late final ApiAddress _apiAddress;
  late final String _dbName;
  late final String? _authToken;
  //
  @override
  void initState() {
    _apiAddress = ApiAddress(
      host: const Setting('api-host').toString(),
      port: const Setting('api-port').toInt,
    );
    _dbName = const Setting('api-database').toString();
    _authToken = const Setting('api-auth-token').toString();
    super.initState();
  }
  //
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          NavigationPanel(
            selectedPageIndex: 3,
            appRefreshStream: widget._appRefreshStream,
            fireRefreshEvent: widget._fireRefreshEvent,
          ),
          Expanded(
            child: LoadingPageBody(
              appRefreshStream: widget._appRefreshStream,
              apiAddress: _apiAddress,
              dbName: _dbName,
              authToken: _authToken,
            ),
          ),
        ],
      ),
      floatingActionButton: RunCalculationButton(
        fireRefreshEvent: widget._fireRefreshEvent,
      ),
    );
  }
}
