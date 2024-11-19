import 'package:davi/davi.dart';
import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core.dart';
import 'package:hmi_core/hmi_core_app_settings.dart';
import 'package:sss_computing_client/core/extensions/date_time.dart';

import 'package:sss_computing_client/core/models/voyage/itinerary.dart';
import 'package:sss_computing_client/core/widgets/table/table_nullable_cell.dart';
import 'package:sss_computing_client/core/widgets/table/table_view.dart';

///
/// Displays the itineraries of the voyage
class VoyageItineraryTable extends StatefulWidget {
  const VoyageItineraryTable({super.key, required this.itineraries});

  /// The itineraries of the voyage
  final List<Itinerary> itineraries;

  @override
  State<VoyageItineraryTable> createState() => _VoyageItineraryTableState();
}

class _VoyageItineraryTableState extends State<VoyageItineraryTable> {
  late final DaviModel<Itinerary> _model;
  late List<Itinerary> _itineraries;
  late List<DaviColumn<Itinerary>> _hiddenColumns;
  bool _isAdd = false;

  //
  @override
  void initState() {
    _itineraries = widget.itineraries;
    _hiddenColumns = [
      DaviColumn<Itinerary>(
        grow: 1.0,
        cellAlignment: Alignment.center,
        name: '${const Localized('Draft limit').v} [м]',
        cellBuilder: (context, row) => NullableCellWidget(
          value: '${row.data.draftLimit}',
        ),
      ),
    ];
    _model = DaviModel(
      columns: [
        DaviColumn<Itinerary>(
          grow: 1.0,
          name: const Localized('Port').v,
          cellBuilder: (context, row) => _buildStyledCell(
            row.data.port,
            color: Colors.green,
          ),
        ),
        DaviColumn<Itinerary>(
          // grow: 1.0,
          name: const Localized('Port code').v,
          cellBuilder: (context, row) => NullableCellWidget(
            value: row.data.portCode,
          ),
        ),
        DaviColumn<Itinerary>(
          grow: 1.0,
          // name: Localized('Arrival').v,
          name: const Localized('ETA').v,
          cellBuilder: (context, row) => NullableCellWidget(
            value: row.data.arrival.formatRU(),
          ),
        ),
        DaviColumn<Itinerary>(
          grow: 1.0,
          // name: Localized('Departure').v,
          name: const Localized('ETD').v,
          cellBuilder: (context, row) => NullableCellWidget(
            value: row.data.departure.formatRU(),
          ),
        ),
        _hiddenColumns.first,
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

  @override
  Widget build(BuildContext context) {
    final blockPadding = const Setting('blockPadding').toDouble;
    final theme = Theme.of(context);
    return Column(
      children: [
        Row(
          children: [
            Text(
              const Localized('Itinerary').v,
              style: theme.textTheme.titleLarge,
            ),
            SizedBox(width: blockPadding),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  _buildAction(
                    theme,
                    label: 'Add',
                    icon: Icons.add,
                    actionable: _isAdd,
                  ),
                  SizedBox(width: blockPadding),
                  _buildAction(
                    theme,
                    label: 'Delete',
                    icon: Icons.delete,
                    actionable: !_isAdd,
                  ),
                ],
              ),
            ),
          ],
        ),
        Expanded(
          child: TableView(
            model: _model..replaceRows(_itineraries),
            cellHeight: 32.0,
            cellPadding: EdgeInsets.zero,
            tableBorderColor: Colors.transparent,
          ),
        ),
      ],
    );
  }

  ///Build a styled cell with a [colored] leading container
  Widget _buildStyledCell(String value, {Color color = Colors.blue}) {
    final padding = const Setting('padding').toDouble;
    return Row(
      children: [
        Container(
          width: padding * 0.75,
          margin: EdgeInsets.symmetric(vertical: padding / 2),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        SizedBox(width: padding),
        Expanded(
          child: NullableCellWidget(
            value: value,
          ),
        ),
      ],
    );
  }

  ElevatedButton _buildAction(
    ThemeData theme, {
    required IconData icon,
    required String label,
    bool actionable = true,
  }) {
    return ElevatedButton.icon(
      onPressed: !actionable
          ? null
          : () {
              if (_isAdd) {
                _model.addColumn(_hiddenColumns.first);
              } else {
                _model.removeColumn(_hiddenColumns.first);
              }
              setState(() {
                _isAdd = !_isAdd;
              });
            },
      icon: Icon(
        icon,
        color: !actionable ? Colors.grey : theme.colorScheme.inversePrimary,
      ),
      label: Text(
        Localized(label).v,
      ),
    );
  }
}
