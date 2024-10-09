import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core.dart';
import 'package:hmi_core/hmi_core_app_settings.dart';
import 'package:sss_computing_client/core/models/figure/figure.dart';
import 'package:sss_computing_client/core/models/figure/figure_plane.dart';
import 'package:sss_computing_client/core/models/figure/rectangular_cuboid_figure.dart';
import 'package:sss_computing_client/core/models/stowage/container/container_1aa.dart';
import 'package:sss_computing_client/core/models/stowage/container/container_1cc.dart';
import 'package:sss_computing_client/core/models/stowage/faked_slots.dart';
import 'package:sss_computing_client/core/models/stowage/stowage/pretty_print_plan.dart';
import 'package:sss_computing_client/core/models/stowage/stowage/slot.dart';
import 'package:sss_computing_client/core/models/stowage/stowage/stowage_collection.dart';
import 'package:sss_computing_client/core/models/stowage/stowage/stowage_plan.dart';
import 'package:sss_computing_client/core/widgets/scheme/scheme_figure.dart';
import 'package:sss_computing_client/core/widgets/scheme/scheme_layout.dart';
import 'package:sss_computing_client/core/widgets/scheme/scheme_text.dart';
import 'package:sss_computing_client/core/widgets/table/editing_table.dart';
import 'package:sss_computing_client/presentation/loading/containers_configurator/container_column/container_code_column.dart';
import 'package:sss_computing_client/presentation/loading/containers_configurator/container_column/container_name_column.dart';
import 'package:sss_computing_client/presentation/loading/containers_configurator/container_column/container_serial_column.dart';
import 'package:sss_computing_client/presentation/loading/containers_configurator/container_column/container_type_column.dart';
import 'package:sss_computing_client/presentation/loading/containers_configurator/container_column/container_weight_column.dart';
import 'package:vector_math/vector_math_64.dart' hide Colors;
import 'package:sss_computing_client/core/models/stowage/container/container.dart'
    as stowage;

///
class ContainersConfigurator extends StatefulWidget {
  ///
  const ContainersConfigurator({super.key});
  //
  @override
  State<ContainersConfigurator> createState() => _ContainersConfiguratorState();
}

class _ContainersConfiguratorState extends State<ContainersConfigurator> {
  late final StowagePlan _stowagePlan;
  late final List<stowage.Container> _containers;

  /// For testing
  late List<Slot> _selectedSlots;
  late int? _selectedContainerId;
  //
  @override
  // ignore: long-method
  void initState() {
    _stowagePlan = StowageCollection.fromSlotList(arkSlots);
    _containers = List.from(const [
      Container1CC(serial: 1, id: 1, tareWeight: 1.0),
      Container1AA(serial: 2, id: 2, tareWeight: 1.0),
    ]);
    _selectedSlots = [];
    _selectedContainerId = null;
    _stowagePlan.addContainer(
      const Container1CC(serial: 1, id: 1),
      bay: 1,
      row: 1,
      tier: 2,
    );
    _stowagePlan.addContainer(
      const Container1CC(serial: 1, id: 2),
      bay: 1,
      row: 2,
      tier: 2,
    );
    _stowagePlan.addContainer(
      const Container1CC(serial: 1, id: 1),
      bay: 22,
      row: 4,
      tier: 2,
    );
    _stowagePlan.addContainer(
      const Container1CC(serial: 1, id: 2),
      bay: 22,
      row: 2,
      tier: 2,
    );
    _stowagePlan.addContainer(
      const Container1CC(serial: 1, id: 1),
      bay: 23,
      row: 3,
      tier: 2,
    );
    _stowagePlan.addContainer(
      const Container1CC(serial: 1, id: 2),
      bay: 23,
      row: 1,
      tier: 2,
    );
    _stowagePlan.addContainer(
      const Container1CC(serial: 1, id: 1),
      bay: 20,
      row: 4,
      tier: 2,
    );
    _stowagePlan.addContainer(
      const Container1CC(serial: 1, id: 2),
      bay: 20,
      row: 2,
      tier: 2,
    );
    _stowagePlan.addContainer(
      const Container1CC(serial: 1, id: 1),
      bay: 20,
      row: 3,
      tier: 4,
    );
    _stowagePlan.addContainer(
      const Container1CC(serial: 1, id: 2),
      bay: 20,
      row: 1,
      tier: 4,
    );
    _stowagePlan.addContainer(
      const Container1CC(serial: 1, id: 3),
      bay: 24,
      row: 4,
      tier: 82,
    );
    _stowagePlan.addContainer(
      const Container1CC(serial: 1, id: 4),
      bay: 24,
      row: 4,
      tier: 84,
    );
    _stowagePlan.addContainer(
      const Container1CC(serial: 1, id: 5),
      bay: 24,
      row: 4,
      tier: 86,
    );
    _stowagePlan.addContainer(
      const Container1CC(serial: 1, id: 3),
      bay: 22,
      row: 3,
      tier: 82,
    );
    _stowagePlan.addContainer(
      const Container1CC(serial: 1, id: 3),
      bay: 22,
      row: 1,
      tier: 82,
    );
    super.initState();
  }

