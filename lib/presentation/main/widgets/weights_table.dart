import 'package:davi/davi.dart';
import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core.dart';
import 'package:sss_computing_client/core/models/weight/displacement_weight.dart';
import 'package:sss_computing_client/core/widgets/table/table_view.dart';
///
/// Table that displays [DisplacementWeight] list.
class WeightsTable extends StatelessWidget {
  final List<DisplacementWeight> _weights;
  ///
  /// Creates table widget that displays [weights] list.
  const WeightsTable({
    super.key,
    weights = const [],
  }) : _weights = weights;
  //
  @override
  Widget build(BuildContext context) {
    return TableView(
      cellHeight: 32.0,
      cellPadding: const EdgeInsets.symmetric(horizontal: 8.0),
      tableBorderColor: Colors.transparent,
      model: DaviModel<DisplacementWeight>(
        rows: _weights,
        columns: [
          DaviColumn(
            width: 400.0,
            stringValue: (data) => Localized(data.name).v,
          ),
          DaviColumn(
            grow: 1,
            headerAlignment: Alignment.centerRight,
            cellAlignment: Alignment.centerRight,
            name: '${const Localized('Mass').v} [${const Localized('t').v}]',
            doubleValue: (data) => data.value,
            stringValue: (data) => _formatDouble(data.value),
          ),
          DaviColumn(
            grow: 1,
            headerAlignment: Alignment.centerRight,
            cellAlignment: Alignment.centerRight,
            name: '${const Localized('LCG').v} [${const Localized('m').v}]',
            doubleValue: (data) => data.lcg,
            stringValue: (data) => _formatDouble(data.lcg),
          ),
          DaviColumn(
            grow: 1,
            headerAlignment: Alignment.centerRight,
            cellAlignment: Alignment.centerRight,
            name: '${const Localized('TCG').v} [${const Localized('m').v}]',
            doubleValue: (data) => data.tcg,
            stringValue: (data) => _formatDouble(data.tcg),
          ),
          DaviColumn(
            grow: 1,
            headerAlignment: Alignment.centerRight,
            cellAlignment: Alignment.centerRight,
            name: '${const Localized('VCG').v} [${const Localized('m').v}]',
            doubleValue: (data) => data.vcg,
            stringValue: (data) => _formatDouble(data.vcg),
          ),
          DaviColumn(
            grow: 1,
            headerAlignment: Alignment.centerRight,
            cellAlignment: Alignment.centerRight,
            name:
                '${const Localized('VCG').v} ${const Localized('Correction').v} [${const Localized('m').v}]',
            doubleValue: (data) => data.vcg,
            stringValue: (data) => _formatDouble(data.vcg),
          ),
        ],
      ),
    );
  }
  String _formatDouble(double? value) => value?.toStringAsFixed(2) ?? '—';
}
