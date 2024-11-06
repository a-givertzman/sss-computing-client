import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hmi_core/hmi_core.dart';
import 'package:hmi_widgets/hmi_widgets.dart';
import 'package:sss_computing_client/core/models/field/field_type.dart';
import 'package:sss_computing_client/core/models/record/value_record.dart';
import 'package:sss_computing_client/core/models/stowage/container/freight_container.dart';
import 'package:sss_computing_client/core/models/stowage/container/json_freight_container.dart';
import 'package:sss_computing_client/core/models/stowage/voyage/waypoint.dart';
import 'package:sss_computing_client/core/widgets/table/table_column.dart';
import 'package:sss_computing_client/presentation/container_cargo/widgets/voyage_waypoint_dropdown.dart';
import 'package:sss_computing_client/presentation/container_cargo/widgets/voyage_waypoint_preview.dart';
///
class ContainerPOLColumn implements TableColumn<FreightContainer, int?> {
  final List<Waypoint> _waypoints;
  ///
  const ContainerPOLColumn({
    List<Waypoint> waypoints = const [],
  }) : _waypoints = waypoints;
  //
  @override
  String get key => 'pol';
  //
  @override
  FieldType get type => FieldType.int;
  //
  @override
  String get name => const Localized('POL').v;
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
  double? get grow => null;
  //
  @override
  double? get width => 150.0;
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
  FreightContainer copyRowWith(FreightContainer container, String text) {
    final newContainerData = container.asMap()
      ..['polWaypointId'] = parseToValue(text);
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
          (w) => w.id == container.polWaypointId,
        ),
        onWaypointChanged: (w) => updateValue(
          parseToString(w.id),
        ),
        buildCustomButton: (onTap) => GestureDetector(
          onTap: onTap,
          child: VoyageWaypointPreview(
            waypoint: _waypoints.firstWhereOrNull(
              (w) => w.id == container.polWaypointId,
            ),
          ),
        ),
        dropdownBackgroundColor: Theme.of(context).colorScheme.surface,
        waypointLabelColor: Theme.of(context).colorScheme.onSurface,
      );
}
