import 'package:ext_rw/ext_rw.dart';
import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core.dart';
import 'package:sss_computing_client/core/models/cargo/pg_ballast_tanks.dart';
import 'package:sss_computing_client/core/models/cargo/pg_stores_tanks.dart';
import 'package:sss_computing_client/core/widgets/future_builder_widget.dart';
import 'package:sss_computing_client/core/widgets/tabs/tab_setting.dart';
import 'package:sss_computing_client/core/widgets/tabs/tabs_view_widget.dart';
import 'package:sss_computing_client/presentation/loading/widgets/ballasts_tanks.dart';
// import 'package:sss_computing_client/presentation/loading/widgets/other_stores.dart';
import 'package:sss_computing_client/presentation/loading/widgets/stores_tanks.dart';
///
class LoadingPageBody extends StatefulWidget {
  final Stream<DsDataPoint<bool>> _appRefreshStream;
  // final void Function() _fireRefreshEvent;
  final ApiAddress _apiAddress;
  final String _dbName;
  final String? _authToken;
  ///
  const LoadingPageBody({
    super.key,
    required Stream<DsDataPoint<bool>> appRefreshStream,
    required void Function() fireRefreshEvent,
    required ApiAddress apiAddress,
    required String dbName,
    required String? authToken,
  })  : _appRefreshStream = appRefreshStream,
        // _fireRefreshEvent = fireRefreshEvent,
        _apiAddress = apiAddress,
        _dbName = dbName,
        _authToken = authToken;
  //
  @override
  State<LoadingPageBody> createState() => _LoadingPageBodyState();
}
class _LoadingPageBodyState extends State<LoadingPageBody> {
  //
  @override
  Widget build(BuildContext context) {
    return TabViewWidget(
      isScrollable: true,
      physics: const NeverScrollableScrollPhysics(),
      tabsSettings: [
        TabSetting(
          label: const Localized('Ballast tank').v,
          content: FutureBuilderWidget(
            refreshStream: widget._appRefreshStream,
            onFuture: PgBallastTanks(
              apiAddress: widget._apiAddress,
              dbName: widget._dbName,
              authToken: widget._authToken,
            ).fetchAll,
            caseData: (context, cargos, _) => BallastsTanks(
              cargos: cargos,
              appRefreshStream: widget._appRefreshStream,
              apiAddress: widget._apiAddress,
              dbName: widget._dbName,
              authToken: widget._authToken,
            ),
          ),
        ),
        TabSetting(
          label: const Localized('Stores tank').v,
          content: FutureBuilderWidget(
            refreshStream: widget._appRefreshStream,
            onFuture: PgStoresTanks(
              apiAddress: widget._apiAddress,
              dbName: widget._dbName,
              authToken: widget._authToken,
            ).fetchAll,
            caseData: (context, cargos, _) => StoresTanks(
              cargos: cargos,
              appRefreshStream: widget._appRefreshStream,
              apiAddress: widget._apiAddress,
              dbName: widget._dbName,
              authToken: widget._authToken,
            ),
          ),
        ),
        // TabSetting(
        //   label: const Localized('Прочие запасы').v,
        //   content: OtherStores(
        //     appRefreshStream: widget._appRefreshStream,
        //     fireRefreshEvent: widget._fireRefreshEvent,
        //     apiAddress: widget._apiAddress,
        //     dbName: widget._dbName,
        //     authToken: widget._authToken,
        //   ),
        // ),
      ],
    );
  }
}
