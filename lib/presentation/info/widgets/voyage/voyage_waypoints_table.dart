import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core.dart';
import 'package:hmi_core/hmi_core_app_settings.dart';
import 'package:hmi_widgets/hmi_widgets.dart';
import 'package:sss_computing_client/core/extensions/date_time.dart';
import 'package:sss_computing_client/core/extensions/lists.dart';
import 'package:sss_computing_client/core/models/hex_color.dart';
import 'package:sss_computing_client/core/models/voyage/json_waypoint.dart';
import 'package:sss_computing_client/core/models/voyage/waypoint.dart';
import 'package:sss_computing_client/core/models/voyage/waypoints.dart';
import 'package:sss_computing_client/core/validation/real_validation_case.dart';
import 'package:sss_computing_client/core/validation/required_validation_case.dart';
import 'package:sss_computing_client/core/widgets/confirmation_dialog.dart';
import 'package:sss_computing_client/core/widgets/disabled_widget.dart';
import 'package:sss_computing_client/core/widgets/table/editing_table.dart';
import 'package:sss_computing_client/core/widgets/table/editing_table_column.dart';
import 'package:sss_computing_client/core/widgets/table/table_column.dart';
import 'package:sss_computing_client/presentation/info/widgets/voyage/color_label_picker.dart';
import 'package:sss_computing_client/presentation/info/widgets/voyage/datetime_label_picker.dart';
import 'package:sss_computing_client/presentation/info/widgets/voyage/status_label.dart';
import 'package:sss_computing_client/presentation/info/widgets/voyage/use_draft_limit_label.dart';
///
/// Displays the waypoints of the voyage
class VoyageWaypointsTable extends StatefulWidget {
  final List<Waypoint> _waypoints;
  final Waypoints _waypointsCollection;
  const VoyageWaypointsTable({
    super.key,
    required List<Waypoint> waypoints,
    required Waypoints waypointsCollection,
  })  : _waypoints = waypoints,
        _waypointsCollection = waypointsCollection;
  //
  @override
  State<VoyageWaypointsTable> createState() => _VoyageWaypointsTableState();
}
///
class _VoyageWaypointsTableState extends State<VoyageWaypointsTable> {
  late final List<TableColumn<Waypoint, dynamic>> _tableColumns;
  late List<Waypoint> _waypoints;
  late Waypoint? _selectedWaypoint;
  late bool _isLoading;
  //
  @override
  // ignore: long-method
  void initState() {
    _isLoading = false;
    _waypoints = widget._waypoints;
    _selectedWaypoint = null;
    _tableColumns = [
      EditingTableColumn<Waypoint, Color>(
        key: 'color',
        name: '',
        width: 32.0,
        defaultValue: Colors.transparent,
        extractValue: (row) => row.color,
        parseToValue: (String text) => HexColor(text).color(),
        copyRowWith: (w, color) => JsonWaypoint.fromRow(
          w.asMap()..['color'] = color.value.toRadixString(16),
        ),
        buildCell: (_, row, updateValue) => ColorLabelPicker(
          color: row.color,
          updateColor: updateValue,
          themeData: Theme.of(context),
        ),
      ),
      EditingTableColumn<Waypoint, String>(
        key: 'portName',
        name: const Localized('Port name').v,
        useDefaultEditing: true,
        width: 160.0,
        defaultValue: '',
        extractValue: (row) => row.portName,
        parseToValue: (String text) => text,
        copyRowWith: (w, portName) =>
            JsonWaypoint.fromRow(w.asMap()..['portName'] = portName),
      ),
      EditingTableColumn<Waypoint, String>(
        key: 'portCode',
        name: const Localized('Port code').v,
        useDefaultEditing: true,
        width: 160.0,
        defaultValue: '',
        extractValue: (row) => row.portCode,
        parseToValue: (String text) => text,
        copyRowWith: (w, portCode) =>
            JsonWaypoint.fromRow(w.asMap()..['portCode'] = portCode),
      ),
      EditingTableColumn<Waypoint, DateTime>(
        key: 'eta',
        name: const Localized('ETA').v,
        grow: 1.0,
        defaultValue: DateTime.now(),
        extractValue: (row) => row.eta,
        parseToValue: (String text) =>
            DateTime.tryParse(text) ?? DateTime.now(),
        parseToString: (DateTime value) => value.formatRU(),
        copyRowWith: (w, eta) =>
            JsonWaypoint.fromRow(w.asMap()..['eta'] = eta.toString()),
        buildCell: (_, row, updateValue) => DateTimeLabelPicker(
          dateTime: row.eta,
          updateDateTime: updateValue,
          themeData: Theme.of(context),
        ),
      ),
      EditingTableColumn<Waypoint, DateTime>(
        key: 'etd',
        name: const Localized('ETD').v,
        grow: 1.0,
        defaultValue: DateTime.now(),
        extractValue: (row) => row.etd,
        parseToValue: (String text) =>
            DateTime.tryParse(text) ?? DateTime.now(),
        parseToString: (DateTime value) => value.formatRU(),
        copyRowWith: (w, etd) =>
            JsonWaypoint.fromRow(w.asMap()..['etd'] = etd.toString()),
        buildCell: (_, row, updateValue) => DateTimeLabelPicker(
          dateTime: row.etd,
          updateDateTime: updateValue,
          themeData: Theme.of(context),
        ),
      ),
      EditingTableColumn<Waypoint, None>(
        key: 'checkEtaEtdRange',
        name: const Localized('Status').v,
        width: 96.0,
        headerAlignment: Alignment.centerRight,
        defaultValue: const None(),
        extractValue: (_) => const None(),
        parseToValue: (_) => const None(),
        buildCell: (_, row, __) => Align(
          alignment: Alignment.centerRight,
          child: StatusLabel(
            theme: Theme.of(context),
            errorColor: Theme.of(context).stateColors.error,
            okColor: Colors.green,
            errorMessage: _waypoints.any(
              (w) => w.id != row.id
                  ? row.eta.isBefore(w.etd) && row.etd.isAfter(w.eta)
                  : false,
            )
                ? const Localized(
                    'ETA - ETD range overlap with another waypoint',
                  ).v
                : null,
          ),
        ),
      ),
      EditingTableColumn<Waypoint, double>(
        key: 'draftLimit',
        name: '${const Localized('Draft limit').v} [${const Localized('m').v}]',
        grow: 1.0,
        useDefaultEditing: true,
        validator: const Validator(cases: [
          RequiredValidationCase(),
          RealValidationCase(),
        ]),
        headerAlignment: Alignment.centerRight,
        cellAlignment: Alignment.centerRight,
        defaultValue: 0.0,
        extractValue: (row) => row.draftLimit,
        parseToValue: (String text) => double.parse(text),
        parseToString: (double value) => value.toStringAsFixed(2),
        copyRowWith: (w, draftLimit) =>
            JsonWaypoint.fromRow(w.asMap()..['draftLimit'] = draftLimit),
      ),
      EditingTableColumn<Waypoint, bool>(
        key: 'useDraftLimit',
        name: const Localized('take into account in the criteria').v,
        grow: 1.0,
        headerAlignment: Alignment.centerRight,
        defaultValue: false,
        extractValue: (row) => row.useDraftLimit,
        parseToValue: (String text) => bool.parse(text),
        parseToString: (bool value) => value.toString(),
        copyRowWith: (w, useDraftLimit) =>
            JsonWaypoint.fromRow(w.asMap()..['useDraftLimit'] = useDraftLimit),
        cellAlignment: Alignment.center,
        buildCell: (_, row, updateValue) => Align(
          alignment: Alignment.centerRight,
          child: UseDraftLimitLabel(
            useDraftLimit: row.useDraftLimit,
            updateUseDraftLimit: updateValue,
            theme: Theme.of(context),
          ),
        ),
      ),
    ];
    super.initState();
  }
  //
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final blockPadding = const Setting('blockPadding').toDouble;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          const Localized('Itinerary').v,
          style: theme.textTheme.titleLarge,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            IconButton.filled(
              tooltip: const Localized('Add waypoint').v,
              icon: const Icon(Icons.add_rounded),
              onPressed: _addWaypoint,
            ),
            SizedBox(width: blockPadding),
            IconButton.filled(
              tooltip: const Localized('Delete waypoint').v,
              icon: const Icon(Icons.remove_rounded),
              onPressed: _selectedWaypoint != null
                  ? () => _deleteWaypoint(_selectedWaypoint!)
                  : null,
            ),
          ],
        ),
        Expanded(
          child: DisabledWidget(
            disabled: _isLoading,
            child: EditingTable(
              rows: _waypoints.sorted((w1, w2) => w1.eta.compareTo(w2.eta)),
              columns: _tableColumns,
              onRowUpdate: _updateWaypoint,
              onRowTap: _toggleWaypointSelection,
              selectedRow: _waypoints.firstWhereOrNull(
                (w) => w.id == _selectedWaypoint?.id,
              ),
            ),
          ),
        ),
      ],
    );
  }
  //
  void _toggleWaypointSelection(Waypoint? waypoint) {
    if (waypoint?.id == _selectedWaypoint?.id) {
      setState(() {
        _selectedWaypoint = null;
      });
    } else {
      setState(() {
        _selectedWaypoint = waypoint;
      });
    }
  }
  //
  void _addWaypoint() {
    final lastTime =
        _waypoints.map((w) => w.etd).sorted().lastOrNull ?? DateTime.now();
    final newWaypoint = JsonWaypoint.emptyWith(
      eta: lastTime,
      etd: lastTime,
    );
    widget._waypointsCollection.add(newWaypoint).then((result) {
      switch (result) {
        case Ok(value: final waypoint):
          if (!mounted) return;
          setState(() {
            _waypoints.add(waypoint);
          });
          break;
        case Err(:final error):
          _showErrorMessage(error.message);
          break;
      }
    });
  }
  //
  void _deleteWaypoint(Waypoint waypoint) async {
    final containerReferenceNumber =
        await widget._waypointsCollection.validateContainerReference(waypoint);
    switch (containerReferenceNumber) {
      case Ok(value: final references):
        if (!mounted) return;
        if (references > 0) {
          final deleteConfirmation = await showDialog<bool>(
            context: context,
            builder: (context) => ConfirmationDialog(
              title: Text(const Localized(
                'Delete waypoint',
              ).v),
              content: Text(const Localized(
                'Container with this waypoint as POL or POD exists',
              ).v),
              confirmationButtonLabel: const Localized('Delete anyway').v,
            ),
          );
          if (!(deleteConfirmation ?? false)) return;
        }
        break;
      case Err(:final error):
        _showErrorMessage(error.message);
        return;
    }
    widget._waypointsCollection.remove(waypoint).then((result) {
      switch (result) {
        case Ok():
          if (!mounted) return;
          setState(() {
            _toggleWaypointSelection(waypoint);
            _waypoints.removeWhere((w) => w.id == waypoint.id);
          });
          break;
        case Err(:final error):
          _showErrorMessage(error.message);
          break;
      }
    });
  }
  //
  void _updateWaypoint(
    Waypoint newWaypoint,
    Waypoint oldWaypoint,
  ) {
    setState(() {
      _isLoading = true;
    });
    widget._waypointsCollection.update(newWaypoint, oldWaypoint).then((result) {
      return switch (result) {
        Ok(value: final waypoint) => () {
            if (!mounted) return;
            final idx = _waypoints.indexWhere(
              (w) => w.id == newWaypoint.id,
            );
            setState(() {
              _waypoints[idx] = waypoint;
            });
          }(),
        Err(:final error) => _showErrorMessage(error.message),
      };
    }).whenComplete(() {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
      });
    });
  }
  //
  void _showErrorMessage(String message) {
    if (!mounted) return;
    final durationMs = const Setting('errorMessageDisplayDuration').toInt;
    BottomMessage.error(
      message: message,
      displayDuration: Duration(milliseconds: durationMs),
    ).show(context);
  }
}
