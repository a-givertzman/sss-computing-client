import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core.dart';
import 'package:hmi_core/hmi_core_app_settings.dart';
import 'package:sss_computing_client/core/models/figure/figure_plane.dart';
import 'package:sss_computing_client/core/models/stowage_plan/slot/slot.dart';
import 'package:sss_computing_client/core/widgets/scheme/scheme_figure.dart';
import 'package:sss_computing_client/core/widgets/scheme/scheme_layout.dart';
import 'package:sss_computing_client/core/widgets/scheme/scheme_text.dart';
import 'package:sss_computing_client/presentation/loading/widgets/containers_configurator/bay_pair_title.dart';
import 'package:sss_computing_client/presentation/loading/widgets/containers_configurator/bay_slot_figure.dart';
import 'package:sss_computing_client/presentation/loading/widgets/containers_configurator/stowage_plan_numbering_axes.dart';
import 'package:sss_computing_client/presentation/loading/widgets/containers_configurator/stowage_plan_numbering_item.dart';
///
/// Scheme of stowage plan for certain bay pair.
class BayPairScheme extends StatefulWidget {
  final int? _oddBayNumber;
  final int? _evenBayNumber;
  final bool _isThirtyFt;
  final List<Slot> _slots;
  final List<Slot> _selectedSlots;
  final void Function(
    int bay,
    int row,
    int tier,
    bool isThirtyFt,
  )? _onSlotTap;
  final void Function(
    int bat,
    int row,
    int tier,
    bool isThirtyFt,
  )? _onSlotDoubleTap;
  final void Function(
    int bat,
    int row,
    int tier,
    bool isThirtyFt,
  )? _onSlotSecondaryTap;
  final bool Function(Slot slot)? _isFlyoverSlot;
  final bool Function(Slot slot)? _shouldRenderEmptySlot;
  ///
  /// Widget that displays bay pair (sibling [oddBayNumber] and [evenBayNumber])
  /// scheme with provided [slots].
  ///
  /// * [oddBayNumber] - number of odd bay.
  /// * [evenBayNumber] - number of even bay.
  /// * [selectedSlots] - list of selected slots.
  /// * [onSlotTap] - callback for slot tap.
  /// * [onSlotDoubleTap] - callback for slot double tap.
  /// * [onSlotSecondaryTap] - callback for slot secondary tap.
  /// * [isFlyoverSlot] - tests that slot is flyover.
  /// * [shouldRenderEmptySlot] - tests that empty slot should be rendered.
  const BayPairScheme({
    super.key,
    required int? oddBayNumber,
    required int? evenBayNumber,
    required List<Slot> selectedSlots,
    required bool isThirtyFt,
    void Function(int, int, int, bool)? onSlotTap,
    void Function(int, int, int, bool)? onSlotDoubleTap,
    void Function(int, int, int, bool)? onSlotSecondaryTap,
    bool Function(Slot)? isFlyoverSlot,
    bool Function(Slot)? shouldRenderEmptySlot,
    List<Slot> slots = const [],
  })  : _oddBayNumber = oddBayNumber,
        _evenBayNumber = evenBayNumber,
        _slots = slots,
        _selectedSlots = selectedSlots,
        _isThirtyFt = isThirtyFt,
        _onSlotTap = onSlotTap,
        _onSlotDoubleTap = onSlotDoubleTap,
        _onSlotSecondaryTap = onSlotSecondaryTap,
        _isFlyoverSlot = isFlyoverSlot,
        _shouldRenderEmptySlot = shouldRenderEmptySlot;
  //
  @override
  State<BayPairScheme> createState() => _BayPairSchemeState();
}
///
class _BayPairSchemeState extends State<BayPairScheme> {
  static const int _minDeckTier = 80;
  late List<StowagePlanNumberingItem> _tierNumbering;
  late List<StowagePlanNumberingItem> _rowNumbering;
  late int _containersNumberOnDeck;
  late int _containersNumberInHold;
  late bool _withFourtyFtContainers;
  //
  @override
  void initState() {
    const numberingAxes = StowagePlanNumberingAxes();
    _tierNumbering = numberingAxes.tierNumberingAxis(widget._slots);
    _rowNumbering = numberingAxes.rowNumberingAxis(widget._slots);
    _containersNumberOnDeck = _containersNumber(
      widget._slots,
      isOnDeck: false,
    );
    _containersNumberInHold = _containersNumber(
      widget._slots,
      isOnDeck: true,
    );
    _withFourtyFtContainers = widget._slots.any(
      (slot) => slot.bay.isEven && slot.containerId != null,
    );
    super.initState();
  }
  //
  @override
  void didUpdateWidget(BayPairScheme oldWidget) {
    if (widget._slots != oldWidget._slots) {
      const numberingAxes = StowagePlanNumberingAxes();
      _tierNumbering = numberingAxes.tierNumberingAxis(widget._slots);
      _rowNumbering = numberingAxes.rowNumberingAxis(widget._slots);
      _containersNumberOnDeck = _containersNumber(
        widget._slots,
        isOnDeck: false,
      );
      _containersNumberInHold = _containersNumber(
        widget._slots,
        isOnDeck: true,
      );
      _withFourtyFtContainers = widget._slots.any(
        (slot) => slot.bay.isEven && slot.containerId != null,
      );
    }
    super.didUpdateWidget(oldWidget);
  }
  //
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final labelStyle = theme.textTheme.labelLarge;
    const figurePlane = FigurePlane.yz;
    final (minX, maxX) = (
      const Setting('shipMinY_m').toDouble,
      const Setting('shipMaxY_m').toDouble
    );
    final (minY, maxY) = (
      const Setting('shipMinWithGapZ_m').toDouble,
      const Setting('shipMaxWithGapZ_m').toDouble
    );
    final holdDeckSeparationZ =
        const Setting('shipHoldDeckSeparationZ_m').toDouble;
    const schemeHorizontalPad = 1.0;
    const schemeVerticalPad = 1.0;
    return SchemeLayout(
      fit: BoxFit.contain,
      minX: minX,
      maxX: maxX,
      minY: minY,
      maxY: maxY,
      yAxisReversed: true,
      buildContent: (_, transform) => Stack(
        children: [
          // Draw slots limits
          ...widget._slots.map(
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
          // Draw empty slots
          ...widget._slots
              .where((s) =>
                  s.containerId == null &&
                  s.isActive &&
                  (widget._shouldRenderEmptySlot?.call(s) ?? true))
              .map(
                (slot) => Positioned.fill(
                  child: SchemeFigure(
                    plane: figurePlane,
                    figure: BaySlotFigure(
                      isFlyover: widget._isFlyoverSlot?.call(slot) ?? false,
                    ).slotFigure(slot),
                    layoutTransform: transform,
                    onTap: () => widget._onSlotTap?.call(
                      slot.bay,
                      slot.row,
                      slot.tier,
                      slot.isThirtyFt,
                    ),
                    onDoubleTap: () => widget._onSlotDoubleTap?.call(
                      slot.bay,
                      slot.row,
                      slot.tier,
                      slot.isThirtyFt,
                    ),
                    onSecondaryTap: () => widget._onSlotSecondaryTap?.call(
                      slot.bay,
                      slot.row,
                      slot.tier,
                      slot.isThirtyFt,
                    ),
                  ),
                ),
              ),
          // Draw occupied slots
          ...widget._slots
              .where((s) => s.containerId != null && s.isActive)
              .map(
                (slot) => Positioned.fill(
                  child: SchemeFigure(
                    plane: figurePlane,
                    figure: BaySlotFigure(
                      isFlyover: widget._isFlyoverSlot?.call(slot) ?? false,
                    ).slotFigure(slot),
                    layoutTransform: transform,
                    onTap: () => widget._onSlotTap?.call(
                      slot.bay,
                      slot.row,
                      slot.tier,
                      slot.isThirtyFt,
                    ),
                    onDoubleTap: () => widget._onSlotDoubleTap?.call(
                      slot.bay,
                      slot.row,
                      slot.tier,
                      slot.isThirtyFt,
                    ),
                    onSecondaryTap: () => widget._onSlotSecondaryTap?.call(
                      slot.bay,
                      slot.row,
                      slot.tier,
                      slot.isThirtyFt,
                    ),
                  ),
                ),
              ),
          // Draw selected slots
          ...widget._selectedSlots.map(
            (slot) => Positioned.fill(
              child: SchemeFigure(
                plane: figurePlane,
                figure: BaySlotFigure(
                  isFlyover: widget._isFlyoverSlot?.call(slot) ?? false,
                  isSelected: true,
                ).slotFigure(slot),
                layoutTransform: transform,
                onTap: () => widget._onSlotTap?.call(-1, -1, -1, false),
                onDoubleTap: () => widget._onSlotDoubleTap?.call(
                  slot.bay,
                  slot.row,
                  slot.tier,
                  slot.isThirtyFt,
                ),
                onSecondaryTap: () => widget._onSlotSecondaryTap?.call(
                  slot.bay,
                  slot.row,
                  slot.tier,
                  slot.isThirtyFt,
                ),
              ),
            ),
          ),
          SchemeText(
            text: const Localized('Bay No.').v +
                BayPairTitle(
                  withFortyFoots: _withFourtyFtContainers,
                  isThirtyFt: widget._isThirtyFt,
                  oddBayNumber: widget._oddBayNumber,
                  evenBayNumber: widget._evenBayNumber,
                ).title(),
            offset: Offset(0.0, maxY - schemeVerticalPad),
            style: labelStyle,
            alignment: Alignment.bottomCenter,
            layoutTransform: transform,
          ),
          SchemeText(
            text: '$_containersNumberOnDeck',
            offset: Offset(
              maxX - schemeHorizontalPad,
              holdDeckSeparationZ + schemeVerticalPad,
            ),
            style: labelStyle,
            alignment: Alignment.centerLeft,
            layoutTransform: transform,
          ),
          SchemeText(
            text: '$_containersNumberInHold',
            offset: Offset(
              maxX - schemeHorizontalPad,
              holdDeckSeparationZ - schemeVerticalPad,
            ),
            style: labelStyle,
            alignment: Alignment.centerLeft,
            layoutTransform: transform,
          ),
          ..._tierNumbering.map(
            (data) => SchemeText(
              text: '${data.number}'.padLeft(2, '0'),
              layoutTransform: transform,
              offset: Offset(
                minX + schemeHorizontalPad,
                data.center(figurePlane).dy,
              ),
              alignment: Alignment.centerRight,
              style: labelStyle,
            ),
          ),
          ..._rowNumbering.map(
            (data) => SchemeText(
              text: '${data.number}'.padLeft(2, '0'),
              layoutTransform: transform,
              offset: Offset(
                data.center(figurePlane).dx,
                minY + schemeVerticalPad,
              ),
              alignment: Alignment.topCenter,
              style: labelStyle,
            ),
          ),
        ],
      ),
    );
  }
  //
  int _containersNumber(List<Slot> slots, {bool isOnDeck = false}) {
    return slots
        .where((slot) =>
            slot.containerId != null &&
            (isOnDeck ? slot.tier >= _minDeckTier : slot.tier < _minDeckTier))
        .length;
  }
}
