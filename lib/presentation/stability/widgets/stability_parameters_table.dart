import 'package:davi/davi.dart';
import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core.dart';
import 'package:sss_computing_client/core/models/stability_parameter/stability_parameter.dart';
import 'package:sss_computing_client/core/widgets/table/table_view.dart';
///
/// Widget that display [List] of [StabilityParameter]
/// in table view.
class StabilityParametersTable extends StatefulWidget {
  final List<StabilityParameter> _parameters;
  ///
  /// Creates widget that display [List] of [StabilityParameter]
  /// in table view.
  const StabilityParametersTable({
    super.key,
    required List<StabilityParameter> parameters,
  }) : _parameters = parameters;
  //
  @override
  State<StabilityParametersTable> createState() =>
      _StabilityParametersTableState();
}
///
class _StabilityParametersTableState extends State<StabilityParametersTable> {
  late final DaviModel<StabilityParameter> _model;
  //
  @override
  void initState() {
    _model = DaviModel(
      columns: [
        DaviColumn<StabilityParameter>(
          grow: 1,
          name: const Localized('Parameter').v,
          stringValue: (data) =>
              '${data.name}${data.unit != null ? ' [${data.unit}]' : ''}',
        ),
        DaviColumn<StabilityParameter>(
          headerAlignment: Alignment.centerRight,
          cellAlignment: Alignment.centerRight,
          name: const Localized('Value').v,
          stringValue: (data) => data.value.toStringAsFixed(2),
        ),
      ],
    );
    super.initState();
  }
  //
  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }
  //
  @override
  Widget build(BuildContext context) {
    return TableView(
      model: _model..replaceRows(widget._parameters),
      headerHeight: 48.0,
      tableBorderColor: Colors.transparent,
    );
  }
}
