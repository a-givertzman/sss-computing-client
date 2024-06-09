import 'dart:convert';
import 'package:ext_rw/ext_rw.dart';
import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core.dart';
import 'package:hmi_core/hmi_core_app_settings.dart';
import 'package:hmi_widgets/hmi_widgets.dart';
import 'package:sss_computing_client/core/models/cargo/cargo_type.dart';
import 'package:sss_computing_client/core/models/cargo/pg_cargos.dart';
import 'package:sss_computing_client/core/models/field_record/field_record.dart';
import 'package:sss_computing_client/core/validation/real_validation_case.dart';
import 'package:sss_computing_client/core/widgets/future_builder_widget.dart';
import 'package:sss_computing_client/presentation/loading/widgets/cargo_schemes.dart';
import 'package:sss_computing_client/presentation/loading/widgets/cargo_table.dart';
///
class LoadingPageBody extends StatelessWidget {
  final ApiAddress _apiAddress;
  final String _dbName;
  final String? _authToken;
  ///
  const LoadingPageBody({
    super.key,
    required ApiAddress apiAddress,
    required String dbName,
    required String? authToken,
  })  : _apiAddress = apiAddress,
        _dbName = dbName,
        _authToken = authToken;
  //
  @override
  Widget build(BuildContext context) {
    final blockPadding = const Setting('blockPadding').toDouble;
    return FutureBuilderWidget(
      onFuture: () => FieldRecord<Map<String, dynamic>>(
        apiAddress: _apiAddress,
        dbName: _dbName,
        authToken: _authToken,
        tableName: 'ship_parameters',
        fieldName: 'value',
        toValue: (value) => jsonDecode(value),
      ).fetch(filter: {'key': 'hull_svg'}),
      caseData: (context, hull, _) => FutureBuilderWidget(
        onFuture: () => FieldRecord<Map<String, dynamic>>(
          apiAddress: _apiAddress,
          dbName: _dbName,
          authToken: _authToken,
          tableName: 'ship_parameters',
          fieldName: 'value',
          toValue: (value) => jsonDecode(value),
        ).fetch(filter: {'key': 'hull_beauty_svg'}),
        caseData: (context, hullBeauty, _) {
          return FutureBuilderWidget(
            onFuture: PgCargos(
              apiAddress: _apiAddress,
              dbName: _dbName,
              authToken: _authToken,
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
                        onCargoTap: null,
                      ),
                    ),
                    SizedBox(height: blockPadding),
                    Expanded(
                      child: CargoTable(
                        columns: [
                          CargoColumn(
                            type: 'text',
                            key: 'type',
                            name: '',
                            defaultValue: 'other',
                            buildCell: (cargo) {
                              return Tooltip(
                                message: CargoType(cargo: cargo).label(),
                                child: Container(
                                  margin: const EdgeInsets.symmetric(
                                    vertical: 1.0,
                                  ),
                                  color: CargoType(cargo: cargo).color(),
                                ),
                              );
                            },
                            width: 10.0,
                          ),
                          CargoColumn(
                            width: 200.0,
                            key: 'name',
                            type: 'text',
                            name: const Localized('Name').v,
                            isEditable: true,
                            isResizable: true,
                            record: FieldRecord<String>(
                              fieldName: 'name',
                              tableName: 'compartment',
                              toValue: (value) => value,
                              apiAddress: _apiAddress,
                              dbName: _dbName,
                              authToken: _authToken,
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
                              apiAddress: _apiAddress,
                              dbName: _dbName,
                              authToken: _authToken,
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
                              apiAddress: _apiAddress,
                              dbName: _dbName,
                              authToken: _authToken,
                            ),
                            defaultValue: '—',
                            parseValue: (value) => double.parse(value),
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
                              apiAddress: _apiAddress,
                              dbName: _dbName,
                              authToken: _authToken,
                            ),
                            defaultValue: '—',
                            parseValue: (value) => double.parse(value),
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
                              apiAddress: _apiAddress,
                              dbName: _dbName,
                              authToken: _authToken,
                            ),
                            defaultValue: '—',
                            parseValue: (value) => double.parse(value),
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
                              apiAddress: _apiAddress,
                              dbName: _dbName,
                              authToken: _authToken,
                            ),
                            defaultValue: '—',
                            parseValue: (value) => double.parse(value),
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
                              apiAddress: _apiAddress,
                              dbName: _dbName,
                              authToken: _authToken,
                            ),
                            defaultValue: '—',
                            parseValue: (value) => double.parse(value),
                          ),
                          // CargoColumn<double>(
                          //   grow: 1,
                          //   key: 'bound_y1',
                          //   type: 'real',
                          //   name:
                          //       '${const Localized('Y1').v} [${const Localized('m').v}]',
                          //   isEditable: false,
                          //   record: FieldRecord<String>(
                          //     fieldName: 'bound_y1',
                          //     tableName: 'compartment',
                          //     toValue: (value) => value,
                          //     apiAddress: _apiAddress,
                          //     dbName: _dbName,
                          //     authToken: _authToken,
                          //   ),
                          //   defaultValue: '—',
                          //   parseValue: (value) => double.parse(value),
                          // ),
                          // CargoColumn<double>(
                          //   grow: 1,
                          //   key: 'bound_y2',
                          //   type: 'real',
                          //   name:
                          //       '${const Localized('Y2').v} [${const Localized('m').v}]',
                          //   isEditable: false,
                          //   record: FieldRecord<String>(
                          //     fieldName: 'bound_y2',
                          //     tableName: 'compartment',
                          //     toValue: (value) => value,
                          //     apiAddress: _apiAddress,
                          //     dbName: _dbName,
                          //     authToken: _authToken,
                          //   ),
                          //   defaultValue: '—',
                          //   parseValue: (value) => double.parse(value),
                          // ),
                          // CargoColumn<double>(
                          //   grow: 1,
                          //   key: 'bound_z1',
                          //   type: 'real',
                          //   name:
                          //       '${const Localized('Z1').v} [${const Localized('m').v}]',
                          //   isEditable: false,
                          //   record: FieldRecord<String>(
                          //     fieldName: 'bound_z1',
                          //     tableName: 'compartment',
                          //     toValue: (value) => value,
                          //     apiAddress: _apiAddress,
                          //     dbName: _dbName,
                          //     authToken: _authToken,
                          //   ),
                          //   defaultValue: '—',
                          //   parseValue: (value) => double.parse(value),
                          // ),
                          // CargoColumn<double>(
                          //   grow: 1,
                          //   key: 'bound_z2',
                          //   type: 'real',
                          //   name:
                          //       '${const Localized('Z2').v} [${const Localized('m').v}]',
                          //   isEditable: false,
                          //   record: FieldRecord<String>(
                          //     fieldName: 'bound_z2',
                          //     tableName: 'compartment',
                          //     toValue: (value) => value,
                          //     apiAddress: _apiAddress,
                          //     dbName: _dbName,
                          //     authToken: _authToken,
                          //   ),
                          //   defaultValue: '—',
                          //   parseValue: (value) => double.parse(value),
                          // ),
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
                              apiAddress: _apiAddress,
                              dbName: _dbName,
                              authToken: _authToken,
                            ),
                            defaultValue: '—',
                            parseValue: (value) => double.parse(value),
                          ),
                          CargoColumn<double>(
                            grow: 1,
                            key: 'm_f_s_x',
                            type: 'real',
                            name:
                                '${const Localized('Mf.sy').v} [${const Localized('t•m').v}]',
                            isEditable: false,
                            record: FieldRecord<String>(
                              fieldName: 'm_f_s_y',
                              tableName: 'compartment',
                              toValue: (value) => value,
                              apiAddress: _apiAddress,
                              dbName: _dbName,
                              authToken: _authToken,
                            ),
                            defaultValue: '—',
                            parseValue: (value) => double.parse(value),
                          ),
                        ],
                        cargos: cargos,
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
