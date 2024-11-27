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
  final int _pageIndex;
  ///
  const LoadingPage({
    super.key,
    required int pageIndex,
  }) : _pageIndex = pageIndex;
  //
  @override
  State<LoadingPage> createState() => _LoadingPageState();
}
///
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
              selectedPageIndex: widget._pageIndex,
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
