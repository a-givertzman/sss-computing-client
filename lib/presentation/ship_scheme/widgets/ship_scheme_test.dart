import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core_app_settings.dart';
import 'package:hmi_widgets/hmi_widgets.dart';
import 'package:sss_computing_client/core/models/cargo/cargo.dart';
import 'package:sss_computing_client/core/models/cargo/cargos.dart';
import 'package:sss_computing_client/core/models/persistable/value_record.dart';
import 'package:sss_computing_client/presentation/cargo/widgets/cargo_table.dart';
import 'package:sss_computing_client/presentation/ship_scheme/widgets/ship_chemes.dart';
import 'package:sss_computing_client/core/validation/real_validation_case.dart';

///
class ShipCargoModel with ChangeNotifier {
  List<Cargo> cargos;
  Cargo? selectedCargo;
  ShipCargoModel({
    required this.cargos,
    this.selectedCargo,
  });

  ///
  void setCargos(List<Cargo> newCargos) {
    cargos = newCargos;
    notifyListeners();
  }

  ///
  void toggleSelected(Cargo? cargo) {
    if (cargo != selectedCargo) {
      selectedCargo = cargo;
      notifyListeners();
      return;
    }
    selectedCargo = null;
    notifyListeners();
  }
}

///
class ShipSchemeTestPage extends StatefulWidget {
  final List<Cargo> _cargos;
  final DbCargos _dbCargos;

  ///
  const ShipSchemeTestPage({
    super.key,
    required List<Cargo> cargos,
    required DbCargos dbCargos,
  })  : _cargos = cargos,
        _dbCargos = dbCargos;

  ///
  @override
  State<ShipSchemeTestPage> createState() => _ShipSchemeTestPageState();
}

///
class _ShipSchemeTestPageState extends State<ShipSchemeTestPage> {
  ///
  @override
  Widget build(BuildContext context) {
    final shipCargoNotifier = ShipCargoModel(cargos: widget._cargos);
    final padding = const Setting('padding').toDouble;
    final blockPadding = padding * 2;
    return Padding(
      padding: EdgeInsets.all(padding),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
            flex: 1,
            child: ShipSchemes(
              shipCargoNotifier: shipCargoNotifier,
              // cargos: widget._cargos,
              // selectedCargo: _selectedCargo,
              // onCargoSelect: _toggleSelectedCargo,
            ),
          ),
          SizedBox(height: blockPadding),
          Expanded(
            flex: 1,
            child: CargoTable(
              cargos: widget._dbCargos,
              // rows: widget._cargos,
              shipCargoNotifier: shipCargoNotifier,
              columns: [
                CargoColumn(
                  type: 'text',
                  key: 'type',
                  name: '',
                  defaultValue: 'other',
                  buildCell: (cargo) => Container(
                    margin: const EdgeInsets.symmetric(vertical: 1.0),
                    color: mapCargoToColor(cargo).withOpacity(0.85),
                  ),
                  width: 10.0,
                ),
                CargoColumn(
                  grow: 2,
                  width: 200.0,
                  key: 'name',
                  type: 'text',
                  name: 'Name',
                  isEditable: true,
                  isResizable: true,
                  buildRecord: (id) => ValueRecord(
                    filter: {'space_id': id},
                    key: 'name',
                    tableName: 'load_space',
                    dbName: widget._dbCargos.dbName,
                    apiAddress: widget._dbCargos.apiAddress,
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
                    dbName: widget._dbCargos.dbName,
                    apiAddress: widget._dbCargos.apiAddress,
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
                    dbName: widget._dbCargos.dbName,
                    apiAddress: widget._dbCargos.apiAddress,
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
                    dbName: widget._dbCargos.dbName,
                    apiAddress: widget._dbCargos.apiAddress,
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
                    dbName: widget._dbCargos.dbName,
                    apiAddress: widget._dbCargos.apiAddress,
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
                    dbName: widget._dbCargos.dbName,
                    apiAddress: widget._dbCargos.apiAddress,
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
                    dbName: widget._dbCargos.dbName,
                    apiAddress: widget._dbCargos.apiAddress,
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
                  key: 'bound_y1',
                  type: 'real',
                  name: 'Y1 [m]',
                  isEditable: true,
                  buildRecord: (id) => ValueRecord(
                    filter: {'space_id': id},
                    key: 'bound_y1',
                    tableName: 'load_space',
                    dbName: widget._dbCargos.dbName,
                    apiAddress: widget._dbCargos.apiAddress,
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
                  key: 'bound_y2',
                  type: 'real',
                  name: 'Y2 [m]',
                  isEditable: true,
                  buildRecord: (id) => ValueRecord(
                    filter: {'space_id': id},
                    key: 'bound_y2',
                    tableName: 'load_space',
                    dbName: widget._dbCargos.dbName,
                    apiAddress: widget._dbCargos.apiAddress,
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
                  key: 'bound_z1',
                  type: 'real',
                  name: 'Z1 [m]',
                  isEditable: true,
                  buildRecord: (id) => ValueRecord(
                    filter: {'space_id': id},
                    key: 'bound_z1',
                    tableName: 'load_space',
                    dbName: widget._dbCargos.dbName,
                    apiAddress: widget._dbCargos.apiAddress,
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
                  key: 'bound_z2',
                  type: 'real',
                  name: 'Z2 [m]',
                  isEditable: true,
                  buildRecord: (id) => ValueRecord(
                    filter: {'space_id': id},
                    key: 'bound_z2',
                    tableName: 'load_space',
                    dbName: widget._dbCargos.dbName,
                    apiAddress: widget._dbCargos.apiAddress,
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
          ),
        ],
      ),
    );
  }
}
