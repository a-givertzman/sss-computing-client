import 'package:ext_rw/ext_rw.dart';
import 'package:flutter/material.dart';
import 'package:hmi_widgets/hmi_widgets.dart';
import 'package:sss_computing_client/models/cargos/cargos.dart';
import 'package:sss_computing_client/models/persistable/value_record.dart';
import 'package:sss_computing_client/presentation/cargo/widgets/cargo_body.dart';
import 'package:sss_computing_client/presentation/cargo/widgets/cargo_table.dart';
import 'package:sss_computing_client/validation/real_validation_case.dart';

/// Page with cargo related information
class CargoPage extends StatelessWidget {
  ///
  const CargoPage({super.key});

  ///
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CargoBody(
        cargos: const DbCargos(
          dbName: 'sss-computing',
          apiAddress: ApiAddress(host: '10.131.145.138', port: 8080),
        ),
        columns: [
          CargoColumn(
            grow: 2,
            key: 'name',
            type: 'text',
            name: 'Name',
            isEditable: true,
            buildRecord: (id) => ValueRecord(
              filter: {'space_id': id},
              key: 'name',
              tableName: 'load_space',
              dbName: 'sss-computing',
              apiAddress: const ApiAddress(
                host: '10.131.145.138',
                port: 8080,
              ),
            ),
            defaultValue: '',
            parseValue: (text) => text,
            validator: const Validator(cases: [
              MinLengthValidationCase(1),
            ]),
          ),
          CargoColumn<double>(
            grow: 1,
            key: 'mass',
            type: 'real',
            name: 'Weight [t]',
            isEditable: true,
            buildRecord: (id) => ValueRecord(
              filter: {'space_id': id},
              key: 'mass',
              tableName: 'load_space',
              dbName: 'sss-computing',
              apiAddress: const ApiAddress(
                host: '10.131.145.138',
                port: 8080,
              ),
            ),
            defaultValue: '0.0',
            parseValue: (text) => double.parse(text),
            validator: const Validator(cases: [
              MinLengthValidationCase(1),
              RealValidationCase(),
            ]),
          ),
          CargoColumn<double>(
            grow: 1,
            key: 'center_x',
            type: 'real',
            name: 'VCG [m]',
            isEditable: true,
            buildRecord: (id) => ValueRecord(
              filter: {'space_id': id},
              key: 'center_x',
              tableName: 'load_space',
              dbName: 'sss-computing',
              apiAddress: const ApiAddress(
                host: '10.131.145.138',
                port: 8080,
              ),
            ),
            defaultValue: '0.0',
            parseValue: (text) => double.parse(text),
            validator: const Validator(cases: [
              MinLengthValidationCase(1),
              RealValidationCase(),
            ]),
          ),
          CargoColumn<double>(
            grow: 1,
            key: 'center_y',
            type: 'real',
            name: 'LCG [m]',
            isEditable: true,
            buildRecord: (id) => ValueRecord(
              filter: {'space_id': id},
              key: 'center_y',
              tableName: 'load_space',
              dbName: 'sss-computing',
              apiAddress: const ApiAddress(
                host: '10.131.145.138',
                port: 8080,
              ),
            ),
            defaultValue: '0.0',
            parseValue: (text) => double.parse(text),
            validator: const Validator(cases: [
              MinLengthValidationCase(1),
              RealValidationCase(),
            ]),
          ),
          CargoColumn<double>(
            grow: 1,
            key: 'center_z',
            type: 'real',
            name: 'TCG [m]',
            isEditable: true,
            buildRecord: (id) => ValueRecord(
              filter: {'space_id': id},
              key: 'center_z',
              tableName: 'load_space',
              dbName: 'sss-computing',
              apiAddress: const ApiAddress(
                host: '10.131.145.138',
                port: 8080,
              ),
            ),
            defaultValue: '0.0',
            parseValue: (text) => double.parse(text),
            validator: const Validator(cases: [
              MinLengthValidationCase(1),
              RealValidationCase(),
            ]),
          ),
          CargoColumn<double>(
            grow: 1,
            key: 'bound_x1',
            type: 'real',
            name: 'X1 [m]',
            isEditable: true,
            buildRecord: (id) => ValueRecord(
              filter: {'space_id': id},
              key: 'bound_x1',
              tableName: 'load_space',
              dbName: 'sss-computing',
              apiAddress: const ApiAddress(
                host: '10.131.145.138',
                port: 8080,
              ),
            ),
            defaultValue: '0.0',
            parseValue: (text) => double.parse(text),
            validator: const Validator(cases: [
              MinLengthValidationCase(1),
              RealValidationCase(),
            ]),
          ),
          CargoColumn<double>(
            grow: 1,
            key: 'bound_x2',
            type: 'real',
            name: 'X2 [m]',
            isEditable: true,
            buildRecord: (id) => ValueRecord(
              filter: {'space_id': id},
              key: 'bound_x2',
              tableName: 'load_space',
              dbName: 'sss-computing',
              apiAddress: const ApiAddress(
                host: '10.131.145.138',
                port: 8080,
              ),
            ),
            defaultValue: '0.0',
            parseValue: (text) => double.parse(text),
            validator: const Validator(cases: [
              MinLengthValidationCase(1),
              RealValidationCase(),
            ]),
          ),
          CargoColumn<double>(
            grow: 1,
            key: 'm_f_s_x',
            type: 'real',
            name: 'Mf.sx [t∙m]',
            isEditable: false,
            defaultValue: '—',
            parseValue: (value) => double.tryParse(value) ?? 0.0,
          ),
          CargoColumn<double>(
            grow: 1,
            key: 'm_f_s_y',
            type: 'real',
            name: 'Mf.sy [t∙m]',
            isEditable: false,
            defaultValue: '—',
            parseValue: (value) => double.tryParse(value) ?? 0.0,
          ),
        ],
      ),
    );
  }
}
