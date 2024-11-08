import 'package:ext_rw/ext_rw.dart';
import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core.dart';
import 'package:sss_computing_client/core/models/cargo/cargos.dart';
import 'package:sss_computing_client/core/models/cargo/pg_ballast_tanks.dart';
import 'package:sss_computing_client/core/models/cargo/pg_hold_cargos.dart';
import 'package:sss_computing_client/core/models/cargo/pg_stores_others.dart';
import 'package:sss_computing_client/core/models/cargo/pg_stores_tanks.dart';
import 'package:sss_computing_client/core/models/stowage_plan/container/freight_containers.dart';
import 'package:sss_computing_client/core/models/stowage_plan/container/pg_freight_containers.dart';
import 'package:sss_computing_client/core/models/stowage_plan/stowage_collection/pg_stowage_collection.dart';
import 'package:sss_computing_client/core/models/voyage/pg_waypoints.dart';
import 'package:sss_computing_client/core/models/voyage/waypoints.dart';
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
  /// * [appRefreshStream] – stream with events causing data to be updated.
  /// * [fireRefreshEvent] – callback for triggering refresh event, called
  /// when calculation succeeds or fails;
  /// * [apiAddress] – [ApiAddress] of server that interact with database;
  /// * [dbName] – name of the database;
  /// * [authToken] – string authentication token for accessing server;
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
  late final Cargos _ballastTanks;
  late final Cargos _storesTanks;
  late final Cargos _storesOthers;
  late final Cargos _holdCargos;
  late final FreightContainers _freightContainers;
  late final Waypoints _waypoints;
  late final PgStowageCollection _pgStowageCollection;
  //
  @override
  void initState() {
    super.initState();
    _storesTanks = PgStoresTanks(
      apiAddress: widget._apiAddress,
      dbName: widget._dbName,
      authToken: widget._authToken,
    );
    _ballastTanks = PgBallastTanks(
      apiAddress: widget._apiAddress,
      dbName: widget._dbName,
      authToken: widget._authToken,
    );
    _storesOthers = PgStoresOthers(
      apiAddress: widget._apiAddress,
      dbName: widget._dbName,
      authToken: widget._authToken,
    );
    _holdCargos = PgHoldCargos(
      apiAddress: widget._apiAddress,
      dbName: widget._dbName,
      authToken: widget._authToken,
    );
    _freightContainers = PgFreightContainers(
      apiAddress: widget._apiAddress,
      dbName: widget._dbName,
      authToken: widget._authToken,
    );
    _waypoints = PgWaypoints(
      apiAddress: widget._apiAddress,
      dbName: widget._dbName,
      authToken: widget._authToken,
    );
    _pgStowageCollection = PgStowageCollection(
      apiAddress: widget._apiAddress,
      dbName: widget._dbName,
      authToken: widget._authToken,
    );
  }
  //
  @override
  void dispose() {
    _pgStowageCollection.dispose();
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
            onFuture: _ballastTanks.fetchAll,
            caseData: (_, tanks, __) => TanksConfigurator(
              cargos: tanks,
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
            onFuture: _storesTanks.fetchAll,
            caseData: (_, storeTanks, __) => StoreTanksConfigurator(
              cargos: storeTanks,
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
            onFuture: _storesOthers.fetchAll,
            caseData: (_, otherStores, __) => OtherStoresConfigurator(
              cargos: otherStores,
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
            onFuture: _holdCargos.fetchAll,
            caseData: (context, holdCargos, _) => HoldConfigurator(
              cargos: holdCargos,
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
            onFuture: _freightContainers.fetchAll,
            caseData: (_, containers, refetchContainers) => FutureBuilderWidget(
              refreshStream: widget._appRefreshStream,
              onFuture: _pgStowageCollection.fetch,
              caseData: (_, stowageCollection, __) => FutureBuilderWidget(
                refreshStream: widget._appRefreshStream,
                onFuture: _waypoints.fetchAll,
                caseData: (_, waypoints, __) => ContainersConfigurator(
                  pgStowageCollection: _pgStowageCollection,
                  freightContainersCollection: _freightContainers,
                  containers: containers,
                  waypoints: waypoints,
                  refetchContainers: refetchContainers,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
