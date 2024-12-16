import 'package:davi/davi.dart';
import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core.dart';
import 'package:sss_computing_client/core/models/bulkheads/bulkhead.dart';
import 'package:sss_computing_client/core/widgets/table/table_view.dart';
///
/// Table that displays [Bulkhead] list.
class BulkheadsTable extends StatefulWidget {
  final List<Bulkhead> _bulkheads;
  ///
  /// Creates table widget that displays [bulkheads] list.
  const BulkheadsTable({
    super.key,
    bulkheads = const [],
  }) : _bulkheads = bulkheads;
  @override
  State<BulkheadsTable> createState() => _BulkheadsTableState();
}
///
class _BulkheadsTableState extends State<BulkheadsTable> {
  late DaviModel<Bulkhead> _model;
  //
  @override
  void initState() {
    const nullValueText = '—';
    _model = DaviModel(
      columns: [
        DaviColumn(
          grow: 1,
          name: const Localized('Name').v,
          stringValue: (data) => Localized(data.name).v,
        ),
        DaviColumn(
          grow: 1,
          headerAlignment: Alignment.centerRight,
          cellAlignment: Alignment.centerRight,
          name: '${const Localized('Mass').v} [${const Localized('t').v}]',
          doubleValue: (data) => data.mass,
          stringValue: (data) => data.mass?.toStringAsFixed(2) ?? nullValueText,
        ),
        DaviColumn(
          grow: 1,
          headerAlignment: Alignment.centerRight,
          cellAlignment: Alignment.centerRight,
          name: '${const Localized('LCG').v} [${const Localized('m').v}]',
          doubleValue: (data) => data.lcg,
          stringValue: (data) => data.lcg?.toStringAsFixed(2) ?? nullValueText,
        ),
        DaviColumn(
          grow: 1,
          headerAlignment: Alignment.centerRight,
          cellAlignment: Alignment.centerRight,
          name: '${const Localized('TCG').v} [${const Localized('m').v}]',
          doubleValue: (data) => data.tcg,
          stringValue: (data) => data.tcg?.toStringAsFixed(2) ?? nullValueText,
        ),
        DaviColumn(
          grow: 1,
          headerAlignment: Alignment.centerRight,
          cellAlignment: Alignment.centerRight,
          name: '${const Localized('VCG').v} [${const Localized('m').v}]',
          doubleValue: (data) => data.vcg,
          stringValue: (data) => data.vcg?.toStringAsFixed(2) ?? nullValueText,
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
      cellHeight: 32.0,
      cellPadding: const EdgeInsets.symmetric(horizontal: 8.0),
      tableBorderColor: Colors.transparent,
      model: _model..replaceRows(widget._bulkheads),
    );
  }
}
