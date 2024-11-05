import 'package:ext_rw/ext_rw.dart';
import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core.dart';
import 'package:hmi_core/hmi_core_app_settings.dart';
import 'package:sss_computing_client/core/models/cargo/pg_ballast_tanks.dart';
import 'package:sss_computing_client/core/models/cargo/pg_hold_cargos.dart';
import 'package:sss_computing_client/core/models/cargo/pg_stores_others.dart';
import 'package:sss_computing_client/core/models/cargo/pg_stores_tanks.dart';
import 'package:sss_computing_client/core/models/stowage/container/pg_freight_containers.dart';
import 'package:sss_computing_client/core/models/stowage/stowage/stowage_collection/pg_stowage_collection.dart';
import 'package:sss_computing_client/core/models/stowage/voyage/pg_waypoints.dart';
import 'package:sss_computing_client/core/widgets/future_builder_widget.dart';
import 'package:sss_computing_client/core/widgets/tabs/tab_setting.dart';
import 'package:sss_computing_client/core/widgets/tabs/tabs_view_widget.dart';
import 'package:sss_computing_client/presentation/loading/widgets/containers_configurator/containers_configurator.dart';
import 'package:sss_computing_client/presentation/loading/widgets/hold_configurator.dart';
import 'package:sss_computing_client/presentation/loading/widgets/other_stores_configurator.dart';
import 'package:sss_computing_client/presentation/loading/widgets/store_tanks_configurator.dart';
import 'package:sss_computing_client/presentation/loading/widgets/tanks_configurator.dart';
///
/// Body for loading page.
class LoadingPageBody extends StatefulWidget {
  final Stream<DsDataPoint<bool>> _appRefreshStream;
  final void Function() _fireRefreshEvent;
  final ApiAddress _apiAddress;
  final String _dbName;
  final String? _authToken;
  ///
  /// Creates body for loading page.
  ///
  ///   [appRefreshStream] – stream with events causing data to be updated.
  ///   [fireRefreshEvent] – callback for triggering refresh event, called
  /// when calculation succeeds or fails;
  ///   [apiAddress] – [ApiAddress] of server that interact with database;
  ///   [dbName] – name of the database;
  ///   [authToken] – string authentication token for accessing server;
  const LoadingPageBody({
    super.key,
    required Stream<DsDataPoint<bool>> appRefreshStream,
    required void Function() fireRefreshEvent,
    required ApiAddress apiAddress,
    required String dbName,
    required String? authToken,
  })  : _appRefreshStream = appRefreshStream,
        _fireRefreshEvent = fireRefreshEvent,
        _apiAddress = apiAddress,
        _dbName = dbName,
        _authToken = authToken;
  //
  @override
  State<LoadingPageBody> createState() => _LoadingPageBodyState();
}
class _LoadingPageBodyState extends State<LoadingPageBody> {
  late final PgStowageCollection pgStowageCollection;
  //
  @override
  void initState() {
    super.initState();
    pgStowageCollection = PgStowageCollection(
      apiAddress: ApiAddress(
        host: const Setting('api-host').toString(),
        port: const Setting('api-port').toInt,
      ),
      dbName: const Setting('api-database').toString(),
      authToken: const Setting('api-auth-token').toString(),
    );
  }
  //
  @override
  void dispose() {
    pgStowageCollection.dispose();
    super.dispose();
  }
  //
  @override
  Widget build(BuildContext context) {
    return TabViewWidget(
      isScrollable: true,
      physics: const NeverScrollableScrollPhysics(),
      tabSettings: [
        TabSetting(
          label: const Localized('Ballast tank').v,
          content: FutureBuilderWidget(
            refreshStream: widget._appRefreshStream,
            onFuture: PgBallastTanks(
              apiAddress: widget._apiAddress,
              dbName: widget._dbName,
              authToken: widget._authToken,
            ).fetchAll,
            caseData: (context, cargos, _) => TanksConfigurator(
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
            caseData: (context, cargos, _) => StoreTanksConfigurator(
              cargos: cargos,
              appRefreshStream: widget._appRefreshStream,
              apiAddress: widget._apiAddress,
              dbName: widget._dbName,
              authToken: widget._authToken,
            ),
          ),
        ),
        TabSetting(
          label: const Localized('Other stores').v,
          content: FutureBuilderWidget(
            refreshStream: widget._appRefreshStream,
            onFuture: PgStoresOthers(
              apiAddress: widget._apiAddress,
              dbName: widget._dbName,
              authToken: widget._authToken,
            ).fetchAll,
            caseData: (context, cargos, _) => OtherStoresConfigurator(
              cargos: cargos,
              appRefreshStream: widget._appRefreshStream,
              fireRefreshEvent: widget._fireRefreshEvent,
              apiAddress: widget._apiAddress,
              dbName: widget._dbName,
              authToken: widget._authToken,
            ),
          ),
        ),
        TabSetting(
          label: const Localized('Bulk').v,
          content: FutureBuilderWidget(
            refreshStream: widget._appRefreshStream,
            onFuture: PgHoldCargos(
              apiAddress: widget._apiAddress,
              dbName: widget._dbName,
              authToken: widget._authToken,
            ).fetchAll,
            caseData: (context, cargos, _) => HoldConfigurator(
              cargos: cargos,
              appRefreshStream: widget._appRefreshStream,
              fireRefreshEvent: widget._fireRefreshEvent,
              apiAddress: widget._apiAddress,
              dbName: widget._dbName,
              authToken: widget._authToken,
            ),
          ),
        ),
        TabSetting(
          label: const Localized('Containers').v,
          content: FutureBuilderWidget(
            refreshStream: widget._appRefreshStream,
            onFuture: PgFreightContainers(
              apiAddress: widget._apiAddress,
              dbName: widget._dbName,
              authToken: widget._authToken,
            ).fetchAll,
            caseData: (context, containers, _) => FutureBuilderWidget(
              refreshStream: widget._appRefreshStream,
              onFuture: pgStowageCollection.fetch,
              caseData: (context, stowageCollection, _) => FutureBuilderWidget(
                refreshStream: widget._appRefreshStream,
                onFuture: PgWaypoints(
                  apiAddress: widget._apiAddress,
                  dbName: widget._dbName,
                  authToken: widget._authToken,
                ).fetchAll,
                caseData: (context, waypoints, _) => ContainersConfigurator(
                  pgStowageCollection: pgStowageCollection,
                  freightContainersCollection: PgFreightContainers(
                    apiAddress: widget._apiAddress,
                    dbName: widget._dbName,
                    authToken: widget._authToken,
                  ),
                  stowageCollection: stowageCollection,
                  containers: containers,
                  waypoints: waypoints,
                  fireRefreshEvent: widget._fireRefreshEvent,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
