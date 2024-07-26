import 'dart:convert';
import 'package:collection/collection.dart';
import 'package:ext_rw/ext_rw.dart' hide FieldType;
import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core.dart';
import 'package:hmi_core/hmi_core_app_settings.dart';
import 'package:hmi_core/hmi_core_result_new.dart';
import 'package:hmi_widgets/hmi_widgets.dart';
import 'package:sss_computing_client/core/models/cargo/cargo.dart';
import 'package:sss_computing_client/core/models/cargo/json_cargo.dart';
import 'package:sss_computing_client/core/models/cargo/pg_all_cargos.dart';
import 'package:sss_computing_client/core/models/cargo/pg_stores_others.dart';
import 'package:sss_computing_client/core/models/field/field_data.dart';
import 'package:sss_computing_client/core/models/frame/frames.dart';
import 'package:sss_computing_client/core/models/record/field_record.dart';
import 'package:sss_computing_client/core/widgets/future_builder_widget.dart';
import 'package:sss_computing_client/core/widgets/table/table_column.dart';
import 'package:sss_computing_client/presentation/loading/widgets/cargo_column/cargo_lcg_column.dart';
import 'package:sss_computing_client/presentation/loading/widgets/cargo_column/cargo_name_column.dart';
import 'package:sss_computing_client/presentation/loading/widgets/cargo_column/cargo_tcg_column.dart';
import 'package:sss_computing_client/presentation/loading/widgets/cargo_column/cargo_type_column.dart';
import 'package:sss_computing_client/presentation/loading/widgets/cargo_column/cargo_vcg_column.dart';
import 'package:sss_computing_client/presentation/loading/widgets/cargo_column/cargo_weight_column.dart';
import 'package:sss_computing_client/presentation/loading/widgets/cargo_column/cargo_x1_column.dart';
import 'package:sss_computing_client/presentation/loading/widgets/cargo_column/cargo_x2_column.dart';
import 'package:sss_computing_client/presentation/loading/widgets/cargo_parameters/cargo_parameters_form.dart';
import 'package:sss_computing_client/presentation/loading/widgets/cargo_schemes.dart';
import 'package:sss_computing_client/core/widgets/table/editing_table.dart';
///
class OtherStoresConfigurator extends StatefulWidget {
  final List<Cargo> _cargos;
  final Stream<DsDataPoint<bool>> _appRefreshStream;
  final void Function() _fireRefreshEvent;
  final ApiAddress _apiAddress;
  final String _dbName;
  final String? _authToken;
  ///
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
                  onFuture: FieldRecord<Map<String, dynamic>>(
                    apiAddress: widget._apiAddress,
                    dbName: widget._dbName,
                    authToken: widget._authToken,
                    tableName: 'ship_parameters',
                    fieldName: 'value',
                    toValue: (value) => jsonDecode(value),
                    filter: {'key': 'hull_svg'},
                  ).fetch,
                  caseData: (context, hull, _) => FutureBuilderWidget(
                    refreshStream: widget._appRefreshStream,
                    onFuture: FieldRecord<Map<String, dynamic>>(
                      apiAddress: widget._apiAddress,
                      dbName: widget._dbName,
                      authToken: widget._authToken,
                      tableName: 'ship_parameters',
                      fieldName: 'value',
                      toValue: (value) => jsonDecode(value),
                      filter: {'key': 'hull_beauty_svg'},
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
                onPressed: () => showDialog(
                  barrierDismissible: false,
                  context: context,
                  builder: (context) => AlertDialog(
                    content: SizedBox(
                      height: 500.0,
                      width: 500.0,
                      child: CargoParametersForm(
                        onClose: () {
                          Navigator.of(context).pop();
                          _toggleCargo(null);
                          widget._fireRefreshEvent();
                        },
                        onSave: (fieldDatas) async {
                          final cargo = JsonCargo(json: {
                            for (final field in fieldDatas)
                              field.id: field.toValue(field.controller.text),
                          });
                          switch (await PgStoresOthers(
                            apiAddress: widget._apiAddress,
                            dbName: widget._dbName,
                            authToken: widget._authToken,
                          ).add(cargo)) {
                            case Ok():
                              Navigator.of(context).pop(context);
                              widget._fireRefreshEvent();
                              return const Ok([]);
                            case Err(:final error):
                              return Err(error);
                          }
                        },
                        fieldData: [
                          ..._mapColumnsToFields(
                            fetch: false,
                            columns: [
                              CargoNameColumn(
                                apiAddress: widget._apiAddress,
                                dbName: widget._dbName,
                                authToken: widget._authToken,
                              ),
                              CargoWeightColumn(
                                apiAddress: widget._apiAddress,
                                dbName: widget._dbName,
                                authToken: widget._authToken,
                              ),
                              CargoLCGColumn(
                                apiAddress: widget._apiAddress,
                                dbName: widget._dbName,
                                authToken: widget._authToken,
                              ),
                              CargoTCGColumn(
                                apiAddress: widget._apiAddress,
                                dbName: widget._dbName,
                                authToken: widget._authToken,
                              ),
                              CargoVCGColumn(
                                apiAddress: widget._apiAddress,
                                dbName: widget._dbName,
                                authToken: widget._authToken,
                              ),
                              CargoX1Column(
                                apiAddress: widget._apiAddress,
                                dbName: widget._dbName,
                                authToken: widget._authToken,
                              ),
                              CargoX2Column(
                                apiAddress: widget._apiAddress,
                                dbName: widget._dbName,
                                authToken: widget._authToken,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                icon: const Icon(Icons.add_rounded),
              ),
              SizedBox(width: blockPadding),
              IconButton.filled(
                onPressed: switch (_selectedCargo) {
                  // ignore: unused_local_variable
                  Cargo(:final int id) => () async {
                      switch (await PgStoresOthers(
                        apiAddress: widget._apiAddress,
                        dbName: widget._dbName,
                        authToken: widget._authToken,
                      ).remove(_selectedCargo!)) {
                        case Ok():
                          _toggleCargo(null);
                          widget._fireRefreshEvent();
                        case Err(:final error):
                          const Log('Remove cargo').error(error);
                      }
                    },
                  _ => null,
                },
                icon: const Icon(Icons.remove_rounded),
              ),
              SizedBox(width: blockPadding),
              IconButton.filled(
                icon: const Icon(Icons.edit_rounded),
                onPressed: switch (_selectedCargo) {
                  final Cargo cargo => () => showDialog(
                        barrierDismissible: false,
                        context: context,
                        builder: (context) => AlertDialog(
                          content: SizedBox(
                            height: 500.0,
                            width: 500.0,
                            child: CargoParametersForm(
                              onClose: () {
                                Navigator.of(context).pop();
                                _toggleCargo(null);
                                widget._fireRefreshEvent();
                              },
                              onSave: (fieldDatas) async {
                                try {
                                  final fieldsPersisted = await Future.wait(
                                    fieldDatas.map(
                                      (field) async {
                                        switch (await field.save()) {
                                          case Ok(:final value):
                                            return field.copyWithValue(
                                              value,
                                            );
                                          case Err(:final error):
                                            Log('$runtimeType | _persistAll')
                                                .error(error);
                                            throw Err<List<FieldData>, Failure>(
                                              error,
                                            );
                                        }
                                      },
                                    ),
                                  );
                                  return Ok(fieldsPersisted);
                                } on Err<List<FieldData>, Failure> catch (err) {
                                  return err;
                                }
                              },
                              fieldData: [
                                ..._mapColumnsToFields(
                                  fetch: true,
                                  cargo: cargo,
                                  columns: [
                                    CargoNameColumn(
                                      apiAddress: widget._apiAddress,
                                      dbName: widget._dbName,
                                      authToken: widget._authToken,
                                    ),
                                    CargoWeightColumn(
                                      apiAddress: widget._apiAddress,
                                      dbName: widget._dbName,
                                      authToken: widget._authToken,
                                    ),
                                    CargoLCGColumn(
                                      apiAddress: widget._apiAddress,
                                      dbName: widget._dbName,
                                      authToken: widget._authToken,
                                    ),
                                    CargoTCGColumn(
                                      apiAddress: widget._apiAddress,
                                      dbName: widget._dbName,
                                      authToken: widget._authToken,
                                    ),
                                    CargoVCGColumn(
                                      apiAddress: widget._apiAddress,
                                      dbName: widget._dbName,
                                      authToken: widget._authToken,
                                    ),
                                    CargoX1Column(
                                      apiAddress: widget._apiAddress,
                                      dbName: widget._dbName,
                                      authToken: widget._authToken,
                                    ),
                                    CargoX2Column(
                                      apiAddress: widget._apiAddress,
                                      dbName: widget._dbName,
                                      authToken: widget._authToken,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                  _ => null,
                },
              ),
            ],
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
                  apiAddress: widget._apiAddress,
                  dbName: widget._dbName,
                  authToken: widget._authToken,
                ),
                CargoWeightColumn(
                  isEditable: true,
                  apiAddress: widget._apiAddress,
                  dbName: widget._dbName,
                  authToken: widget._authToken,
                ),
                CargoLCGColumn(
                  isEditable: true,
                  apiAddress: widget._apiAddress,
                  dbName: widget._dbName,
                  authToken: widget._authToken,
                ),
                CargoTCGColumn(
                  isEditable: true,
                  apiAddress: widget._apiAddress,
                  dbName: widget._dbName,
                  authToken: widget._authToken,
                ),
                CargoVCGColumn(
                  isEditable: true,
                  apiAddress: widget._apiAddress,
                  dbName: widget._dbName,
                  authToken: widget._authToken,
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
    PgAllCargos(
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
  //
  List<FieldData> _mapColumnsToFields({
    required List<TableColumn<Cargo, dynamic>> columns,
    Cargo cargo = const JsonCargo(json: {}),
    bool fetch = false,
  }) =>
      columns
          .map(
            (col) => FieldData(
              id: col.key,
              label: col.name,
              initialValue: col.defaultValue,
              validator: col.validator,
              record: col.buildRecord(cargo)!,
              toValue: col.parseToValue,
              toText: col.parseToString,
              isPersisted: !fetch,
            ),
          )
          .toList();
}