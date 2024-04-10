import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core_app_settings.dart';
import 'package:sss_computing_client/models/cargo/cargos.dart';
import 'package:sss_computing_client/presentation/cargo/widgets/cargo_table.dart';
import 'package:sss_computing_client/widgets/core/future_builder_widget.dart';

/// Body of [CargoPage]
class CargoBody extends StatefulWidget {
  final Cargos _cargos;
  final List<CargoColumn> _columns;

  /// Creates [CargoBody] for [CargoPage]
  const CargoBody({
    super.key,
    required Cargos cargos,
    required List<CargoColumn> columns,
  })  : _cargos = cargos,
        _columns = columns;

  ///
  @override
  State<CargoBody> createState() => _CargoBodyState();
}

///
class _CargoBodyState extends State<CargoBody> {
  ///
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
              columns: widget._columns,
            ),
          ),
        ),
      ),
    );
  }
}
