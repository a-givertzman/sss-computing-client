import 'dart:convert';
import 'dart:math';
import 'package:ext_rw/ext_rw.dart';
import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core.dart';
import 'package:hmi_core/hmi_core_app_settings.dart';
import 'package:hmi_widgets/hmi_widgets.dart';
import 'package:sss_computing_client/core/models/cargo/cargo.dart';
import 'package:sss_computing_client/core/models/cargo/cargo_type.dart';
import 'package:sss_computing_client/core/models/cargo/pg_cargos.dart';
import 'package:sss_computing_client/core/models/field_record/field_record.dart';
import 'package:sss_computing_client/core/models/frame/frames.dart';
import 'package:sss_computing_client/core/validation/real_validation_case.dart';
import 'package:sss_computing_client/core/widgets/future_builder_widget.dart';
import 'package:sss_computing_client/presentation/loading/widgets/cargo_schemes.dart';
import 'package:sss_computing_client/presentation/loading/widgets/cargo_table.dart';
///
class LoadingPageBody extends StatefulWidget {
  final Stream<DsDataPoint<bool>> _appRefreshStream;
  final ApiAddress _apiAddress;
  final String _dbName;
  final String? _authToken;
  ///
  const LoadingPageBody({
    super.key,
    required Stream<DsDataPoint<bool>> appRefreshStream,
    required ApiAddress apiAddress,
    required String dbName,
    required String? authToken,
  })  : _appRefreshStream = appRefreshStream,
        _apiAddress = apiAddress,
        _dbName = dbName,
        _authToken = authToken;
  //
  @override
  State<LoadingPageBody> createState() => _LoadingPageBodyState();
}
class _LoadingPageBodyState extends State<LoadingPageBody> {
  Cargo? _selectedCargo;
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
  @override
  Widget build(BuildContext context) {
    final blockPadding = const Setting('blockPadding').toDouble;
    return FutureBuilderWidget(
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
        caseData: (context, framesTheoretical, _) => FutureBuilderWidget(
          refreshStream: widget._appRefreshStream,
          onFuture: () => FieldRecord<Map<String, dynamic>>(
            apiAddress: widget._apiAddress,
            dbName: widget._dbName,
            authToken: widget._authToken,
            tableName: 'ship_parameters',
            fieldName: 'value',
            toValue: (value) => jsonDecode(value),
          ).fetch(filter: {'key': 'hull_svg'}),
          caseData: (context, hull, _) => FutureBuilderWidget(
            refreshStream: widget._appRefreshStream,
            onFuture: () => FieldRecord<Map<String, dynamic>>(
              apiAddress: widget._apiAddress,
              dbName: widget._dbName,
              authToken: widget._authToken,
              tableName: 'ship_parameters',
              fieldName: 'value',
              toValue: (value) => jsonDecode(value),
            ).fetch(filter: {'key': 'hull_beauty_svg'}),
            caseData: (context, hullBeauty, _) => FutureBuilderWidget(
              refreshStream: widget._appRefreshStream,
              onFuture: PgCargos(
                apiAddress: widget._apiAddress,
                dbName: widget._dbName,
                authToken: widget._authToken,
              ).fetchAll,
              caseData: (context, cargos, _) {
                return Padding(
                  padding: EdgeInsets.all(blockPadding),
                  child: Column(
                    children: [
                      Expanded(
                        child: CargoSchemes(
                          cargos: cargos,
                          hull: hull,
                          hullBeauty: hullBeauty,
                          framesReal: framesReal,
                          framesTheoretical: framesTheoretical,
                          onCargoTap: _toggleCargo,
                          selectedCargo: _selectedCargo,
                        ),
                      ),
                      SizedBox(height: blockPadding),
                      Expanded(
                        child: CargoTable(
                          selected: _selectedCargo,
                          onRowTap: _toggleCargo,
                          columns: [
                            CargoColumn(
                              type: 'text',
                              key: 'type',
                              name: '',
                              defaultValue: 'other',
                              buildCell: (cargo) {
                                return Tooltip(
                                  message:
                                      Localized(CargoType(cargo: cargo).label())
                                          .v,
                                  child: Container(
                                    margin: const EdgeInsets.symmetric(
                                      vertical: 2.0,
                                    ),
                                    decoration: BoxDecoration(
                                      color: CargoType(cargo: cargo).color(),
                                      borderRadius: const BorderRadius.all(
                                        Radius.circular(2.0),
                                      ),
                                    ),
                                  ),
                                );
                              },
                              width: 10.0,
                            ),
                            CargoColumn(
                              width: 350.0,
                              key: 'name',
                              type: 'text',
                              name: const Localized('Name').v,
                              isEditable: true,
                              isResizable: true,
                              record: FieldRecord<String>(
                                fieldName: 'name',
                                tableName: 'compartment',
                                toValue: (value) => value,
                                apiAddress: widget._apiAddress,
                                dbName: widget._dbName,
                                authToken: widget._authToken,
                              ),
                              defaultValue: '—',
                              parseValue: (value) => value,
                              validator: const Validator(cases: [
                                MinLengthValidationCase(1),
                              ]),
                            ),
                            CargoColumn<double>(
                              width: 200.0,
                              key: 'mass',
                              type: 'real',
                              name:
                                  '${const Localized('Mass').v} [${const Localized('t').v}]',
                              isResizable: true,
                              isEditable: true,
                              record: FieldRecord<String>(
                                fieldName: 'mass',
                                tableName: 'compartment',
                                toValue: (value) => value,
                                apiAddress: widget._apiAddress,
                                dbName: widget._dbName,
                                authToken: widget._authToken,
                              ),
                              defaultValue: '—',
                              parseValue: (value) => double.parse(value),
                              validator: const Validator(cases: [
                                MinLengthValidationCase(1),
                                RealValidationCase(),
                              ]),
                            ),
                            CargoColumn<double>(
                              grow: 1,
                              key: 'lcg',
                              type: 'real',
                              name:
                                  '${const Localized('LCG').v} [${const Localized('m').v}]',
                              isEditable: false,
                              record: FieldRecord<String>(
                                fieldName: 'lcg',
                                tableName: 'compartment',
                                toValue: (value) => value,
                                apiAddress: widget._apiAddress,
                                dbName: widget._dbName,
                                authToken: widget._authToken,
                              ),
                              defaultValue: '—',
                              extractValue: (cargo) =>
                                  _formatDouble(
                                    cargo.lcg,
                                    fractionDigits: 2,
                                  ) ??
                                  0.0,
                            ),
                            CargoColumn<double>(
                              grow: 1,
                              key: 'tcg',
                              type: 'real',
                              name:
                                  '${const Localized('TCG').v} [${const Localized('m').v}]',
                              isEditable: false,
                              record: FieldRecord<String>(
                                fieldName: 'tcg',
                                tableName: 'compartment',
                                toValue: (value) => value,
                                apiAddress: widget._apiAddress,
                                dbName: widget._dbName,
                                authToken: widget._authToken,
                              ),
                              defaultValue: '—',
                              extractValue: (cargo) =>
                                  _formatDouble(
                                    cargo.tcg,
                                    fractionDigits: 2,
                                  ) ??
                                  0.0,
                            ),
                            CargoColumn<double>(
                              grow: 1,
                              key: 'vcg',
                              type: 'real',
                              name:
                                  '${const Localized('VCG').v} [${const Localized('m').v}]',
                              isEditable: false,
                              record: FieldRecord<String>(
                                fieldName: 'vcg',
                                tableName: 'compartment',
                                toValue: (value) => value,
                                apiAddress: widget._apiAddress,
                                dbName: widget._dbName,
                                authToken: widget._authToken,
                              ),
                              defaultValue: '—',
                              extractValue: (cargo) =>
                                  _formatDouble(
                                    cargo.vcg,
                                    fractionDigits: 2,
                                  ) ??
                                  0.0,
                            ),
                            CargoColumn<double>(
                              grow: 1,
                              key: 'bound_x1',
                              type: 'real',
                              name:
                                  '${const Localized('X1').v} [${const Localized('m').v}]',
                              isEditable: false,
                              record: FieldRecord<String>(
                                fieldName: 'bound_x1',
                                tableName: 'compartment',
                                toValue: (value) => value,
                                apiAddress: widget._apiAddress,
                                dbName: widget._dbName,
                                authToken: widget._authToken,
                              ),
                              defaultValue: '—',
                              extractValue: (cargo) =>
                                  _formatDouble(
                                    cargo.x1,
                                    fractionDigits: 2,
                                  ) ??
                                  0.0,
                            ),
                            CargoColumn<double>(
                              grow: 1,
                              key: 'bound_x2',
                              type: 'real',
                              name:
                                  '${const Localized('X2').v} [${const Localized('m').v}]',
                              isEditable: false,
                              record: FieldRecord<String>(
                                fieldName: 'bound_x2',
                                tableName: 'compartment',
                                toValue: (value) => value,
                                apiAddress: widget._apiAddress,
                                dbName: widget._dbName,
                                authToken: widget._authToken,
                              ),
                              defaultValue: '—',
                              extractValue: (cargo) =>
                                  _formatDouble(
                                    cargo.x2,
                                    fractionDigits: 2,
                                  ) ??
                                  0.0,
                            ),
                            CargoColumn<double>(
                              grow: 1,
                              key: 'm_f_s_x',
                              type: 'real',
                              name:
                                  '${const Localized('Mf.sx').v} [${const Localized('t•m').v}]',
                              isEditable: false,
                              record: FieldRecord<String>(
                                fieldName: 'm_f_s_x',
                                tableName: 'compartment',
                                toValue: (value) => value,
                                apiAddress: widget._apiAddress,
                                dbName: widget._dbName,
                                authToken: widget._authToken,
                              ),
                              defaultValue: '—',
                              extractValue: (cargo) =>
                                  _formatDouble(
                                    cargo.mfsx,
                                    fractionDigits: 0,
                                  ) ??
                                  0.0,
                            ),
                            CargoColumn<double>(
                              grow: 1,
                              key: 'm_f_s_y',
                              type: 'real',
                              name:
                                  '${const Localized('Mf.sy').v} [${const Localized('t•m').v}]',
                              isEditable: false,
                              record: FieldRecord<String>(
                                fieldName: 'm_f_s_y',
                                tableName: 'compartment',
                                toValue: (value) => value,
                                apiAddress: widget._apiAddress,
                                dbName: widget._dbName,
                                authToken: widget._authToken,
                              ),
                              defaultValue: '—',
                              extractValue: (cargo) =>
                                  _formatDouble(
                                    cargo.mfsy,
                                    fractionDigits: 0,
                                  ) ??
                                  0.0,
                            ),
                          ],
                          cargos: cargos,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
  double? _formatDouble(double? value, {int fractionDigits = 1}) =>
      ((value ?? 0.0) * pow(10, fractionDigits)).round() /
      pow(10, fractionDigits);
}
