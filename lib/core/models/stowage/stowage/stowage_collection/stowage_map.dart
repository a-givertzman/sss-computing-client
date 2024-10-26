import 'package:sss_computing_client/core/models/stowage/stowage/slot/slot.dart';
import 'package:sss_computing_client/core/models/stowage/stowage/stowage_collection/stowage_collection.dart';
///
/// [StowageCollection] that uses [Map] to store stowage plan.
///
/// Each key of [Map] is string representation of slot key in format BBRRTT
/// in accordance with [ISO 668](https://www.iso.org/ru/standard/76912.html).
/// Each value of [Map] is a [Slot] of stowage plan.
class StowageMap implements StowageCollection {
  ///
  /// [Map] that used to store stowage slots of plan.
  ///
  /// Key of [Map] entry is string representation of slot key in format BBRRTT
  /// in accordance with [ISO 668](https://www.iso.org/ru/standard/76912.html).
  final Map<String, Slot> _plan;
  ///
  /// Creates stowage plan from given [plan].
  StowageMap._(Map<String, Slot> plan) : _plan = plan;
  ///
  /// Creates stowage plan from list of [slots].
  ///
  /// Copies of given [slots] are used to create stowage plan.
  factory StowageMap.fromSlotList(List<Slot> slots) =>
      StowageMap._(Map.fromEntries(
        slots.map((slot) => MapEntry(
              _SlotKey.fromSlot(slot).value(),
              slot.copy(),
            )),
      ));
  ///
  /// Creates empty stowage plan.
  factory StowageMap.empty() => StowageMap._({});
  ///
  //
  @override
  Slot? findSlot(
    int bay,
    int row,
    int tier,
  ) =>
      _plan[_SlotKey(bay, row, tier).value()];
  //
  @override
  List<Slot> toFilteredSlotList({
    int? bay,
    int? row,
    int? tier,
    bool Function(Slot slot)? shouldIncludeSlot,
  }) =>
      _plan.values.where((slot) {
        if (bay != null && slot.bay != bay) return false;
        if (row != null && slot.row != row) return false;
        if (tier != null && slot.tier != tier) return false;
        if (shouldIncludeSlot?.call(slot) == false) return false;
        return true;
      }).toList();
  //
  @override
  void addSlot(Slot slot) {
    _plan[_SlotKey.fromSlot(slot).value()] = slot.copy();
  }
  //
  @override
  void addAllSlots(List<Slot> slots) {
    for (final slot in slots) {
      addSlot(slot);
    }
  }
  //
  @override
  void removeSlot(int bay, int row, int tier) {
    _plan.remove(_SlotKey(bay, row, tier).value());
  }
  //
  @override
  void removeAllSlots() {
    _plan.clear();
  }
  //
  @override
  StowageCollection copy() {
    return StowageMap.fromSlotList(
      toFilteredSlotList(),
    );
  }
  //
  @override
  String toString() => _plan.toString();
}
///
/// Generates a unique key for a slot based on its bay, row, and tier numbers
/// in format BBRRTT in accordance with [ISO 668](https://www.iso.org/ru/standard/76912.html).
class _SlotKey {
  ///
  /// Bay number of stowage slot,
  /// in accordance with stowage numbering system for rows
  /// [ISO 9711-1, 3.1](https://www.iso.org/ru/standard/17568.html)
  final int _bay;
  ///
  /// Row number of stowage slot,
  /// in accordance with stowage numbering system for rows
  /// [ISO 9711-1, 3.2](https://www.iso.org/ru/standard/17568.html)
  final int _row;
  ///
  /// Tier number of stowage slot,
  /// in accordance with stowage numbering system for rows
  /// [ISO 9711-1, 3.3](https://www.iso.org/ru/standard/17568.html)
  final int _tier;
  ///
  /// Creates [_SlotKey] from given [bay], [row] and [tier] numbers.
  const _SlotKey(
    int bay,
    int row,
    int tier,
  )   : _tier = tier,
        _row = row,
        _bay = bay;
  ///
  /// Creates [_SlotKey] from given [slot].
  factory _SlotKey.fromSlot(Slot slot) => _SlotKey(
        slot.bay,
        slot.row,
        slot.tier,
      );
  ///
  /// Returns string representation of slot key in format BBRRTT.
  String value() => toString();
  ///
  /// Returns string representation of slot key in format BBRRTT.
  @override
  String toString() =>
      '${_bay.toString().padLeft(2, '0')}${_row.toString().padLeft(2, '0')}${_tier.toString().padLeft(2, '0')}';
}
