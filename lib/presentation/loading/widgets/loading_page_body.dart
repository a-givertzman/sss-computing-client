import 'package:ext_rw/ext_rw.dart';
import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core.dart';
import 'package:hmi_core/hmi_core_app_settings.dart';
import 'package:hmi_widgets/hmi_widgets.dart';
import 'package:sss_computing_client/core/models/cargo/cargo.dart';
import 'package:sss_computing_client/core/models/field_record/field_record.dart';
import 'package:sss_computing_client/core/validation/real_validation_case.dart';
import 'package:sss_computing_client/presentation/loading/widgets/cargo_table.dart';
///
class LoadingPageBody extends StatelessWidget {
  final List<Cargo> _cargos;
  final ApiAddress _apiAddress;
  final String _dbName;
  final String? _authToken;
  ///
  const LoadingPageBody({
    super.key,
    required List<Cargo> cargos,
    required ApiAddress apiAddress,
    required String dbName,
    required String? authToken,
  })  : _cargos = cargos,
        _apiAddress = apiAddress,
        _dbName = dbName,
        _authToken = authToken;
  @override
  Widget build(BuildContext context) {
    final blockPadding = const Setting('padding').toDouble;
    return Padding(
      padding: EdgeInsets.all(blockPadding),
      child: CargoTable(
        columns: [
          CargoColumn(
            grow: 2,
            width: 200.0,
            key: 'name',
            type: 'text',
            name: const Localized('Name').v,
            isEditable: true,
            isResizable: true,
            record: FieldRecord(
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
            grow: 2,
            width: 200.0,
            key: 'mass',
            type: 'real',
            name: '${const Localized('Mass').v} [${const Localized('t').v}]',
            isResizable: true,
            isEditable: true,
            record: FieldRecord(
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
            key: 'vcg',
            type: 'real',
            name: '${const Localized('VCG').v} [${const Localized('m').v}]',
            isEditable: false,
            record: FieldRecord(
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
            key: 'lcg',
            type: 'real',
            name: '${const Localized('LCG').v} [${const Localized('m').v}]',
            isEditable: false,
            record: FieldRecord(
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
            name: '${const Localized('TCG').v} [${const Localized('m').v}]',
            isEditable: false,
            record: FieldRecord(
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
            key: 'bound_x1',
            type: 'real',
            name: '${const Localized('X1').v} [${const Localized('m').v}]',
            isEditable: false,
            record: FieldRecord(
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
            name: '${const Localized('X2').v} [${const Localized('m').v}]',
            isEditable: false,
            record: FieldRecord(
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
          CargoColumn<double>(
            grow: 1,
            key: 'bound_y1',
            type: 'real',
            name: '${const Localized('Y1').v} [${const Localized('m').v}]',
            isEditable: false,
            record: FieldRecord(
              fieldName: 'bound_y1',
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
            key: 'bound_y2',
            type: 'real',
            name: '${const Localized('Y2').v} [${const Localized('m').v}]',
            isEditable: false,
            record: FieldRecord(
              fieldName: 'bound_y2',
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
            key: 'bound_z1',
            type: 'real',
            name: '${const Localized('Z1').v} [${const Localized('m').v}]',
            isEditable: false,
            record: FieldRecord(
              fieldName: 'bound_z1',
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
            key: 'bound_z2',
            type: 'real',
            name: '${const Localized('Z2').v} [${const Localized('m').v}]',
            isEditable: false,
            record: FieldRecord(
              fieldName: 'bound_z2',
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
            name: '${const Localized('Mf.sx').v} [${const Localized('t•m').v}]',
            isEditable: false,
            record: FieldRecord(
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
            name: '${const Localized('Mf.sy').v} [${const Localized('t•m').v}]',
            isEditable: false,
            record: FieldRecord(
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
        cargos: _cargos,
      ),
    );
  }
}
