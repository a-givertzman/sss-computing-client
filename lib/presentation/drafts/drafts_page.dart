import 'package:ext_rw/ext_rw.dart';
import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core.dart';
import 'package:hmi_core/hmi_core_app_settings.dart';
import 'package:sss_computing_client/core/models/calculation/calculation_status.dart';
import 'package:sss_computing_client/core/widgets/navigation_panel.dart';
import 'package:sss_computing_client/presentation/drafts/widgets/drafts_page_body.dart';
///
/// Page displaying drafts data.
class DraftsPage extends StatefulWidget {
  final Stream<DsDataPoint<bool>> _appRefreshStream;
  final void Function() _fireRefreshEvent;
  final CalculationStatus _calculationStatusNotifier;
  ///
  /// Creates page displaying drafts data.
  ///
  ///   [appRefreshStream] – stream with events causing data to be updated.
  ///   [fireRefreshEvent] – callback for triggering refresh event, called
  /// when calculation succeeds or fails;
  ///   [calculationStatusNotifier] – passed to control calculation status
  /// between many instances of calculation button.
  const DraftsPage({
    super.key,
    required Stream<DsDataPoint<bool>> appRefreshStream,
    required void Function() fireRefreshEvent,
    required CalculationStatus calculationStatusNotifier,
  })  : _appRefreshStream = appRefreshStream,
        _fireRefreshEvent = fireRefreshEvent,
        _calculationStatusNotifier = calculationStatusNotifier;
  //
  @override
  State<DraftsPage> createState() => _DraftsPageState();
}
class _DraftsPageState extends State<DraftsPage> {
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
            calculationStatusNotifier: widget._calculationStatusNotifier,
          ),
          Expanded(
            child: DraftsPageBody(
              appRefreshStream: widget._appRefreshStream,
              apiAddress: _apiAddress,
              dbName: _dbName,
              authToken: _authToken,
            ),
          ),
        ],
      ),
    );
  }
}
