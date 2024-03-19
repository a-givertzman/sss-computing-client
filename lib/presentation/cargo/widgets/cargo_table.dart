import 'package:davi/davi.dart';
import 'package:ext_rw/ext_rw.dart';
import 'package:flutter/material.dart';
import 'package:hmi_widgets/hmi_widgets.dart';
import 'package:sss_computing_client/models/cargo/cargo.dart';
import 'package:sss_computing_client/models/persistable/value_record.dart';
import 'package:sss_computing_client/presentation/cargo/widgets/edit_on_tap_field.dart';
import 'package:sss_computing_client/presentation/cargo/widgets/table_view.dart';
import 'package:sss_computing_client/validation/int_validation_case.dart';
import 'package:sss_computing_client/validation/real_validation_case.dart';

class CargoColumn {
  final String type;
  final String key;
  final String name;
  final bool isEditable;
  final double? grow;

  const CargoColumn({
    required this.type,
    required this.key,
    required this.name,
    required this.isEditable,
    this.grow,
  });
}

class CargoTable extends StatefulWidget {
  final List<Cargo> _cargos;
  final List<CargoColumn> _columns;
  const CargoTable({
    super.key,
    required List<Cargo> cargos,
    required List<CargoColumn> columns,
  })  : _cargos = cargos,
        _columns = columns;

  @override
  State<CargoTable> createState() => _CargoTableState();
}

class _CargoTableState extends State<CargoTable> {
  late final List<Cargo> cargos;
  late final DaviModel<Cargo> model;

  @override
  void initState() {
    cargos = widget._cargos;
    model = DaviModel(
      columns: [
        DaviColumn(
          name: 'No.',
          pinStatus: PinStatus.left,
          intValue: (cargo) => cargo.id,
        ),
        ...widget._columns.map(
          (column) => DaviColumn(
            grow: column.grow,
            name: column.name,
            stringValue: column.type == 'string'
                ? (data) => data.asMap()[column.key]
                : null,
            doubleValue: column.type == 'real'
                ? (data) => data.asMap()[column.key]
                : null,
            intValue: column.type == 'int'
                ? (data) => data.asMap()[column.key]
                : null,
            cellBuilder: (_, row) => column.isEditable
                ? _buildEditableCellWidget(context, row, column)
                : Text('${row.data.asMap()[column.key]}'),
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

  Widget _buildEditableCellWidget(
    BuildContext context,
    DaviRow row,
    CargoColumn column,
  ) {
    return EditOnTapField(
      initialValue: '${row.data.asMap()[column.key]}',
      record: ValueRecord(
        filter: {'cargo_id': row.data.id},
        key: column.key,
        tableName: 'cargo_parameters',
        dbName: 'sss-computing',
        apiAddress: ApiAddress.localhost(port: 8080),
      ),
      textColor: Theme.of(context).colorScheme.onSurface,
      iconColor: Theme.of(context).colorScheme.primary,
      errorColor: Theme.of(context).stateColors.error,
      onSave: (value) => setState(() {
        final idx = cargos.indexOf(row.data);
        final newValue = switch (column.type) {
          'real' => double.tryParse(value),
          'int' => int.tryParse(value),
          'string' || _ => value,
        };
        final newData = row.data.asMap()..[column.key] = newValue;
        cargos[idx] = JsonCargo(json: newData);
        model.replaceRows(cargos);
      }),
      validator: switch (column.type) {
        'real' => const Validator(cases: [
            MinLengthValidationCase(1),
            RealValidationCase(),
          ]),
        'int' => const Validator(cases: [
            MinLengthValidationCase(1),
            IntValidationCase(),
          ]),
        'string' || _ => const Validator(cases: [
            MinLengthValidationCase(1),
            MaxLengthValidationCase(250),
          ]),
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return TableView<Cargo>(
      model: model,
    );
  }
}
