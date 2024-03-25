import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core_app_settings.dart';
import 'package:hmi_widgets/hmi_widgets.dart';
import 'package:sss_computing_client/models/cargos/cargos.dart';
import 'package:sss_computing_client/presentation/cargo/widgets/cargo_table.dart';
import 'package:sss_computing_client/validation/real_validation_case.dart';
import 'package:sss_computing_client/widgets/core/future_builder_widget.dart';

class CargoBody extends StatefulWidget {
  final Cargos _cargos;
  const CargoBody({super.key, required Cargos cargos}) : _cargos = cargos;

  @override
  State<CargoBody> createState() => _CargoBodyState();
}

class _CargoBodyState extends State<CargoBody> {
  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(const Setting('padding').toDouble),
          child: FutureBuilderWidget(
            onFuture: widget._cargos.fetchAll,
            caseData: (context, data) => CargoTable(
              cargos: widget._cargos,
              rows: data,
              columns: [
                const CargoColumn(
                  grow: 2,
                  key: 'name',
                  type: 'string',
                  name: 'Name',
                  isEditable: true,
                  defaultValue: '',
                  validator: Validator(cases: [
                    MinLengthValidationCase(1),
                  ]),
                ),
                CargoColumn<double>(
                  grow: 1,
                  key: 'weight',
                  type: 'real',
                  name: 'Weight [t]',
                  isEditable: true,
                  defaultValue: '0.0',
                  valueParser: (text) => double.parse(text),
                  validator: const Validator(cases: [
                    MinLengthValidationCase(1),
                    RealValidationCase(),
                  ]),
                ),
                CargoColumn<double>(
                  grow: 1,
                  key: 'vcg',
                  type: 'real',
                  name: 'VCG [m]',
                  isEditable: true,
                  defaultValue: '0.0',
                  valueParser: (text) => double.parse(text),
                  validator: const Validator(cases: [
                    MinLengthValidationCase(1),
                    RealValidationCase(),
                  ]),
                ),
                CargoColumn<double>(
                  grow: 1,
                  key: 'lcg',
                  type: 'real',
                  name: 'LCG [m]',
                  isEditable: true,
                  defaultValue: '0.0',
                  valueParser: (text) => double.parse(text),
                  validator: const Validator(cases: [
                    MinLengthValidationCase(1),
                    RealValidationCase(),
                  ]),
                ),
                CargoColumn<double>(
                  grow: 1,
                  key: 'tcg',
                  type: 'real',
                  name: 'TCG [m]',
                  isEditable: true,
                  defaultValue: '0.0',
                  valueParser: (text) => double.parse(text),
                  validator: const Validator(cases: [
                    MinLengthValidationCase(1),
                    RealValidationCase(),
                  ]),
                ),
                CargoColumn<double>(
                  grow: 1,
                  key: 'x_1',
                  type: 'real',
                  name: 'X1 [m]',
                  isEditable: true,
                  defaultValue: '0.0',
                  valueParser: (text) => double.parse(text),
                  validator: const Validator(cases: [
                    MinLengthValidationCase(1),
                    RealValidationCase(),
                  ]),
                ),
                CargoColumn<double>(
                  grow: 1,
                  key: 'x_2',
                  type: 'real',
                  name: 'X2 [m]',
                  isEditable: true,
                  defaultValue: '0.0',
                  valueParser: (text) => double.parse(text),
                  validator: const Validator(cases: [
                    MinLengthValidationCase(1),
                    RealValidationCase(),
                  ]),
                ),
                const CargoColumn<double>(
                  grow: 1,
                  key: 'm_fsx',
                  type: 'real',
                  name: 'Mf.sx [t∙m]',
                  isEditable: false,
                  defaultValue: '—',
                ),
                const CargoColumn<double>(
                  grow: 1,
                  key: 'm_fsy',
                  type: 'real',
                  name: 'Mf.sy [t∙m]',
                  isEditable: false,
                  defaultValue: '—',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