  //
  @override
  Widget build(BuildContext context) {
    final blockPadding = const Setting('blockPadding').toDouble;
    final bayPairs = _stowagePlan.iterateBayPairs().toList();
    return Padding(
      padding: EdgeInsets.all(blockPadding),
      child: Column(
        children: [
          Expanded(
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: bayPairs.length,
              itemBuilder: (_, index) => BayPlan(
                oddBayNumber: bayPairs[index].odd,
                evenBayNumber: bayPairs[index].even,
                slots: _stowagePlan.toFilteredSlotList(
                  shouldIncludeSlot: (slot) =>
                      slot.bay == bayPairs[index].odd ||
                      slot.bay == bayPairs[index].even,
                ),
                onSlotSelected: (bay, row, tier) => setState(() {
                  _selectedSlots = _stowagePlan.toFilteredSlotList(
                    row: row,
                    tier: tier,
                    shouldIncludeSlot: (slot) {
                      if (bay.isOdd) {
                        return slot.bay == bay || slot.bay == bay - 1;
                      } else {
                        return slot.bay == bay || slot.bay == bay + 1;
                      }
                    },
                  );
                }),
                selectedSlots: _selectedSlots
                    .where(
                      (s) =>
                          s.bay == bayPairs[index].odd ||
                          s.bay == bayPairs[index].even,
                    )
                    .toList(),
              ),
              separatorBuilder: (_, __) => SizedBox(width: blockPadding),
            ),
          ),
          SizedBox(height: blockPadding),
          Expanded(
            child: ContainersTable(
              containers: _containers,
              selectedId: _selectedContainerId,
              onRowUpdate: (container) {
                setState(() {
                  final index = _containers.indexWhere(
                    (c) => c.id == container.id,
                  );
                  _containers[index] = container;
                });
              },
              onRowTap: (container) => setState(() {
                if (container.id == _selectedContainerId) {
                  _selectedContainerId = null;
                  return;
                }
                _selectedContainerId = container.id;
              }),
            ),
          ),
        ],
      ),
    );
  }
}

///
class ContainersTable extends StatelessWidget {
  final List<stowage.Container> containers;
  final void Function(stowage.Container container)? onRowUpdate;
  final void Function(stowage.Container container)? onRowTap;
  final int? selectedId;

  ///
  const ContainersTable({
    super.key,
    required this.containers,
    this.onRowUpdate,
    this.selectedId,
    this.onRowTap,
  });
  //
  @override
  Widget build(BuildContext context) {
    return EditingTable<stowage.Container>(
      columns: const [
        ContainerTypeColumn(),
        ContainerCodeColumn(),
        ContainerNameColumn(),
        ContainerWeightColumn(useDefaultEditing: true),
        ContainerSerialColumn(useDefaultEditing: true),
      ],
      selectedRow: containers.firstWhereOrNull((c) => c.id == selectedId),
      onRowTap: onRowTap,
      rows: containers,
      onRowUpdate: onRowUpdate,
    );
  }
}

///
class BayPlan extends StatefulWidget {
  final int? oddBayNumber;
  final int? evenBayNumber;
  final List<Slot> slots;
  final List<Slot> selectedSlots;
  final Function(int bay, int row, int tier)? onSlotSelected;

  ///
  const BayPlan({
    super.key,
    required this.oddBayNumber,
    required this.evenBayNumber,
    required this.selectedSlots,
    this.onSlotSelected,
    this.slots = const [],
  });
  //
  @override
  State<BayPlan> createState() => _BayPlanState();
}

class _BayPlanState extends State<BayPlan> {
  late List<StowagePlanNumberingData> _tierNumbering;
  late List<StowagePlanNumberingData> _rowNumbering;
  //
  @override
  void initState() {
    const numberingAxes = StowagePlanNumberingAxes();
    _tierNumbering = numberingAxes.tierNumberingAxis(widget.slots);
    _rowNumbering = numberingAxes.rowNumberingAxis(widget.slots);
    super.initState();
  }

