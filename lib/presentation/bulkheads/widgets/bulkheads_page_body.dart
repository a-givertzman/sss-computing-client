import 'package:ext_rw/ext_rw.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core.dart';
import 'package:hmi_core/hmi_core_app_settings.dart';
import 'package:hmi_widgets/hmi_widgets.dart';
import 'package:sss_computing_client/core/extensions/strings.dart';
import 'package:sss_computing_client/core/models/bulkheads/bulkhead_place.dart';
import 'package:sss_computing_client/core/models/bulkheads/pg_bulkhead_places.dart';
import 'package:sss_computing_client/core/models/bulkheads/pg_bulkheads.dart';
import 'package:sss_computing_client/core/widgets/disabled_widget.dart';
import 'package:sss_computing_client/core/widgets/future_builder_widget.dart';
import 'package:sss_computing_client/presentation/bulkheads/widgets/bulkhead_places_section.dart';
import 'package:sss_computing_client/presentation/bulkheads/widgets/bulkhead_removed_section.dart';
import 'package:sss_computing_client/presentation/bulkheads/widgets/bulkheads_table.dart';
///
/// Display configurator of ship's grain bulkheads.
class BulkheadsPageBody extends StatefulWidget {
  final double _bulkheadHeight;
  ///
  /// Creates widget displaying configurator of ship's grain bulkheads.
  const BulkheadsPageBody({
    super.key,
    double bulkheadHeight = 256.0,
  }) : _bulkheadHeight = bulkheadHeight;
  //
  @override
  State<BulkheadsPageBody> createState() => _BulkheadsPageBodyState();
}
///
class _BulkheadsPageBodyState extends State<BulkheadsPageBody> {
  late final ApiAddress _apiAddress;
  late final String _dbName;
  late final String? _authToken;
  bool _isLoading = false;
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
  ///
  @override
  Widget build(BuildContext context) {
    final blockPadding = const Setting('blockPadding').toDouble;
    return FutureBuilderWidget(
      onFuture: PgBulkheadPlaces(
        apiAddress: _apiAddress,
        dbName: _dbName,
        authToken: _authToken,
      ).fetchAll,
      caseData: (context, bulkheadPlaces, refresh) => FutureBuilderWidget(
        onFuture: PgBulkheads(
          apiAddress: _apiAddress,
          dbName: _dbName,
          authToken: _authToken,
        ).fetchAllRemoved,
        caseData: (context, bulkheadsRemoved, _) => FutureBuilderWidget(
          onFuture: PgBulkheads(
            apiAddress: _apiAddress,
            dbName: _dbName,
            authToken: _authToken,
          ).fetchAll,
          caseData: (context, bulkheads, _) => DisabledWidget(
            disabled: _isLoading,
            child: Center(
              child: Padding(
                padding: EdgeInsets.all(blockPadding),
                child: Column(
                  children: [
                    Expanded(
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Flexible(
                            flex: 4,
                            child: BulkheadPlacesSection(
                              bulkheadHeight: widget._bulkheadHeight,
                              label: const Localized('Hold').v,
                              onBulkheadDropped: (bulkheadPlace, bulkheadId) =>
                                  _onBulkheadWillInstalled(
                                bulkheadPlace,
                                bulkheadId,
                                refresh,
                              ),
                              bulkheadPlaces: bulkheadPlaces,
                              bulkheads: bulkheads,
                            ),
                          ),
                          SizedBox(width: blockPadding),
                          Flexible(
                            flex: 1,
                            child: BulkheadRemovedSection(
                              bulkheadHeight: widget._bulkheadHeight,
                              label: const Localized('Overboard').v,
                              bulkheadIds: bulkheadsRemoved
                                  .map((bulkhead) => bulkhead.id)
                                  .toList(),
                              bulkheads: bulkheads,
                              onBulkheadDropped: (bulkheadId) =>
                                  _onBulkheadWillRemoved(
                                bulkheadId,
                                refresh,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: BulkheadsTable(bulkheads: bulkheads),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
  //
  void _onBulkheadWillInstalled(
    BulkheadPlace bulkheadPlace,
    int bulkheadId,
    void Function() refresh,
  ) {
    setState(() {
      _isLoading = true;
    });
    PgBulkheadPlaces(
      apiAddress: _apiAddress,
      dbName: _dbName,
      authToken: _authToken,
    )
        .installBulkheadWithId(bulkheadPlace.id, bulkheadId)
        .then((result) => switch (result) {
              Ok() => setState(() {
                  _isLoading = false;
                  refresh();
                }),
              Err(:final error) => throw error,
            })
        .onError((error, _) => setState(() {
              _showErrorMessage('$error');
              _isLoading = false;
              refresh();
            }));
  }
  //
  void _onBulkheadWillRemoved(
    int bulkheadId,
    void Function() refresh,
  ) {
    setState(() {
      _isLoading = true;
    });
    PgBulkheadPlaces(
      apiAddress: _apiAddress,
      dbName: _dbName,
      authToken: _authToken,
    )
        .removeBulkheadWithId(bulkheadId)
        .then((result) => switch (result) {
              Ok() => setState(() {
                  _isLoading = false;
                  refresh();
                }),
              Err(:final error) => throw error,
            })
        .onError((error, _) => setState(() {
              _isLoading = false;
              _showErrorMessage('$error');
              refresh();
            }));
  }
  //
  void _showErrorMessage(String message) {
    if (!mounted) return;
    BottomMessage.error(
      message: message.truncate(),
      displayDuration: Duration(
        milliseconds: const Setting('errorMessageDisplayDuration').toInt,
      ),
    ).show(context);
  }
}
