import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:sss_computing_client/core/models/stowage_plan/container/freight_container.dart';
import 'package:sss_computing_client/core/models/stowage_plan/stowage_collection/stowage_collection.dart';
import 'package:sss_computing_client/core/models/voyage/waypoint.dart';
import 'package:sss_computing_client/core/widgets/table/editing_table.dart';
import 'package:sss_computing_client/presentation/loading/widgets/containers_configurator/container_column/container_check_digit_column.dart';
import 'package:sss_computing_client/presentation/loading/widgets/containers_configurator/container_column/container_code_column.dart';
import 'package:sss_computing_client/presentation/loading/widgets/containers_configurator/container_column/container_owner_column.dart';
import 'package:sss_computing_client/presentation/loading/widgets/containers_configurator/container_column/container_pod_column.dart';
import 'package:sss_computing_client/presentation/loading/widgets/containers_configurator/container_column/container_pol_column.dart';
import 'package:sss_computing_client/presentation/loading/widgets/containers_configurator/container_column/container_serial_column.dart';
import 'package:sss_computing_client/presentation/loading/widgets/containers_configurator/container_column/container_slot_column.dart';
import 'package:sss_computing_client/presentation/loading/widgets/containers_configurator/container_column/container_type_code_column.dart';
import 'package:sss_computing_client/presentation/loading/widgets/containers_configurator/container_column/container_type_column.dart';
import 'package:sss_computing_client/presentation/loading/widgets/containers_configurator/container_column/container_weight_column.dart';
///
/// [EditingTable] to display [FreightContainer];
class ContainersTable extends StatelessWidget {
  final List<FreightContainer> _containers;
  final List<Waypoint> _waypoints;
  final StowageCollection _collection;
  final void Function(
    FreightContainer oldContainer,
    FreightContainer newContainer,
  )? onRowUpdate;
  final void Function(FreightContainer container)? _onRowTap;
  final void Function(FreightContainer container)? _onRowDoubleTap;
  final int? _selectedId;
  ///
  /// Creates [EditingTable] to display and edit provided [containers];
  ///
  /// * [waypoints] - list of [Waypoint]s which can be used as [FreightContainer] pol and pod waypoints;
  /// * [collection] - [StowageCollection] collection in which containers can be loaded;
  /// * [onRowUpdate] - calls when data of table row updated;
  /// * [onRowTap] - calls when tap on table row;
  /// * [onRowDoubleTap] - calls when double tap on table row;
  /// * [selectedId] - selected [FreightContainer]'s id;
  const ContainersTable({
    super.key,
    required List<FreightContainer> containers,
    required List<Waypoint> waypoints,
    required StowageCollection collection,
    this.onRowUpdate,
    void Function(FreightContainer)? onRowTap,
    void Function(FreightContainer)? onRowDoubleTap,
    int? selectedId,
  })  : _containers = containers,
        _waypoints = waypoints,
        _collection = collection,
        _onRowTap = onRowTap,
        _onRowDoubleTap = onRowDoubleTap,
        _selectedId = selectedId;
  //
  @override
  Widget build(BuildContext context) {
    return EditingTable<FreightContainer>(
      columns: [
        const ContainerTypeColumn(),
        const ContainerTypeCodeColumn(),
        const ContainerOwnerColumn(),
        const ContainerCodeColumn(),
        const ContainerSerialColumn(),
        const ContainerCheckDigitColumn(),
        const ContainerWeightColumn(),
        ContainerPOLColumn(waypoints: _waypoints),
        ContainerPODColumn(waypoints: _waypoints),
        ContainerSlotColumn(collection: _collection),
      ],
      selectedRow: _containers.firstWhereOrNull((c) => c.id == _selectedId),
      onRowTap: _onRowTap,
      onRowDoubleTap: _onRowDoubleTap,
      onRowUpdate: onRowUpdate,
      rows: _containers,
    );
  }
}
