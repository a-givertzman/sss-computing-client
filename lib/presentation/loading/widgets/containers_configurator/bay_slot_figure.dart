import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core_app_settings.dart';
import 'package:sss_computing_client/core/models/figure/figure.dart';
import 'package:sss_computing_client/core/models/figure/rectangular_cuboid_figure.dart';
import 'package:sss_computing_client/core/models/stowage_plan/container/freight_container_type.dart';
import 'package:sss_computing_client/core/models/stowage_plan/slot/slot.dart';
import 'package:vector_math/vector_math_64.dart' hide Colors;
///
/// [Figure] for displaying slot.
class BaySlotFigure {
  /// Indicates that slot is selected.
  static const selectedColor = Colors.amber;
  /// Indicates that slot is flyover.
  static const flyoverColor = Colors.brown;
  /// Indicates that slot is occupied.
  static const occupiedColor = Colors.white;
  /// Indicates that slot is empty.
  static const emptyColor = Color.fromARGB(255, 113, 113, 113);
  //
  final bool _isSelected;
  final bool _isFlyover;
  ///
  /// Creates [Figure] for displaying slot.
  ///
  /// * [isSelected] - indicates that slot is selected.
  /// * [isFlyover] - indicates that slot is flyover.
  const BaySlotFigure({
    bool isSelected = false,
    bool isFlyover = false,
  })  : _isSelected = isSelected,
        _isFlyover = isFlyover;
  ///
  /// Returns [Figure] that displays slot.
  Figure slotFigure(Slot slot) {
    final strokeColor = _isSelected
        ? selectedColor
        : slot.containerId != null
            ? occupiedColor
            : emptyColor;
    final fillColor = _isFlyover ? flyoverColor : _slotWithContainerColor(slot);
    final fillOpacity = const Setting('opacityLow').toDouble;
    return RectangularCuboidFigure(
      paints: [
        if (slot.containerId != null || _isFlyover)
          Paint()
            ..color = fillColor.withOpacity(fillOpacity)
            ..style = PaintingStyle.fill,
        Paint()
          ..color = strokeColor
          ..strokeWidth = const Setting('strokeWidth').toDouble
          ..style = PaintingStyle.stroke,
      ],
      start: Vector3(slot.leftX, slot.leftY, slot.leftZ),
      end: Vector3(slot.rightX, slot.rightY, slot.rightZ),
    );
  }
  ///
  /// Returns [Figure] that displays slot limits.
  Figure limitFigure(Slot slot, Color color) {
    return RectangularCuboidFigure(
      paints: [
        Paint()
          ..color = color
          ..style = PaintingStyle.fill,
        Paint()
          ..color = color
          ..strokeWidth = const Setting('strokeWidth', factor: 2).toDouble
          ..style = PaintingStyle.stroke,
      ],
      start: Vector3(slot.leftX, slot.leftY, slot.minHeight),
      end: Vector3(slot.rightX, slot.rightY, slot.maxHeight),
    );
  }
  //
  Color _slotWithContainerColor(Slot slot) {
    return slot.isThirtyFt
        ? FreightContainerType.type1B.color
        : slot.bay.isEven
            ? FreightContainerType.type1A.color
            : FreightContainerType.type1C.color;
  }
}