  //
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final labelStyle = theme.textTheme.labelLarge?.copyWith(
      backgroundColor: theme.colorScheme.primary.withOpacity(0.75),
    );
    const figurePlane = FigurePlane.yz;
    final (minX, maxX) = (-70.0, 70.0);
    final (minY, maxY) = (-10.0, 10.0);
    final (minZ, maxZ) = (-3.0, 21.0);
    final (_minX, _maxX) = switch (figurePlane) {
      FigurePlane.xy => (minX, maxX),
      FigurePlane.xz => (minX, maxX),
      FigurePlane.yz => (minY, maxY),
    };
    final (_minY, _maxY) = switch (figurePlane) {
      FigurePlane.xy => (minY, maxY),
      FigurePlane.xz => (minZ, maxZ),
      FigurePlane.yz => (minZ, maxZ),
    };
    return SchemeLayout(
      fit: BoxFit.contain,
      minX: _minX,
      maxX: _maxX,
      minY: _minY,
      maxY: _maxY,
      yAxisReversed: true,
      buildContent: (_, transform) => Stack(
        children: [
          ...widget.slots.map(
            (slot) => Positioned.fill(
              child: SchemeFigure(
                plane: figurePlane,
                figure: const BaySlotFigure().limitFigure(
                  slot,
                  Theme.of(context).colorScheme.surface,
                ),
                layoutTransform: transform,
              ),
            ),
          ),
          ...widget.slots.map(
            (slot) => Positioned.fill(
              child: SchemeFigure(
                plane: figurePlane,
                figure: const BaySlotFigure().slotFigure(slot),
                layoutTransform: transform,
                onTap: () => widget.onSlotSelected?.call(
                  slot.bay,
                  slot.row,
                  slot.tier,
                ),
              ),
            ),
          ),
          ...widget.selectedSlots.map(
            (slot) => Positioned.fill(
              child: SchemeFigure(
                plane: figurePlane,
                figure: const BaySlotFigure(
                  isSelected: true,
                ).slotFigure(slot),
                layoutTransform: transform,
                onTap: () => widget.onSlotSelected?.call(-1, -1, -1),
              ),
            ),
          ),
          SchemeText(
            text: bayPairTitle(),
            offset: Offset(0.0, _maxY - 1.0),
            style: labelStyle,
            layoutTransform: transform,
          ),
          SchemeText(
            text: containersNumberTitle(),
            offset: Offset(0.0, _maxY - 2.0),
            style: labelStyle,
            layoutTransform: transform,
          ),
          if (figurePlane == FigurePlane.yz || figurePlane == FigurePlane.xz)
            ..._tierNumbering.map(
              (data) => SchemeText(
                text: '${data.number}'.padLeft(2, '0'),
                layoutTransform: transform,
                offset: Offset(_minX + 1.0, data.center(figurePlane).dy),
                style: labelStyle,
              ),
            ),
          if (figurePlane == FigurePlane.yz)
            ..._rowNumbering.map(
              (data) => SchemeText(
                text: '${data.number}'.padLeft(2, '0'),
                layoutTransform: transform,
                offset: Offset(data.center(figurePlane).dx, _minY + 1.0),
                style: labelStyle,
              ),
            ),
          if (figurePlane == FigurePlane.xy)
            ..._rowNumbering.map(
              (data) => SchemeText(
                text: '${data.number}'.padLeft(2, '0'),
                layoutTransform: transform,
                offset: Offset(_minX + 1.0, data.center(figurePlane).dy),
                style: labelStyle,
              ),
            ),
        ],
      ),
    );
  }

  String bayPairTitle() {
    final bool withFortyFoots = widget.slots.any(
      (slot) => slot.bay.isEven && slot.containerId != null,
    );
    final bayPairTitle = withFortyFoots
        ? '${const Localized('BAY No.').v} ${widget.oddBayNumber != null ? '(${'${widget.oddBayNumber}'.padLeft(2, '0')})' : ''}${widget.evenBayNumber != null ? '${widget.evenBayNumber}'.padLeft(2, '0') : ''}'
        : '${const Localized('BAY No.').v} ${widget.oddBayNumber != null ? '${widget.oddBayNumber}'.padLeft(2, '0') : ''}${widget.evenBayNumber != null ? '(${'${widget.evenBayNumber}'.padLeft(2, '0')})' : ''}';
    return bayPairTitle;
  }

  String containersNumberTitle() {
    final fortyFootNumber = widget.slots
        .where((slot) => slot.containerId != null && slot.bay.isEven)
        .length;
    final twentyFootNumber = widget.slots
        .where((slot) => slot.containerId != null && slot.bay.isOdd)
        .length;
    return fortyFootNumber > 0
        ? '${const Localized('Containers').v}: ($twentyFootNumber)$fortyFootNumber'
        : '${const Localized('Containers').v}: $twentyFootNumber($fortyFootNumber)';
  }
}

