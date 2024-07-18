import 'dart:convert';
import 'dart:math';
import 'package:ext_rw/ext_rw.dart';
import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core.dart';
import 'package:hmi_core/hmi_core_app_settings.dart';
import 'package:hmi_widgets/hmi_widgets.dart';
import 'package:sss_computing_client/core/models/cargo/cargo.dart';
import 'package:sss_computing_client/core/models/cargo/pg_ballast_tanks.dart';
import 'package:sss_computing_client/core/models/record/cargo_level_record.dart';
import 'package:sss_computing_client/core/models/record/field_record.dart';
import 'package:sss_computing_client/core/models/frame/frames.dart';
import 'package:sss_computing_client/core/validation/real_validation_case.dart';
import 'package:sss_computing_client/core/widgets/future_builder_widget.dart';
import 'package:sss_computing_client/presentation/loading/widgets/cargo_schemes.dart';
import 'package:sss_computing_client/presentation/loading/widgets/cargo_table.dart';
///
class BallastsTanks extends StatefulWidget {
  final Stream<DsDataPoint<bool>> _appRefreshStream;
  final ApiAddress _apiAddress;
  final String _dbName;
  final String? _authToken;
  ///
  const BallastsTanks({
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
  State<BallastsTanks> createState() => _BallastsTanksState();
}
class _BallastsTanksState extends State<BallastsTanks> {
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
              onFuture: PgBallastTanks(
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
                                  message: Localized(cargo.type.label).v,
                                  child: Container(
                                    margin: const EdgeInsets.symmetric(
                                      vertical: 2.0,
                                    ),
                                    decoration: BoxDecoration(
                                      color: cargo.type.color,
                                      borderRadius: const BorderRadius.all(
                                        Radius.circular(2.0),
                                      ),
                                    ),
                                  ),
                                );
                              },
                              width: 28.0,
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
                              width: 150.0,
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
                              parseValue: (value) =>
                                  _formatDouble(
                                    double.parse(value),
                                    fractionDigits: 1,
                                  ) ??
                                  0.0,
                              extractValue: (cargo) =>
                                  _formatDouble(
                                    cargo.weight,
                                    fractionDigits: 1,
                                  ) ??
                                  0.0,
                              validator: const Validator(cases: [
                                MinLengthValidationCase(1),
                                RealValidationCase(),
                              ]),
                            ),
                            CargoColumn<double>(
                              width: 150.0,
                              key: 'volume',
                              type: 'real',
                              name:
                                  '${const Localized('Volume').v} [${const Localized('m^3').v}]',
                              isResizable: true,
                              isEditable: true,
                              record: FieldRecord<String>(
                                fieldName: 'volume',
                                tableName: 'compartment',
                                toValue: (value) => value,
                                apiAddress: widget._apiAddress,
                                dbName: widget._dbName,
                                authToken: widget._authToken,
                              ),
                              defaultValue: '—',
                              parseValue: (value) =>
                                  _formatDouble(
                                    double.parse(value),
                                    fractionDigits: 1,
                                  ) ??
                                  0.0,
                              extractValue: (cargo) =>
                                  _formatDouble(
                                    cargo.volume,
                                    fractionDigits: 1,
                                  ) ??
                                  0.0,
                              validator: const Validator(cases: [
                                MinLengthValidationCase(1),
                                RealValidationCase(),
                              ]),
                            ),
                            CargoColumn<double>(
                              width: 150.0,
                              key: 'density',
                              type: 'real',
                              name:
                                  '${const Localized('Density').v} [${const Localized('t/m^3').v}]',
                              isResizable: true,
                              isEditable: true,
                              record: FieldRecord<String>(
                                fieldName: 'density',
                                tableName: 'compartment',
                                toValue: (value) => value,
                                apiAddress: widget._apiAddress,
                                dbName: widget._dbName,
                                authToken: widget._authToken,
                              ),
                              defaultValue: '—',
                              parseValue: (value) =>
                                  _formatDouble(
                                    double.parse(value),
                                    fractionDigits: 3,
                                  ) ??
                                  0.0,
                              extractValue: (cargo) =>
                                  _formatDouble(
                                    cargo.density,
                                    fractionDigits: 3,
                                  ) ??
                                  0.0,
                              validator: const Validator(cases: [
                                MinLengthValidationCase(1),
                                RealValidationCase(),
                              ]),
                            ),
                            CargoColumn<double>(
                              width: 150.0,
                              key: 'level',
                              type: 'real',
                              name: const Localized('%').v,
                              isResizable: true,
                              isEditable: true,
                              buildCell: (cargo) {
                                return Container(
                                  margin: const EdgeInsets.symmetric(
                                    vertical: 2.0,
                                  ),
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: <Color>[
                                        Theme.of(context).colorScheme.primary,
                                        Theme.of(context).colorScheme.primary,
                                        Colors.transparent,
                                        Colors.transparent,
                                      ],
                                      stops: [
                                        0.0,
                                        cargo.level! / 100.0,
                                        cargo.level! / 100.0,
                                        1.0,
                                      ],
                                      tileMode: TileMode.clamp,
                                    ),
                                    border: Border.all(
                                      width: 1.0,
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                    ),
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(2.0),
                                    ),
                                  ),
                                  child: Center(
                                    child: Text('${_formatDouble(
                                          cargo.level,
                                          fractionDigits: 1,
                                        ) ?? 0.0}'),
                                  ),
                                );
                              },
                              record: CargoLevelRecord(
                                toValue: (value) => value,
                                apiAddress: widget._apiAddress,
                                dbName: widget._dbName,
                                authToken: widget._authToken,
                              ),
                              defaultValue: '—',
                              parseValue: (value) =>
                                  _formatDouble(
                                    double.parse(value),
                                    fractionDigits: 1,
                                  ) ??
                                  0.0,
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
                            CargoColumn<double?>(
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
                              parseValue: (value) => double.tryParse(value),
                              defaultValue: '—',
                              extractValue: (cargo) =>
                                  _formatDouble(
                                    cargo.mfsx,
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
  //
  double? _formatDouble(double? value, {int fractionDigits = 1}) =>
      ((value ?? 0.0) * pow(10, fractionDigits)).round() /
      pow(10, fractionDigits);
}
