import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core.dart';
import 'package:hmi_widgets/hmi_widgets.dart';
import 'package:sss_computing_client/core/models/field/field_type.dart';
import 'package:sss_computing_client/core/models/record/value_record.dart';
import 'package:sss_computing_client/core/models/stowage/container/freight_container.dart';
import 'package:sss_computing_client/core/models/stowage/voyage/waypoint.dart';
import 'package:sss_computing_client/core/widgets/table/table_column.dart';
///
/// TODO
class ContainerPODIndictorColumn
    implements TableColumn<FreightContainer, String?> {
  final List<Waypoint> _waypoints;
  ///
  const ContainerPODIndictorColumn({
    List<Waypoint> waypoints = const [],
  }) : _waypoints = waypoints;
  //
  @override
  String get key => 'pod';
  //
  @override
  FieldType get type => FieldType.string;
  //
  @override
  String get name => '';
  //
  @override
  String get nullValue => '—';
  //
  @override
  String get defaultValue => '';
  //
  @override
  Alignment get headerAlignment => Alignment.centerLeft;
  //
  @override
  Alignment get cellAlignment => Alignment.centerLeft;
  //
  @override
  bool get isResizable => false;
  //
  @override
  double? get grow => null;
  //
  @override
  double? get width => 28.0;
  //
  @override
  bool get useDefaultEditing => false;
  //
  @override
  Validator? get validator => null;
  //
  @override
  String? extractValue(FreightContainer container) =>
      _waypoints
          .firstWhereOrNull((w) => w.id == container.podWaypointId)
          ?.portCode ??
      nullValue;
  //
  @override
  String parseToValue(String text) => text;
  //
  @override
  String parseToString(String? value) => value ?? nullValue;
  //
  @override
  FreightContainer copyRowWith(FreightContainer container, String text) =>
      container;
  //
  @override
  ValueRecord<String?>? buildRecord(
    FreightContainer container,
    String? Function(String text) toValue,
  ) =>
      null;
  //
  @override
  Widget? buildCell(context, container, updateValue) =>
      _ContainerWaypointIndicatorWidget(
        waypoint: _waypoints.firstWhereOrNull(
          (w) => w.id == container.podWaypointId,
        ),
      );
}
///
class _ContainerWaypointIndicatorWidget extends StatelessWidget {
  final Waypoint? _waypoint;
  ///
  const _ContainerWaypointIndicatorWidget({
    required Waypoint? waypoint,
  }) : _waypoint = waypoint;
  //
  @override
  Widget build(BuildContext context) {
    return _waypoint != null
        ? Tooltip(
            message: Localized(_waypoint.portName).v,
            child: Container(
              margin: const EdgeInsets.symmetric(
                vertical: 2.0,
              ),
              decoration: BoxDecoration(
                color: _waypoint.color,
                borderRadius: const BorderRadius.all(Radius.circular(2.0)),
              ),
            ),
          )
        : const SizedBox();
  }
}