///
class StowagePlanNumberingAxes {
  ///
  const StowagePlanNumberingAxes();

  ///
  List<StowagePlanNumberingData> tierNumberingAxis(List<Slot> slots) {
    final stowageCollection = StowageCollection.fromSlotList(slots);
    final tiers = slots.map((slot) => slot.tier);
    final maxTier = tiers.max;
    final tierNumberingData = stowageCollection
        .iterateTiers(maxTier)
        .map((tier) {
          final slotInTier = stowageCollection
              .toFilteredSlotList(
                tier: tier,
              )
              .firstOrNull;
          if (slotInTier == null) return null;
          return StowagePlanNumberingData(
            number: tier,
            start: Vector3(
              slotInTier.leftX,
              slotInTier.leftY,
              slotInTier.leftZ,
            ),
            end: Vector3(
              slotInTier.rightX,
              slotInTier.rightY,
              slotInTier.rightZ,
            ),
          );
        })
        .whereType<StowagePlanNumberingData>()
        .toList();
    return tierNumberingData;
  }

  ///
  List<StowagePlanNumberingData> rowNumberingAxis(List<Slot> slots) {
    final stowageCollection = StowageCollection.fromSlotList(slots);
    final rows = slots.map((slot) => slot.row);
    final maxRow = rows.max;
    final withZeroRow = rows.any((row) => row == 0);
    final rowNumberingData = stowageCollection
        .iterateRows(maxRow, withZeroRow)
        .map((row) {
          final slotInRow = stowageCollection
              .toFilteredSlotList(
                row: row,
              )
              .firstOrNull;
          if (slotInRow == null) return null;
          return StowagePlanNumberingData(
            number: row,
            start: Vector3(
              slotInRow.leftX,
              slotInRow.leftY,
              slotInRow.leftZ,
            ),
            end: Vector3(
              slotInRow.rightX,
              slotInRow.rightY,
              slotInRow.rightZ,
            ),
          );
        })
        .whereType<StowagePlanNumberingData>()
        .toList();
    return rowNumberingData;
  }
}

///
class StowagePlanNumberingData {
  final int number;
  final Vector3 start;
  final Vector3 end;

  ///
  const StowagePlanNumberingData({
    required this.number,
    required this.start,
    required this.end,
  });

  ///
  Offset center(FigurePlane plane) => switch (plane) {
        FigurePlane.xy =>
          Offset((start.x + end.x) / 2.0, (start.y + end.y) / 2.0),
        FigurePlane.xz =>
          Offset((start.x + end.x) / 2.0, (start.z + end.z) / 2.0),
        FigurePlane.yz =>
          Offset((start.y + end.y) / 2.0, (start.z + end.z) / 2.0),
      };
}

///
class BaySlotFigure {
  final bool isSelected;

  ///
  const BaySlotFigure({
    this.isSelected = false,
  });

  ///
  Figure slotFigure(Slot slot) {
    final color = isSelected ? Colors.amber : Colors.white;
    final fillColor = slot.bay.isEven ? Colors.blue : Colors.green;
    return RectangularCuboidFigure(
      paints: [
        Paint()
          ..color = color
          ..strokeWidth = 2.0
          ..style = PaintingStyle.stroke,
        if (slot.containerId != null)
          Paint()
            ..color = fillColor.withOpacity(0.25)
            ..style = PaintingStyle.fill,
      ],
      start: Vector3(slot.leftX, slot.leftY, slot.leftZ),
      end: Vector3(slot.rightX, slot.rightY, slot.rightZ),
    );
  }

  ///
  Figure limitFigure(Slot slot, Color color) {
    return RectangularCuboidFigure(
      paints: [
        Paint()
          ..color = color
          ..style = PaintingStyle.fill,
        Paint()
          ..color = color
          ..strokeWidth = 5.0
          ..style = PaintingStyle.stroke,
      ],
      start: Vector3(slot.leftX, slot.leftY, slot.minHeight),
      end: Vector3(slot.rightX, slot.rightY, slot.maxHeight),
    );
  }
}
