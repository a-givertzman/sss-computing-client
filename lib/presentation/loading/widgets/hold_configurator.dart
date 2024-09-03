import 'dart:convert';
import 'package:collection/collection.dart';
import 'package:ext_rw/ext_rw.dart';
import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core.dart';
import 'package:hmi_core/hmi_core_app_settings.dart';
import 'package:hmi_core/hmi_core_result_new.dart';
import 'package:hmi_widgets/hmi_widgets.dart';
import 'package:sss_computing_client/core/models/cargo/cargo.dart';
import 'package:sss_computing_client/core/models/cargo/pg_hold_cargos.dart';
import 'package:sss_computing_client/core/models/frame/frames.dart';
import 'package:sss_computing_client/core/models/figure/json_svg_path_projections.dart';
import 'package:sss_computing_client/core/models/figure/path_projections.dart';
import 'package:sss_computing_client/core/models/record/cargo_level_record.dart';
import 'package:sss_computing_client/core/models/record/field_record.dart';
import 'package:sss_computing_client/core/widgets/future_builder_widget.dart';
import 'package:sss_computing_client/core/widgets/table/editing_table.dart';
import 'package:sss_computing_client/presentation/loading/widgets/cargo_column/cargo_lcg_column.dart';
import 'package:sss_computing_client/presentation/loading/widgets/cargo_column/cargo_level_column.dart';
import 'package:sss_computing_client/presentation/loading/widgets/cargo_column/cargo_name_column.dart';
import 'package:sss_computing_client/presentation/loading/widgets/cargo_column/cargo_stowage_factor_column.dart';
import 'package:sss_computing_client/presentation/loading/widgets/cargo_column/cargo_tcg_column.dart';
import 'package:sss_computing_client/presentation/loading/widgets/cargo_column/cargo_type_column.dart';
import 'package:sss_computing_client/presentation/loading/widgets/cargo_column/cargo_vcg_column.dart';
import 'package:sss_computing_client/presentation/loading/widgets/cargo_column/cargo_volume_column.dart';
import 'package:sss_computing_client/presentation/loading/widgets/cargo_column/cargo_weight_column.dart';
import 'package:sss_computing_client/presentation/loading/widgets/cargo_schemes.dart';
///
class HoldConfigurator extends StatefulWidget {
  final List<Cargo> _cargos;
  final Stream<DsDataPoint<bool>> _appRefreshStream;
  final ApiAddress _apiAddress;
  final String _dbName;
  final String? _authToken;
  ///
  const HoldConfigurator({
    super.key,
    required List<Cargo> cargos,
    required Stream<DsDataPoint<bool>> appRefreshStream,
    required ApiAddress apiAddress,
    required String dbName,
    required String? authToken,
  })  : _cargos = cargos,
        _appRefreshStream = appRefreshStream,
        _apiAddress = apiAddress,
        _dbName = dbName,
        _authToken = authToken;
  //
  @override
  State<HoldConfigurator> createState() => _HoldConfiguratorState();
}
class _HoldConfiguratorState extends State<HoldConfigurator> {
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
                    tableName: 'ship_parameters',
                    fieldName: 'value',
                    toValue: (value) => JsonSvgPathProjections(
                      json: json.decode(value),
                    ),
                    filter: {'key': 'hull_svg'},
                  ).fetch,
                  caseData: (context, hull, _) => FutureBuilderWidget(
                    refreshStream: widget._appRefreshStream,
                    onFuture: FieldRecord<PathProjections>(
                      apiAddress: widget._apiAddress,
                      dbName: widget._dbName,
                      authToken: widget._authToken,
                      tableName: 'ship_parameters',
                      fieldName: 'value',
                      toValue: (value) => JsonSvgPathProjections(
                        json: json.decode(value),
                      ),
                      filter: {'key': 'hull_beauty_svg'},
                    ).fetch,
                    caseData: (context, hullBeauty, _) => CargoSchemes(
                      cargos: _cargos,
                      hull: hull,
                      hullBeauty: hullBeauty,
                      framesReal: framesReal,
                      framesTheoretical: framesTheoretical,
                      selectedCargo: _selectedCargo,
                      onCargoTap: _toggleCargo,
                    ),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: blockPadding),
          Expanded(
            child: EditingTable(
              selectedRow: _selectedCargo,
              onRowTap: _toggleCargo,
              onRowUpdate: _refetchCargo,
              columns: [
                const CargoTypeColumn(),
                CargoNameColumn(
                  isEditable: true,
                  buildRecord: (cargo, toValue) => FieldRecord<String?>(
                    dbName: widget._dbName,
                    apiAddress: ApiAddress(
                      host: widget._apiAddress.host,
                      port: widget._apiAddress.port,
                    ),
                    authToken: widget._authToken,
                    tableName: 'compartment',
                    fieldName: 'name',
                    filter: {'id': cargo.id},
                    toValue: toValue,
                  ),
                ),
                CargoWeightColumn(
                  isEditable: true,
                  buildRecord: (cargo, toValue) => FieldRecord<double?>(
                    dbName: widget._dbName,
                    apiAddress: ApiAddress(
                      host: widget._apiAddress.host,
                      port: widget._apiAddress.port,
                    ),
                    authToken: widget._authToken,
                    tableName: 'compartment',
                    fieldName: 'mass',
                    filter: {'id': cargo.id},
                    toValue: toValue,
                  ),
                ),
                CargoVolumeColumn(
                  isEditable: true,
                  buildRecord: (cargo, toValue) => FieldRecord<double?>(
                    dbName: widget._dbName,
                    apiAddress: ApiAddress(
                      host: widget._apiAddress.host,
                      port: widget._apiAddress.port,
                    ),
                    authToken: widget._authToken,
                    tableName: 'compartment',
                    fieldName: 'volume',
                    filter: {'id': cargo.id},
                    toValue: toValue,
                  ),
                ),
                CargoStowageFactorColumn(
                  isEditable: true,
                  buildRecord: (cargo, toValue) => FieldRecord<double?>(
                    dbName: widget._dbName,
                    apiAddress: ApiAddress(
                      host: widget._apiAddress.host,
                      port: widget._apiAddress.port,
                    ),
                    authToken: widget._authToken,
                    tableName: 'compartment',
                    fieldName: 'stowage_factor',
                    filter: {'id': cargo.id},
                    toValue: toValue,
                  ),
                ),
                CargoLevelColumn(
                  isEditable: true,
                  buildRecord: (cargo, toValue) => CargoLevelRecord(
                    dbName: widget._dbName,
                    apiAddress: ApiAddress(
                      host: widget._apiAddress.host,
                      port: widget._apiAddress.port,
                    ),
                    authToken: widget._authToken,
                    tableName: 'hold_compartment',
                    filter: {'id': cargo.id},
                    toValue: toValue,
                  ),
                ),
                const CargoLCGColumn(
                  isEditable: false,
                ),
                const CargoTCGColumn(
                  isEditable: false,
                ),
                const CargoVCGColumn(
                  isEditable: false,
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
    PgHoldCargos(
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
  void _showErrorMessage(String message) {
    if (!mounted) return;
    BottomMessage.error(message: message).show(context);
  }
}
