import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core_app_settings.dart';
import 'package:sss_computing_client/models/cargos/cargos.dart';
import 'package:sss_computing_client/presentation/cargo/widgets/cargo_table.dart';
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
              columns: const [
                CargoColumn(
                  grow: 2,
                  key: 'name',
                  type: 'string',
                  name: 'Name',
                  isEditable: true,
                  defaultValue: '',
                ),
                CargoColumn(
                  grow: 1,
                  key: 'weight',
                  type: 'real',
                  name: 'Weight [t]',
                  isEditable: true,
                  defaultValue: '0.0',
                ),
                CargoColumn(
                  grow: 1,
                  key: 'vcg',
                  type: 'real',
                  name: 'VCG [m]',
                  isEditable: true,
                  defaultValue: '0.0',
                ),
                CargoColumn(
                  grow: 1,
                  key: 'lcg',
                  type: 'real',
                  name: 'LCG [m]',
                  isEditable: true,
                  defaultValue: '0.0',
                ),
                CargoColumn(
                  grow: 1,
                  key: 'tcg',
                  type: 'real',
                  name: 'TCG [m]',
                  isEditable: true,
                  defaultValue: '0.0',
                ),
                CargoColumn(
                  grow: 1,
                  key: 'x_1',
                  type: 'real',
                  name: 'X1 [m]',
                  isEditable: true,
                  defaultValue: '0.0',
                ),
                CargoColumn(
                  grow: 1,
                  key: 'x_2',
                  type: 'real',
                  name: 'X2 [m]',
                  isEditable: true,
                  defaultValue: '0.0',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
