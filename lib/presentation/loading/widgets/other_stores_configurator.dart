import 'dart:convert';
import 'package:collection/collection.dart';
import 'package:ext_rw/ext_rw.dart' hide FieldType;
import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core.dart';
import 'package:hmi_core/hmi_core_app_settings.dart';
import 'package:hmi_widgets/hmi_widgets.dart';
import 'package:sss_computing_client/core/extensions/strings.dart';
import 'package:sss_computing_client/core/models/cargo/cargo.dart';
import 'package:sss_computing_client/core/models/cargo/json_cargo.dart';
import 'package:sss_computing_client/core/models/cargo/pg_stores_others.dart';
import 'package:sss_computing_client/core/models/field/field_data.dart';
import 'package:sss_computing_client/core/models/frame/frames.dart';
import 'package:sss_computing_client/core/models/figure/json_svg_path_projections.dart';
import 'package:sss_computing_client/core/models/figure/path_projections.dart';
import 'package:sss_computing_client/core/models/record/field_record.dart';
import 'package:sss_computing_client/core/widgets/future_builder_widget.dart';
import 'package:sss_computing_client/presentation/loading/widgets/cargo_column/cargo_lcg_column.dart';
import 'package:sss_computing_client/presentation/loading/widgets/cargo_column/cargo_name_column.dart';
import 'package:sss_computing_client/presentation/loading/widgets/cargo_column/cargo_tcg_column.dart';
import 'package:sss_computing_client/presentation/loading/widgets/cargo_column/cargo_type_column.dart';
import 'package:sss_computing_client/presentation/loading/widgets/cargo_column/cargo_vcg_column.dart';
import 'package:sss_computing_client/presentation/loading/widgets/cargo_column/cargo_weight_column.dart';
import 'package:sss_computing_client/presentation/loading/widgets/cargo_schemes.dart';
import 'package:sss_computing_client/core/widgets/table/editing_table.dart';
import 'package:sss_computing_client/presentation/other_stores_cargo/other_stores_cargo_page.dart';
///
/// Configurator for ship other stores cargo.
class OtherStoresConfigurator extends StatefulWidget {
  final List<Cargo> _cargos;
  final Stream<DsDataPoint<bool>> _appRefreshStream;
  final void Function() _fireRefreshEvent;
  final ApiAddress _apiAddress;
  final String _dbName;
  final String? _authToken;
  ///
  /// Creates configurator for ship other stores cargo.
  ///
  ///   [cargos] – list of [Cargo] to be configured.
  ///   [appRefreshStream] – stream with events causing data to be updated.
  ///   [fireRefreshEvent] – callback for triggering refresh event, called
  /// when calculation succeeds or fails;
  ///   [apiAddress] – [ApiAddress] of server that interact with database;
  ///   [dbName] – name of the database;
  ///   [authToken] – string authentication token for accessing server;
  const OtherStoresConfigurator({
    super.key,
    required List<Cargo> cargos,
    required Stream<DsDataPoint<bool>> appRefreshStream,
    required void Function() fireRefreshEvent,
    required ApiAddress apiAddress,
    required String dbName,
    required String? authToken,
  })  : _cargos = cargos,
        _appRefreshStream = appRefreshStream,
        _fireRefreshEvent = fireRefreshEvent,
        _apiAddress = apiAddress,
        _dbName = dbName,
        _authToken = authToken;
  //
  @override
  State<OtherStoresConfigurator> createState() =>
      _OtherStoresConfiguratorState();
}
class _OtherStoresConfiguratorState extends State<OtherStoresConfigurator> {
  late List<Cargo> _cargos;
  Cargo? _selectedCargo;
  @override
  void initState() {
    _cargos = widget._cargos;
    super.initState();
  }
  //
  @override
  Widget build(BuildContext context) {
    final blockPadding = const Setting('blockPadding').toDouble;
    final shipId = const Setting('shipId').toInt;
    return Padding(
      padding: EdgeInsets.all(blockPadding),
      child: Column(
        children: [
          Expanded(
            child: FutureBuilderWidget(
              refreshStream: widget._appRefreshStream,
              onFuture: PgFramesReal(
                apiAddress: widget._apiAddress,
                dbName: widget._dbName,
                authToken: widget._authToken,
              ).fetchAll,
              caseData: (context, framesReal, _) => FutureBuilderWidget(
                refreshStream: widget._appRefreshStream,
                onFuture: PgFramesTheoretical(
                  apiAddress: widget._apiAddress,
                  dbName: widget._dbName,
                  authToken: widget._authToken,
                ).fetchAll,
                caseData: (context, framesTheoretical, _) =>
                    FutureBuilderWidget(
                  refreshStream: widget._appRefreshStream,
                  onFuture: FieldRecord<PathProjections>(
                    apiAddress: widget._apiAddress,
                    dbName: widget._dbName,
                    authToken: widget._authToken,
                    tableName: 'ship_geometry',
                    fieldName: 'hull_svg',
                    toValue: (value) => JsonSvgPathProjections(
                      json: json.decode(value),
                    ),
                    filter: {'id': shipId},
                  ).fetch,
                  caseData: (context, hull, _) => FutureBuilderWidget(
                    refreshStream: widget._appRefreshStream,
                    onFuture: FieldRecord<PathProjections>(
                      apiAddress: widget._apiAddress,
                      dbName: widget._dbName,
                      authToken: widget._authToken,
                      tableName: 'ship_geometry',
                      fieldName: 'hull_beauty_svg',
                      toValue: (value) => JsonSvgPathProjections(
                        json: json.decode(value),
                      ),
                      filter: {'id': shipId},
                    ).fetch,
                    caseData: (context, hullBeauty, _) => CargoSchemes(
                      cargos: _cargos,
                      hull: hull,
                      hullBeauty: hullBeauty,
                      framesReal: framesReal,
                      framesTheoretical: framesTheoretical,
                      onCargoTap: _toggleCargo,
                      selectedCargo: _selectedCargo,
                    ),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: blockPadding),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton.filled(
                icon: const Icon(Icons.add_rounded),
                onPressed: _handleCargoAdd,
              ),
              SizedBox(width: blockPadding),
              IconButton.filled(
                icon: const Icon(Icons.remove_rounded),
                onPressed: switch (_selectedCargo) {
                  final Cargo cargo => () => _handleCargoRemove(cargo),
                  _ => null,
                },
              ),
              SizedBox(width: blockPadding),
              IconButton.filled(
                icon: const Icon(Icons.edit_rounded),
                onPressed: switch (_selectedCargo) {
                  final Cargo cargo => () => _handleCargoEdit(cargo),
                  _ => null,
                },
              ),
            ],
          ),
          SizedBox(height: blockPadding),
          Expanded(
            child: EditingTable<Cargo>(
              selectedRow: _selectedCargo,
              rowHeight: const Setting('tableRowHeight').toDouble,
              onRowTap: _toggleCargo,
              onRowUpdate: (_, oldCargo) => _refetchCargo(oldCargo),
              columns: [
                const CargoTypeColumn(),
                CargoNameColumn(
                  useDefaultEditing: true,
                  buildRecord: (cargo, toValue) => FieldRecord<String?>(
                    dbName: widget._dbName,
                    apiAddress: ApiAddress(
                      host: widget._apiAddress.host,
                      port: widget._apiAddress.port,
                    ),
                    authToken: widget._authToken,
                    tableName: 'cargo',
                    fieldName: 'name',
                    filter: {'id': cargo.id},
                    toValue: toValue,
                  ),
                ),
                CargoWeightColumn(
                  useDefaultEditing: true,
                  buildRecord: (cargo, toValue) => FieldRecord<double?>(
                    dbName: widget._dbName,
                    apiAddress: ApiAddress(
                      host: widget._apiAddress.host,
                      port: widget._apiAddress.port,
                    ),
                    authToken: widget._authToken,
                    tableName: 'cargo',
                    fieldName: 'mass',
                    filter: {'id': cargo.id},
                    toValue: toValue,
                  ),
                ),
                CargoLCGColumn(
                  useDefaultEditing: true,
                  buildRecord: (cargo, toValue) => FieldRecord<double?>(
                    dbName: widget._dbName,
                    apiAddress: ApiAddress(
                      host: widget._apiAddress.host,
                      port: widget._apiAddress.port,
                    ),
                    authToken: widget._authToken,
                    tableName: 'cargo',
                    fieldName: 'mass_shift_x',
                    filter: {'id': cargo.id},
                    toValue: toValue,
                  ),
                ),
                CargoTCGColumn(
                  useDefaultEditing: true,
                  buildRecord: (cargo, toValue) => FieldRecord<double?>(
                    dbName: widget._dbName,
                    apiAddress: ApiAddress(
                      host: widget._apiAddress.host,
                      port: widget._apiAddress.port,
                    ),
                    authToken: widget._authToken,
                    tableName: 'cargo',
                    fieldName: 'mass_shift_y',
                    filter: {'id': cargo.id},
                    toValue: toValue,
                  ),
                ),
                CargoVCGColumn(
                  useDefaultEditing: true,
                  buildRecord: (cargo, toValue) => FieldRecord<double?>(
                    dbName: widget._dbName,
                    apiAddress: ApiAddress(
                      host: widget._apiAddress.host,
                      port: widget._apiAddress.port,
                    ),
                    authToken: widget._authToken,
                    tableName: 'cargo',
                    fieldName: 'mass_shift_z',
                    filter: {'id': cargo.id},
                    toValue: toValue,
                  ),
                ),
              ],
              rows: _cargos,
            ),
          ),
        ],
      ),
    );
  }
  //
  void _toggleCargo(Cargo? cargo) {
    if (cargo?.id != _selectedCargo?.id) {
      setState(() {
        _selectedCargo = cargo;
      });
      return;
    }
    setState(() {
      _selectedCargo = null;
    });
  }
  //
  void _refetchCargo(Cargo oldCargo) {
    final id = oldCargo.id;
    if (id == null) return;
    PgStoresOthers(
      dbName: widget._dbName,
      apiAddress: widget._apiAddress,
      authToken: widget._authToken,
    )
        .fetchById(id)
        .then(
          (result) => switch (result) {
            Ok(value: final newCargo) => _updateCargo(newCargo),
            Err(:final error) => _showErrorMessage(error.message),
          },
        )
        .onError(
          (_, __) => _showErrorMessage(const Localized('Unknown error').v),
        );
  }
  //
  void _updateCargo(Cargo newCargo) {
    final idx = _cargos.indexWhere((cargo) => cargo.id == newCargo.id);
    if (idx < 0 || !mounted) return;
    setState(() {
      if (_selectedCargo?.id == newCargo.id) _selectedCargo = newCargo;
      _cargos = [
        ..._cargos.slice(0, idx),
        newCargo,
        ..._cargos.slice(idx + 1),
      ];
    });
  }
  //
  void _handleCargoAdd() {
    final navigator = Navigator.of(context);
    navigator.push(
      MaterialPageRoute(
        builder: (context) => OtherStoresCargoPage(
          label: const Localized('Other stores').v,
          cargo: const JsonCargo(json: {}),
          onClose: navigator.pop,
          onSave: (fieldsData) async {
            final cargo = JsonCargo(json: {
              for (final field in fieldsData)
                field.id: field.toValue(field.controller.text),
            });
            switch (await PgStoresOthers(
              apiAddress: widget._apiAddress,
              dbName: widget._dbName,
              authToken: widget._authToken,
            ).add(cargo)) {
              case Ok():
                navigator.pop();
                widget._fireRefreshEvent();
                return Ok(fieldsData);
              case Err(:final error):
                return Err(error);
            }
          },
        ),
        maintainState: false,
      ),
    );
  }
  //
  void _handleCargoRemove(Cargo cargo) async {
    switch (await PgStoresOthers(
      apiAddress: widget._apiAddress,
      dbName: widget._dbName,
      authToken: widget._authToken,
    ).remove(cargo)) {
      case Ok():
        widget._fireRefreshEvent();
      case Err(:final error):
        const Log('Remove cargo').error(error);
        _showErrorMessage(error.message);
    }
  }
  //
  void _handleCargoEdit(Cargo cargo) {
    final navigator = Navigator.of(context);
    navigator.push(
      MaterialPageRoute(
        builder: (context) => OtherStoresCargoPage(
          label: const Localized('Other stores').v,
          cargo: cargo,
          fetchData: true,
          onClose: () {
            navigator.pop();
            _toggleCargo(null);
            widget._fireRefreshEvent();
          },
          onSave: (fieldsData) async {
            final fieldSaveResults = await Future.wait(
              fieldsData.map<Future<ResultF<FieldData>>>(
                (field) async => switch (await field.save()) {
                  Ok(:final value) => Ok(
                      field.copyWith(initialValue: value),
                    ),
                  Err(:final error) => Err(
                      Failure(
                        message: error.message,
                        stackTrace: StackTrace.current,
                      ),
                    ),
                },
              ),
            );
            final resultsOk =
                fieldSaveResults.whereType<Ok<FieldData, Failure>>();
            final resultsErr =
                fieldSaveResults.whereType<Err<FieldData, Failure>>();
            if (resultsErr.isNotEmpty) {
              return Err(Failure(
                message: resultsErr.first.error.message,
                stackTrace: StackTrace.current,
              ));
            }
            return Ok(
              resultsOk.map((result) => result.value).toList(),
            );
          },
        ),
        maintainState: false,
      ),
    );
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
