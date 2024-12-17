import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core.dart';
import 'package:hmi_widgets/hmi_widgets.dart';
import 'package:sss_computing_client/core/models/field/field_type.dart';
import 'package:sss_computing_client/core/models/record/value_record.dart';
import 'package:sss_computing_client/core/models/stowage_plan/container/freight_container.dart';
import 'package:sss_computing_client/core/models/stowage_plan/container/json_freight_container.dart';
import 'package:sss_computing_client/core/models/voyage/waypoint.dart';
import 'package:sss_computing_client/core/widgets/table/table_column.dart';
import 'package:sss_computing_client/core/widgets/voyage/voyage_waypoint_dropdown.dart';
import 'package:sss_computing_client/core/widgets/voyage/voyage_waypoint_preview.dart';
///
/// [TableColumn] for [FreightContainer] pod (port of departure).
class ContainerPODColumn implements TableColumn<FreightContainer, int?> {
  final List<Waypoint> _waypoints;
  ///
  /// Creates [TableColumn] for [FreightContainer] pod (port of departure).
  const ContainerPODColumn({
    List<Waypoint> waypoints = const [],
  }) : _waypoints = waypoints;
  //
  @override
  String get key => 'pod';
  //
  @override
  FieldType get type => FieldType.int;
  //
  @override
  String get name => const Localized('POD').v;
  //
  @override
  String get nullValue => '—';
  //
  @override
  int? get defaultValue => null;
  //
  @override
  Alignment get headerAlignment => Alignment.centerLeft;
  //
  @override
  Alignment get cellAlignment => Alignment.centerLeft;
  //
  @override
  double? get grow => 1.0;
  //
  @override
  double? get width => null;
  //
  @override
  bool get useDefaultEditing => false;
  //
  @override
  bool get isResizable => true;
  //
  @override
  Validator? get validator => null;
  //
  @override
  int? extractValue(FreightContainer container) => container.polWaypointId;
  //
  @override
  int? parseToValue(String text) => int.tryParse(text);
  //
  @override
  String parseToString(int? value) =>
      value != null ? value.toString() : nullValue;
  //
  @override
  FreightContainer copyRowWith(FreightContainer container, int? value) {
    final newContainerData = container.asMap()..['podWaypointId'] = value;
    return JsonFreightContainer.fromRow(newContainerData);
  }
  //
  @override
  ValueRecord<int?>? buildRecord(
    FreightContainer container,
    int? Function(String text) toValue,
  ) =>
      null;
  //
  @override
  Widget? buildCell(
    context,
    container,
    updateValue,
  ) =>
      VoyageWaypointDropdown(
        values: _waypoints,
        initialValue: _waypoints.firstWhereOrNull(
          (w) => w.id == container.podWaypointId,
        ),
        onWaypointChanged: (w) => updateValue(w.id),
        buildCustomButton: (onTap) => GestureDetector(
          onTap: onTap,
          child: VoyageWaypointPreview(
            waypoint: _waypoints.firstWhereOrNull(
              (w) => w.id == container.podWaypointId,
            ),
          ),
        ),
        dropdownBackgroundColor: Theme.of(context).colorScheme.surface,
        waypointLabelColor: Theme.of(context).colorScheme.onSurface,
      );
}
