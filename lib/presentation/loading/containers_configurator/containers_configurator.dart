import 'dart:convert';
import 'package:collection/collection.dart';
import 'package:ext_rw/ext_rw.dart';
import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core_app_settings.dart';
import 'package:sss_computing_client/core/models/figure/figure.dart';
import 'package:sss_computing_client/core/models/figure/figure_plane.dart';
import 'package:sss_computing_client/core/models/figure/json_svg_path_projections.dart';
import 'package:sss_computing_client/core/models/figure/path_projections.dart';
import 'package:sss_computing_client/core/models/figure/path_projections_figure.dart';
import 'package:sss_computing_client/core/models/figure/rectangular_cuboid_figure.dart';
import 'package:sss_computing_client/core/models/record/field_record.dart';
import 'package:sss_computing_client/core/models/stowage/container/container_1cc.dart';
import 'package:sss_computing_client/core/models/stowage/faked_slots.dart';
import 'package:sss_computing_client/core/models/stowage/stowage/pretty_print_plan.dart';
import 'package:sss_computing_client/core/models/stowage/stowage/slot.dart';
import 'package:sss_computing_client/core/models/stowage/stowage/stowage_collection.dart';
import 'package:sss_computing_client/core/models/stowage/stowage/stowage_plan.dart';
import 'package:sss_computing_client/core/widgets/future_builder_widget.dart';
import 'package:sss_computing_client/core/widgets/scheme/scheme_figure.dart';
import 'package:sss_computing_client/core/widgets/scheme/scheme_layout.dart';
import 'package:sss_computing_client/core/widgets/scheme/scheme_text.dart';
import 'package:vector_math/vector_math_64.dart' hide Colors;
///
class ContainersConfigurator extends StatefulWidget {
  ///
  const ContainersConfigurator({super.key});
  //
  @override
  State<ContainersConfigurator> createState() => _ContainersConfiguratorState();
}
class _ContainersConfiguratorState extends State<ContainersConfigurator> {
  late final ApiAddress _apiAddress;
  late final String _dbName;
  late final String _authToken;
  late final StowagePlan _stowagePlan;
  /// For testing
  Slot? _selectedSlot;
  //
  @override
  // ignore: long-method
  void initState() {
    _apiAddress = ApiAddress(
      host: const Setting('api-host').toString(),
      port: const Setting('api-port').toInt,
    );
    _dbName = const Setting('api-database').toString();
    _authToken = const Setting('api-auth-token').toString();
    _stowagePlan = StowageCollection.fromSlotList(arkSlots);
    _stowagePlan.addContainer(
      const Container1CC(id: 1),
      bay: 1,
      row: 1,
      tier: 2,
    );
    _stowagePlan.addContainer(
      const Container1CC(id: 2),
      bay: 1,
      row: 2,
      tier: 2,
    );
    _stowagePlan.addContainer(
      const Container1CC(id: 1),
      bay: 22,
      row: 4,
      tier: 2,
    );
    _stowagePlan.addContainer(
      const Container1CC(id: 2),
      bay: 22,
      row: 2,
      tier: 2,
    );
    _stowagePlan.addContainer(
      const Container1CC(id: 1),
      bay: 23,
      row: 3,
      tier: 2,
    );
    _stowagePlan.addContainer(
      const Container1CC(id: 2),
      bay: 23,
      row: 1,
      tier: 2,
    );
    _stowagePlan.addContainer(
      const Container1CC(id: 1),
      bay: 20,
      row: 4,
      tier: 2,
    );
    _stowagePlan.addContainer(
      const Container1CC(id: 2),
      bay: 20,
      row: 2,
      tier: 2,
    );
    _stowagePlan.addContainer(
      const Container1CC(id: 1),
      bay: 20,
      row: 3,
      tier: 4,
    );
    _stowagePlan.addContainer(
      const Container1CC(id: 2),
      bay: 20,
      row: 1,
      tier: 4,
    );
    _stowagePlan.addContainer(
      const Container1CC(id: 3),
      bay: 24,
      row: 4,
      tier: 82,
    );
    _stowagePlan.addContainer(
      const Container1CC(id: 4),
      bay: 24,
      row: 4,
      tier: 84,
    );
    _stowagePlan.addContainer(
      const Container1CC(id: 5),
      bay: 24,
      row: 4,
      tier: 86,
    );
    _stowagePlan.addContainer(
      const Container1CC(id: 3),
      bay: 22,
      row: 3,
      tier: 82,
    );
    _stowagePlan.addContainer(
      const Container1CC(id: 3),
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
    return FutureBuilderWidget(
      onFuture: FieldRecord<PathProjections>(
        tableName: 'ship_geometry',
        fieldName: 'hull_svg',
        dbName: _dbName,
        apiAddress: _apiAddress,
        authToken: _authToken,
        toValue: (value) => JsonSvgPathProjections(
          json: json.decode(value),
        ),
        filter: const {'id': 1},
      ).fetch,
      caseData: (context, pathProjections, _) => Padding(
        padding: EdgeInsets.all(blockPadding),
        child: Column(
          children: [
            Expanded(
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: bayPairs.length,
                itemBuilder: (_, index) => BayPlan(
                  hullProjections: pathProjections,
                  oddBayNumber: bayPairs[index].odd,
                  evenBayNumber: bayPairs[index].even,
                  slots: _stowagePlan.toFilteredSlotList(
                    shouldIncludeSlot: (slot) =>
                        slot.bay == bayPairs[index].odd ||
                        slot.bay == bayPairs[index].even,
                  ),
                  onSlotSelected: (bay, row, tier) => setState(() {
                    _selectedSlot = _stowagePlan.findSlot(bay, row, tier);
                  }),
                  selectedSlot: (bayPairs[index].odd == _selectedSlot?.bay ||
                          bayPairs[index].even == _selectedSlot?.bay)
                      ? _selectedSlot
                      : null,
                ),
                separatorBuilder: (_, __) => SizedBox(width: blockPadding),
              ),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
///
class BayPlan extends StatefulWidget {
  final PathProjections hullProjections;
  final int? oddBayNumber;
  final int? evenBayNumber;
  final List<Slot> slots;
  final Slot? selectedSlot;
  final Function(int bay, int row, int tier)? onSlotSelected;
  ///
  const BayPlan({
    super.key,
    required this.hullProjections,
    required this.oddBayNumber,
    required this.evenBayNumber,
    this.onSlotSelected,
    this.selectedSlot,
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
    final hullFigure = PathProjectionsFigure(
      paints: [
        Paint()
          ..color = Colors.white.withOpacity(0.25)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2.0,
      ],
      pathProjections: widget.hullProjections,
    );
    final bayPairTitle =
        'BAY No. ${widget.oddBayNumber != null ? '${widget.oddBayNumber}'.padLeft(2, '0') : ''}${widget.evenBayNumber != null ? '(${'${widget.evenBayNumber}'.padLeft(2, '0')})' : ''}';
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
          ...uniqueSlots(widget.slots).map(
            (slot) => Positioned.fill(
              child: SchemeFigure(
                plane: figurePlane,
                figure: const BaySlotFigure().limitFigure(
                  slot,
                  theme.colorScheme.background,
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
          if (widget.selectedSlot != null)
            Positioned.fill(
              child: SchemeFigure(
                plane: figurePlane,
                figure: const BaySlotFigure(
                  isSelected: true,
                ).slotFigure(widget.selectedSlot!),
                layoutTransform: transform,
                onTap: () => widget.onSlotSelected?.call(-1, -1, -1),
              ),
            ),
          SchemeText(
            text: bayPairTitle,
            offset: Offset(0.0, _maxY - 1.0),
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
  List<Slot> uniqueSlots(List<Slot> slots) {
    final Set<int> rows = {};
    final uniques = <Slot>[];
    for (final slot in slots) {
      if (!rows.contains(slot.row)) {
        rows.add(slot.row);
        uniques.add(slot.copyWith(containerId: slot.containerId));
      }
    }
    return slots;
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
    final fillColor = slot.bay.isEven ? Colors.green : Colors.blue;
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
