import 'package:ext_rw/ext_rw.dart';
import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core.dart';
import 'package:hmi_core/hmi_core_app_settings.dart';
import 'package:sss_computing_client/core/models/strength/strength_forces_limited.dart';
import 'package:sss_computing_client/core/models/calculation/calculation_status.dart';
import 'package:sss_computing_client/core/widgets/future_builder_widget.dart';
import 'package:sss_computing_client/core/widgets/navigation_panel.dart';
import 'package:sss_computing_client/presentation/strength/widgets/strength_page_body.dart';

///
class StrengthPage extends StatefulWidget {
  final Stream<DsDataPoint<bool>> _appRefreshStream;
  final void Function() _fireRefreshEvent;
  final CalculationStatus _calculationStatusNotifier;

  ///
  const StrengthPage({
    super.key,
    required Stream<DsDataPoint<bool>> appRefreshStream,
    required void Function() fireRefreshEvent,
    required CalculationStatus calculationStatusNotifier,
  })  : _appRefreshStream = appRefreshStream,
        _fireRefreshEvent = fireRefreshEvent,
        _calculationStatusNotifier = calculationStatusNotifier;
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
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Row(
        children: [
          NavigationPanel(
            selectedPageIndex: 1,
            appRefreshStream: widget._appRefreshStream,
            fireRefreshEvent: widget._fireRefreshEvent,
            calculationStatusNotifier: widget._calculationStatusNotifier,
          ),
          Expanded(
            child: FutureBuilderWidget(
              refreshStream: widget._appRefreshStream,
              onFuture: () => PgShearForcesLimited(
                apiAddress: _apiAddress,
                dbName: _dbName,
                authToken: _authToken,
              ).fetchAll(),
              caseData: (_, shearForces, __) => FutureBuilderWidget(
                refreshStream: widget._appRefreshStream,
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
    );
  }
}
