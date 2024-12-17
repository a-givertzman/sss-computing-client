import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core.dart';
import 'package:hmi_widgets/hmi_widgets.dart';
import 'package:sss_computing_client/core/models/field/field_type.dart';
import 'package:sss_computing_client/core/models/record/value_record.dart';
import 'package:sss_computing_client/core/models/stowage_plan/container/freight_container.dart';
import 'package:sss_computing_client/core/models/voyage/waypoint.dart';
import 'package:sss_computing_client/core/widgets/status_label.dart';
import 'package:sss_computing_client/core/widgets/table/table_column.dart';
///
/// Status of container, [Ok] or [Err] with [String] message.
typedef Status = Result<void, String>;
///
/// [TableEditing] column for container status.
class ContainerStatusColumn implements TableColumn<FreightContainer, Status> {
  final ThemeData _theme;
  final List<Waypoint> _waypoints;
  ///
  /// Creates [TableEditing] column for container status.
  const ContainerStatusColumn({
    required List<Waypoint> waypoints,
    required ThemeData theme,
  })  : _waypoints = waypoints,
        _theme = theme;
  //
  @override
  String get key => 'status';
  //
  @override
  FieldType get type => FieldType.string;
  //
  @override
  String get name => const Localized('Status').v;
  //
  @override
  String get nullValue => '—';
  //
  @override
  Status get defaultValue => const Ok(null);
  //
  @override
  Alignment get headerAlignment => Alignment.centerRight;
  //
  @override
  Alignment get cellAlignment => Alignment.centerRight;
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
  Status extractValue(FreightContainer container) => _validatePorts(container);
  //
  @override
  Status parseToValue(String text) => text.isEmpty ? const Ok(null) : Err(text);
  //
  @override
  String parseToString(Status value) => switch (value) {
        Ok() => '',
        Err(:final error) => error,
      };
  //
  @override
  FreightContainer copyRowWith(
    FreightContainer container,
    Status status,
  ) =>
      container;
  //
  @override
  ValueRecord<Status>? buildRecord(
    FreightContainer container,
    Status Function(String text) toValue,
  ) =>
      null;
  //
  @override
  Widget? buildCell(context, cargo, updateValue) => StatusLabel(
        theme: _theme,
        errorColor: _theme.stateColors.error,
        okColor: _theme.stateColors.on,
        errorMessage: switch (extractValue(cargo)) {
          Ok() => null,
          Err(:final error) => error,
        },
      );
  //
  Result<void, String> _validatePorts(FreightContainer container) {
    final pol = _waypoints.firstWhereOrNull(
      (w) => w.id == container.polWaypointId,
    );
    final pod = _waypoints.firstWhereOrNull(
      (w) => w.id == container.podWaypointId,
    );
    if (pol == null || pod == null) return const Ok(null);
    return pol.eta.isBefore(pod.eta)
        ? const Ok(null)
        : Err(const Localized('POL must be before POD').v);
  }
}
