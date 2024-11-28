import 'package:ext_rw/ext_rw.dart';
import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core_app_settings.dart';
import 'package:provider/provider.dart';
import 'package:sss_computing_client/core/models/calculation/calculation_status.dart';
import 'package:sss_computing_client/core/widgets/navigation_panel.dart';
import 'package:sss_computing_client/presentation/loading/widgets/loading_page_body.dart';
///
/// Page for configuring ship cargos.
class LoadingPage extends StatefulWidget {
  ///
  /// Creates page for configuring ship cargos.
  ///
  ///   [appRefreshStream] – stream with events causing data to be updated.
  ///   [fireRefreshEvent] – callback for triggering refresh event, called
  /// when calculation succeeds or fails;
  ///   [calculationStatusNotifier] – passed to control calculation status
  /// between many instances of calculation button.
  const LoadingPage({
    super.key,
  });
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
    final theme = Theme.of(context);
    return Scaffold(
      // ignore: deprecated_member_use
      backgroundColor: theme.colorScheme.background,
      body: Consumer<CalculationStatus>(
        builder: (_, status, __) => Row(
          children: [
            NavigationPanel(
              selectedPageIndex: 4,
              calculationStatusNotifier: status,
            ),
            Expanded(
              child: LoadingPageBody(
                appRefreshStream: status.refreshStream,
                fireRefreshEvent: status.fireRefreshEvent,
                apiAddress: _apiAddress,
                dbName: _dbName,
                authToken: _authToken,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
