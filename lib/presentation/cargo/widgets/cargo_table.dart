import 'package:davi/davi.dart';
import 'package:ext_rw/ext_rw.dart';
import 'package:flutter/material.dart';
import 'package:hmi_widgets/hmi_widgets.dart';
import 'package:sss_computing_client/models/cargo/cargo.dart';
import 'package:sss_computing_client/models/persistable/value_record.dart';
import 'package:sss_computing_client/presentation/cargo/widgets/edit_on_tap_field.dart';
import 'package:sss_computing_client/presentation/cargo/widgets/table_view.dart';
import 'package:sss_computing_client/validation/real_validation_case.dart';

class CargoTable extends StatefulWidget {
  final List<Cargo> _cargos;
  const CargoTable({super.key, required List<Cargo> cargos}) : _cargos = cargos;

  @override
  State<CargoTable> createState() => _CargoTableState();
}

class _CargoTableState extends State<CargoTable> {
  late final List<Cargo> cargos;
  late final DaviModel<Cargo> model;

  @override
  // ignore: long-method
  void initState() {
    cargos = widget._cargos;
    model = DaviModel(
      columns: [
        DaviColumn(
          name: 'No.',
          pinStatus: PinStatus.left,
          intValue: (cargo) => cargo.id,
        ),
        DaviColumn(
          grow: 2,
          name: 'Name',
          stringValue: (cargo) => cargo.name,
          cellBuilder: (_, row) => EditOnTapField(
            initialValue: row.data.name,
            record: ValueRecord(
              filter: {'cargo_id': row.data.id},
              key: 'name',
              tableName: 'cargo_parameters',
              dbName: 'sss-computing',
              apiAddress: ApiAddress.localhost(port: 8080),
            ),
            textColor: Theme.of(context).colorScheme.onSurface,
            iconColor: Theme.of(context).colorScheme.primary,
            errorColor: Theme.of(context).stateColors.error,
            onSave: (name) => setState(() {
              final idx = cargos.indexOf(row.data);
              cargos[idx] = row.data.copyWith(
                name: name,
              );
              model.replaceRows(cargos);
            }),
            validator: const Validator(cases: [
              MinLengthValidationCase(1),
              MaxLengthValidationCase(250),
            ]),
          ),
        ),
        DaviColumn(
          grow: 1,
          name: 'Weight [t]',
          doubleValue: (cargo) => cargo.weight,
          cellBuilder: (_, row) => EditOnTapField(
            initialValue: row.data.weight.toString(),
            record: ValueRecord(
              filter: {'cargo_id': row.data.id},
              key: 'weight',
              tableName: 'cargo_parameters',
              dbName: 'sss-computing',
              apiAddress: ApiAddress.localhost(port: 8080),
            ),
            textColor: Theme.of(context).colorScheme.onSurface,
            iconColor: Theme.of(context).colorScheme.primary,
            errorColor: Theme.of(context).stateColors.error,
            onSave: (weight) => setState(() {
              final idx = cargos.indexOf(row.data);
              cargos[idx] = row.data.copyWith(
                weight: double.tryParse(weight),
              );
              model.replaceRows(cargos);
            }),
            validator: const Validator(cases: [
              MinLengthValidationCase(1),
              RealValidationCase(),
            ]),
          ),
        ),
        DaviColumn(
          grow: 1,
          name: 'VCG [m]',
          doubleValue: (cargo) => cargo.vcg,
          cellBuilder: (_, row) => EditOnTapField(
            initialValue: row.data.vcg.toString(),
            record: ValueRecord(
              filter: {'cargo_id': row.data.id},
              key: 'vcg',
              tableName: 'cargo_parameters',
              dbName: 'sss-computing',
              apiAddress: ApiAddress.localhost(port: 8080),
            ),
            textColor: Theme.of(context).colorScheme.onSurface,
            iconColor: Theme.of(context).colorScheme.primary,
            errorColor: Theme.of(context).stateColors.error,
            onSave: (vcg) => setState(() {
              final idx = cargos.indexOf(row.data);
              cargos[idx] = row.data.copyWith(
                vcg: double.tryParse(vcg),
              );
              model.replaceRows(cargos);
            }),
            validator: const Validator(cases: [
              MinLengthValidationCase(1),
              RealValidationCase(),
            ]),
          ),
        ),
        DaviColumn(
          grow: 1,
          name: 'LCG [m]',
          doubleValue: (cargo) => cargo.lcg,
          cellBuilder: (_, row) => EditOnTapField(
            initialValue: row.data.lcg.toString(),
            record: ValueRecord(
              filter: {'cargo_id': row.data.id},
              key: 'lcg',
              tableName: 'cargo_parameters',
              dbName: 'sss-computing',
              apiAddress: ApiAddress.localhost(port: 8080),
            ),
            textColor: Theme.of(context).colorScheme.onSurface,
            iconColor: Theme.of(context).colorScheme.primary,
            errorColor: Theme.of(context).stateColors.error,
            onSave: (lcg) => setState(() {
              final idx = cargos.indexOf(row.data);
              cargos[idx] = row.data.copyWith(
                lcg: double.tryParse(lcg),
              );
              model.replaceRows(cargos);
            }),
            validator: const Validator(cases: [
              MinLengthValidationCase(1),
              RealValidationCase(),
            ]),
          ),
        ),
        DaviColumn(
          grow: 1,
          name: 'TCG [m]',
          doubleValue: (cargo) => cargo.tcg,
          cellBuilder: (_, row) => EditOnTapField(
            initialValue: row.data.tcg.toString(),
            record: ValueRecord(
              filter: {'cargo_id': row.data.id},
              key: 'tcg',
              tableName: 'cargo_parameters',
              dbName: 'sss-computing',
              apiAddress: ApiAddress.localhost(port: 8080),
            ),
            textColor: Theme.of(context).colorScheme.onSurface,
            iconColor: Theme.of(context).colorScheme.primary,
            errorColor: Theme.of(context).stateColors.error,
            onSave: (tcg) => setState(() {
              final idx = cargos.indexOf(row.data);
              cargos[idx] = row.data.copyWith(
                tcg: double.tryParse(tcg),
              );
              model.replaceRows(cargos);
            }),
            validator: const Validator(cases: [
              MinLengthValidationCase(1),
              RealValidationCase(),
            ]),
          ),
        ),
        DaviColumn(
          grow: 1,
          name: 'X1 [m]',
          doubleValue: (cargo) => cargo.x_1,
          cellBuilder: (_, row) => EditOnTapField(
            initialValue: row.data.x_1.toString(),
            record: ValueRecord(
              filter: {'cargo_id': row.data.id},
              key: 'x_1',
              tableName: 'cargo_parameters',
              dbName: 'sss-computing',
              apiAddress: ApiAddress.localhost(port: 8080),
            ),
            textColor: Theme.of(context).colorScheme.onSurface,
            iconColor: Theme.of(context).colorScheme.primary,
            errorColor: Theme.of(context).stateColors.error,
            onSave: (leftSideX) => setState(() {
              final idx = cargos.indexOf(row.data);
              cargos[idx] = row.data.copyWith(
                x_1: double.tryParse(leftSideX),
              );
              model.replaceRows(cargos);
            }),
            validator: const Validator(cases: [
              MinLengthValidationCase(1),
              RealValidationCase(),
            ]),
          ),
        ),
        DaviColumn(
          grow: 1,
          name: 'X2 [m]',
          doubleValue: (cargo) => cargo.x_2,
          cellBuilder: (_, row) => EditOnTapField(
            initialValue: row.data.x_2.toString(),
            record: ValueRecord(
              filter: {'cargo_id': row.data.id},
              key: 'x_2',
              tableName: 'cargo_parameters',
              dbName: 'sss-computing',
              apiAddress: ApiAddress.localhost(port: 8080),
            ),
            textColor: Theme.of(context).colorScheme.onSurface,
            iconColor: Theme.of(context).colorScheme.primary,
            errorColor: Theme.of(context).stateColors.error,
            onSave: (rightSideX) => setState(() {
              final idx = cargos.indexOf(row.data);
              cargos[idx] = row.data.copyWith(
                x_2: double.tryParse(rightSideX),
              );
              model.replaceRows(cargos);
            }),
            validator: const Validator(cases: [
              MinLengthValidationCase(1),
              RealValidationCase(),
            ]),
          ),
        ),
        DaviColumn(
          grow: 1,
          name: 'Mf.sx [t∙m]',
          stringValue: (_) => '—',
        ),
        DaviColumn(
          grow: 1,
          name: 'Mf.sy [t∙m]',
          stringValue: (_) => '—',
        ),
      ],
      rows: cargos,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return TableView<Cargo>(
      model: model,
    );
  }
}
