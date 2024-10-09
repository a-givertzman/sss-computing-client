import 'package:hmi_core/hmi_core_result_new.dart';
import 'package:sss_computing_client/core/models/stowage/container/container.dart';
///
/// Simple representation of stowage slot,
/// a place where container can be loaded.
abstract interface class Slot {
  ///
  /// Bay number of stowage slot,
  /// in accordance with stowage numbering system for rows
  /// [ISO 9711-1, 3.1](https://www.iso.org/ru/standard/17568.html)
  int get bay;
  ///
  /// Row number of stowage slot,
  /// in accordance with stowage numbering system for rows
  /// [ISO 9711-1, 3.2](https://www.iso.org/ru/standard/17568.html)
  int get row;
  ///
  /// Tier number of stowage slot,
  /// in accordance with stowage numbering system for rows
  /// [ISO 9711-1, 3.3](https://www.iso.org/ru/standard/17568.html)
  int get tier;
  ///
  /// Coordinate of the leftmost point of stowage slot
  /// along the longitudinal axis, measured in m.
  double get leftX;
  ///
  /// Coordinate of the rightmost point of stowage slot
  /// along the longitudinal axis, measured in m.
  double get rightX;
  ///
  /// Coordinate of the leftmost point of stowage slot
  /// along the transverse axis, measured in m.
  double get leftY;
  ///
  /// Coordinate of the rightmost point of stowage slot
  /// along the transverse axis, measured in m.
  double get rightY;
  ///
  /// Coordinate of the leftmost point of stowage slot
  /// along the vertical axis, measured in m.
  double get leftZ;
  ///
  /// Coordinate of the rightmost point of stowage slot
  /// along the vertical axis, measured in m.
  double get rightZ;
  ///
  /// Maximum allowed value of the rightmost point of stowage slot
  /// along the vertical axis, measured in m.
  double get maxHeight;
  ///
  /// Minimum allowed value of the rightmost point of stowage slot
  /// along the vertical axis, measured in m.
  double get minHeight;
  ///
  /// Minimum allowed vertical distance to next stowage slot in the tier above,
  /// measured in m.
  double get minVerticalSeparation;
  ///
  /// Identifier of container that is placed in this slot.
  /// If slot is empty, [containerId] is `null`.
  int? get containerId;
  ///
  /// Creates an empty stowage slot for the next tier above this slot.
  ///
  /// The [verticalSeparation] parameter specifies the vertical distance between
  /// this slot and the new slot. If [verticalSeparation] is `null`, the
  /// [minVerticalSeparation] value is used.
  ///
  /// Returns [Ok] with the new slot if a slot for the next tier can be created,
  /// and [Ok] with `null` if a slot for the next tier cannot be created
  /// (e.g., it exceeds the maximum allowed height).
  ///
  /// Returns [Err] if input parameters are invalid
  /// (e.g., [verticalSeparation] is less than [minVerticalSeparation]).
  ResultF<Slot?> createUpperSlot({double? verticalSeparation});
  ///
  /// Creates a copy of this slot with the given [container] placed in it.
  /// The new slot's [rightZ] coordinate will be adjusted to fit the container's height.
  ///
  /// Returns [Ok] with the new slot if container can be placed in this slot.
  ///
  /// Returns [Err] if container cannot be placed in this slot
  /// (e.g., the slot already contains a container).
  ResultF<Slot> withContainer(Container container);
  ///
  /// Creates a copy of this slot with the container removed.
  ///
  /// Returns [Ok] with the new slot if container can be removed from this slot.
  ///
  /// Returns [Err] if container cannot be removed from this slot
  /// (e.g., the slot is already empty).
  ResultF<Slot> empty();
  ///
  /// Creates and returns a copy of this stowage slot.
  Slot copy();
}
