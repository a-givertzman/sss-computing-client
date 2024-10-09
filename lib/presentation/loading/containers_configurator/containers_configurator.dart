import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core.dart';
import 'package:hmi_core/hmi_core_app_settings.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:sss_computing_client/core/models/figure/figure.dart';
import 'package:sss_computing_client/core/models/figure/figure_plane.dart';
import 'package:sss_computing_client/core/models/figure/rectangular_cuboid_figure.dart';
import 'package:sss_computing_client/core/models/stowage/container/container.dart';
import 'package:sss_computing_client/core/models/stowage/container/container_1aa.dart';
import 'package:sss_computing_client/core/models/stowage/container/container_1cc.dart';
import 'package:sss_computing_client/core/models/stowage/faked_slots.dart';
import 'package:sss_computing_client/core/models/stowage/stowage/slot/slot.dart';
import 'package:sss_computing_client/core/models/stowage/stowage/stowage_collection/pretty_print_plan.dart';
import 'package:sss_computing_client/core/models/stowage/stowage/stowage_collection/stowage_map.dart';
import 'package:sss_computing_client/core/models/stowage/stowage/stowage_operation/put_container_operation.dart';
import 'package:sss_computing_client/core/models/stowage/stowage/stowage_operation/remove_container_operation.dart';
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
  late final StowageMap _stowagePlan;
  late final List<stowage.Container> _containers;
  late final ItemScrollController _itemScrollController;
  late final ItemPositionsListener _itemPositionsListener;
  /// For testing
  late List<Slot> _selectedSlots;
  late int? _selectedContainerId;
  //
  @override
  void initState() {
    _stowagePlan = StowageMap.fromSlotList(arkSlots);
    _containers = List.from(const [
      Container1CC(serial: 1, id: 1, tareWeight: 1.0),
      Container1AA(serial: 2, id: 2, tareWeight: 1.0),
    ]);
    _itemScrollController = ItemScrollController();
    _itemPositionsListener = ItemPositionsListener.create();
    //
    _selectedSlots = [];
    _selectedContainerId = null;
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
            child: ScrollablePositionedList.separated(
              itemScrollController: _itemScrollController,
              itemPositionsListener: _itemPositionsListener,
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
          SizedBox(
            height: 32.0,
            child: Center(
              child: ValueListenableBuilder<Iterable<ItemPosition>>(
                valueListenable: _itemPositionsListener.itemPositions,
                builder: (context, positions, child) {
                  int? min;
                  int? max;
                  if (positions.isNotEmpty) {
                    min = positions
                        .where((ItemPosition position) =>
                            position.itemTrailingEdge > 0)
                        .reduce((ItemPosition min, ItemPosition position) =>
                            position.itemTrailingEdge < min.itemTrailingEdge
                                ? position
                                : min)
                        .index;
                    max = positions
                        .where((ItemPosition position) =>
                            position.itemLeadingEdge < 1)
                        .reduce((ItemPosition max, ItemPosition position) =>
                            position.itemLeadingEdge > max.itemLeadingEdge
                                ? position
                                : max)
                        .index;
                  }
                  return ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: bayPairs.length,
                    itemBuilder: (_, index) => GestureDetector(
                      onTap: () => _itemScrollController.scrollTo(
                        index: index,
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.easeInOutCubic,
                        alignment: 0.5,
                      ),
                      child: BayPairsNumber(
                        index: index,
                        isVisible: min != null &&
                            max != null &&
                            index >= min &&
                            index <= max,
                        oddBayNumber: bayPairs[index].odd,
                        evenBayNumber: bayPairs[index].even,
                        slots: _stowagePlan.toFilteredSlotList(
                          shouldIncludeSlot: (slot) =>
                              slot.bay == bayPairs[index].odd ||
                              slot.bay == bayPairs[index].even,
                        ),
                      ),
                    ),
                    separatorBuilder: (_, __) => SizedBox(width: blockPadding),
                  );
                },
              ),
            ),
          ),
          SizedBox(height: blockPadding),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton.filled(
                icon: const Icon(Icons.add_rounded),
                onPressed:
                    (_selectedContainerId != null && _selectedSlots.isNotEmpty)
                        ? () => setState(() {
                              final container = _containers.firstWhere(
                                (c) => c.id == _selectedContainerId,
                              );
                              final slot = _selectedSlots
                                  .firstWhere((s) => switch (container.type) {
                                        ContainerType.type1AA => s.bay.isEven,
                                        ContainerType.type1CC => s.bay.isOdd,
                                      });
                              PutContainerOperation(
                                container: container,
                                bay: slot.bay,
                                row: slot.row,
                                tier: slot.tier,
                              ).execute(_stowagePlan);
                              _selectedSlots.clear();
                            })
                        : null,
              ),
              SizedBox(width: blockPadding),
              IconButton.filled(
                icon: const Icon(Icons.remove_rounded),
                onPressed: (_selectedSlots.isNotEmpty &&
                        _selectedSlots.any((s) => s.containerId != null))
                    ? () => setState(() {
                          for (final s in _selectedSlots) {
                            RemoveContainerOperation(
                              bay: s.bay,
                              row: s.row,
                              tier: s.tier,
                            ).execute(_stowagePlan);
                          }
                          _selectedSlots.clear();
                        })
                    : null,
              ),
            ],
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
class BayPairsNumber extends StatelessWidget {
  final int index;
  final bool isVisible;
  final int? oddBayNumber;
  final int? evenBayNumber;
  final List<Slot> slots;
  ///
  const BayPairsNumber({
    required this.index,
    super.key,
    this.isVisible = false,
    this.oddBayNumber,
    this.evenBayNumber,
    this.slots = const [],
  });
  //
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final labelStyle = theme.textTheme.labelLarge?.copyWith(
      color: theme.colorScheme.onSurface,
      backgroundColor: isVisible
          ? Colors.amber.withOpacity(0.75)
          : theme.colorScheme.primary.withOpacity(0.75),
    );
    return Text(bayPairTitle(), style: labelStyle);
  }
  String bayPairTitle() {
    final bool withFortyFoots = slots.any(
      (slot) => slot.bay.isEven && slot.containerId != null,
    );
    final bayPairTitle = withFortyFoots
        ? ' ${oddBayNumber != null ? '(${'$oddBayNumber'.padLeft(2, '0')})' : ''}${evenBayNumber != null ? '$evenBayNumber'.padLeft(2, '0') : ''}'
        : ' ${oddBayNumber != null ? '$oddBayNumber'.padLeft(2, '0') : ''}${evenBayNumber != null ? '(${'$evenBayNumber'.padLeft(2, '0')})' : ''}';
    return bayPairTitle;
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
            offset: Offset(0.0, _maxY - 2.5),
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
    final stowageCollection = StowageMap.fromSlotList(slots);
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
    final stowageCollection = StowageMap.fromSlotList(slots);
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
