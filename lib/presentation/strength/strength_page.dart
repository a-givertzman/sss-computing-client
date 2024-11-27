import 'package:ext_rw/ext_rw.dart';
import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core_app_settings.dart';
import 'package:provider/provider.dart';
import 'package:sss_computing_client/core/models/strength/strength_forces_limited.dart';
import 'package:sss_computing_client/core/models/calculation/calculation_status.dart';
import 'package:sss_computing_client/core/widgets/future_builder_widget.dart';
import 'package:sss_computing_client/core/widgets/navigation_panel.dart';
import 'package:sss_computing_client/presentation/strength/widgets/strength_page_body.dart';
///
class StrengthPage extends StatefulWidget {
  final int _pageIndex;
  ///
  const StrengthPage({
    super.key,
    required int pageIndex,
  }) : _pageIndex = pageIndex;
  //
  @override
  State<StrengthPage> createState() => _StrengthPageState();
}
///
class _StrengthPageState extends State<StrengthPage> {
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
              child: FutureBuilderWidget(
                refreshStream: status.refreshStream,
                onFuture: () => PgShearForcesLimited(
                  apiAddress: _apiAddress,
                  dbName: _dbName,
                  authToken: _authToken,
                ).fetchAll(),
                caseData: (_, shearForces, __) => FutureBuilderWidget(
                  refreshStream: status.refreshStream,
                  onFuture: () => PgBendingMomentsLimited(
                    apiAddress: _apiAddress,
                    dbName: _dbName,
                    authToken: _authToken,
                  ).fetchAll(),
                  caseData: (_, bendingMoments, __) => StrengthPageBody(
                    shearForces: shearForces,
                    bendingMoments: bendingMoments,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
