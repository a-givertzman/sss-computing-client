import 'package:collection/collection.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hmi_core/hmi_core.dart';
import 'package:sss_computing_client/core/models/stowage_plan/container/freight_container.dart';
import 'package:sss_computing_client/core/models/stowage_plan/container/freight_container_type.dart';
import 'package:sss_computing_client/core/models/stowage_plan/slot/slot.dart';
import 'package:sss_computing_client/core/models/stowage_plan/slot/standard_slot.dart';
import 'package:sss_computing_client/core/models/stowage_plan/stowage_collection/stowage_collection.dart';
import 'package:sss_computing_client/core/models/stowage_plan/stowage_operation/put_container_operation.dart';
///
class FakeStowageCollection implements StowageCollection {
  List<Slot> _slots = [];
  ///
  FakeStowageCollection._(List<Slot> slots) : _slots = slots;
  ///
  factory FakeStowageCollection.fromSlots(List<Slot> slots) {
    return FakeStowageCollection._(slots.map((s) => s.copy()).toList());
  }
  //
  @override
  Slot? findSlot(int bay, int row, int tier) {
    return _slots.firstWhereOrNull(
      (slot) => slot.bay == bay && slot.row == row && slot.tier == tier,
    );
  }
  //
  @override
  void addSlot(Slot slot) {
    removeSlot(slot.bay, slot.row, slot.tier);
    _slots.add(slot);
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
    _slots.removeWhere(
      (slot) => slot.bay == bay && slot.row == row && slot.tier == tier,
    );
  }
  //
  @override
  void removeAllSlots() {
    _slots.clear();
  }
  //
  @override
  List<Slot> toFilteredSlotList({
    int? bay,
    int? row,
    int? tier,
    bool Function(Slot slot)? shouldIncludeSlot,
  }) {
    List<Slot> filteredSlots = _slots;
    if (bay != null) {
      filteredSlots = filteredSlots.where((slot) => slot.bay == bay).toList();
    }
    if (row != null) {
      filteredSlots = filteredSlots.where((slot) => slot.row == row).toList();
    }
    if (tier != null) {
      filteredSlots = filteredSlots.where((slot) => slot.tier == tier).toList();
    }
    if (shouldIncludeSlot != null) {
      filteredSlots =
          filteredSlots.where((slot) => shouldIncludeSlot(slot)).toList();
    }
    return filteredSlots;
  }
  //
  @override
  StowageCollection copy() {
    return FakeStowageCollection.fromSlots(_slots);
  }
}
///
/// Fake implementation of [FreightContainer]
class FakeContainer implements FreightContainer {
  @override
  final int id;
  @override
  final double height; // in meters
  @override
  double get width => 2438 / 1000;
  @override
  double get length => 6058 / 1000;
  @override
  double get grossWeight => 0.0;
  @override
  double get tareWeight => 0.0;
  @override
  double get cargoWeight => 0.0;
  @override
  FreightContainerType get type => FreightContainerType.type1AA;
  @override
  Map<String, dynamic> asMap() => {};
  @override
  int get checkDigit => 0;
  @override
  double get maxGrossWeight => 0.0;
  @override
  String get ownerCode => '';
  @override
  int? get podWaypointId => null;
  @override
  int? get polWaypointId => null;
  @override
  int get serialCode => 0;
  @override
  String get typeCode => '';
  //
  const FakeContainer({
    required this.id,
    this.height = 1,
  });
}
//
void main() {
  //
  group('PutContainerOperation execute method', () {
    late FakeStowageCollection collection;
    //
    setUp(() {
      // BAY No. 01
      // 06     [ ] [ ] [ ]
      // 04     [ ] [ ] [▥]
      // 02     [▥] [ ] [ ]
      //     04  02  01  03
      collection = FakeStowageCollection.fromSlots(const [
        // BAY No. 01
        StandardSlot(
          bay: 1,
          row: 1,
          tier: 2,
          leftX: 0.0,
          rightX: 1.0,
          leftY: 0.0,
          rightY: 1.0,
          leftZ: 0.0,
          rightZ: 1.0,
          maxHeight: 10.0,
          minHeight: 0.0,
          minVerticalSeparation: 0.5,
          containerId: null,
        ),
        StandardSlot(
          bay: 1,
          row: 1,
          tier: 4,
          leftX: 0.0,
          rightX: 1.0,
          leftY: 0.0,
          rightY: 1.0,
          leftZ: 1.5,
          rightZ: 2.5,
          maxHeight: 10.0,
          minHeight: 0.0,
          minVerticalSeparation: 0.5,
          containerId: null,
        ),
        StandardSlot(
          bay: 1,
          row: 1,
          tier: 6,
          leftX: 0.0,
          rightX: 1.0,
          leftY: 0.0,
          rightY: 1.0,
          leftZ: 3.0,
          rightZ: 4.0,
          maxHeight: 10.0,
          minHeight: 0.0,
          minVerticalSeparation: 0.5,
          containerId: null,
        ),
        StandardSlot(
          bay: 1,
          row: 2,
          tier: 2,
          leftX: 0.0,
          rightX: 1.0,
          leftY: 0.0,
          rightY: 1.0,
          leftZ: 0.0,
          rightZ: 1.0,
          maxHeight: 10.0,
          minHeight: 0.0,
          minVerticalSeparation: 0.5,
          containerId: 1,
        ),
        StandardSlot(
          bay: 1,
          row: 2,
          tier: 4,
          leftX: 0.0,
          rightX: 1.0,
          leftY: 1.0,
          rightY: 2.0,
          leftZ: 1.5,
          rightZ: 2.5,
          maxHeight: 10.0,
          minHeight: 0.0,
          minVerticalSeparation: 0.5,
          containerId: null,
        ),
        StandardSlot(
          bay: 1,
          row: 2,
          tier: 6,
          leftX: 0.0,
          rightX: 1.0,
          leftY: 1.0,
          rightY: 2.0,
          leftZ: 3.0,
          rightZ: 4.0,
          maxHeight: 10.0,
          minHeight: 0.0,
          minVerticalSeparation: 0.5,
          containerId: null,
        ),
        StandardSlot(
          bay: 1,
          row: 3,
          tier: 2,
          leftX: 0.0,
          rightX: 1.0,
          leftY: 2.0,
          rightY: 3.0,
          leftZ: 0.0,
          rightZ: 1.0,
          maxHeight: 2.0,
          minHeight: 0.0,
          minVerticalSeparation: 0.5,
          containerId: null,
        ),
        StandardSlot(
          bay: 1,
          row: 3,
          tier: 4,
          leftX: 0.0,
          rightX: 1.0,
          leftY: 2.0,
          rightY: 3.0,
          leftZ: 1.5,
          rightZ: 2.5,
          maxHeight: 2.0,
          minHeight: 0.0,
          minVerticalSeparation: 0.5,
          containerId: 1,
        ),
        StandardSlot(
          bay: 1,
          row: 3,
          tier: 6,
          leftX: 0.0,
          rightX: 1.0,
          leftY: 2.0,
          rightY: 3.0,
          leftZ: 3.0,
          rightZ: 4.0,
          maxHeight: 2.0,
          minHeight: 0.0,
          minVerticalSeparation: 0.5,
          containerId: null,
        ),
        // BAY No. 02
        // 06         [ ]
        // 04     [ ] [ ] [ ]
        // 02     [ ] [ ] [ ]
        //     04  02  01  03
        StandardSlot(
          bay: 2,
          row: 1,
          tier: 2,
          leftX: 1.0,
          rightX: 2.0,
          leftY: 0.0,
          rightY: 1.0,
          leftZ: 0.0,
          rightZ: 1.0,
          maxHeight: 10.0,
          minHeight: 0.0,
          minVerticalSeparation: 0.5,
          containerId: null,
        ),
        StandardSlot(
          bay: 2,
          row: 1,
          tier: 4,
          leftX: 1.0,
          rightX: 2.0,
          leftY: 0.0,
          rightY: 1.0,
          leftZ: 1.5,
          rightZ: 2.5,
          maxHeight: 10.0,
          minHeight: 0.0,
          minVerticalSeparation: 0.5,
          containerId: null,
        ),
        StandardSlot(
          bay: 2,
          row: 1,
          tier: 6,
          leftX: 1.0,
          rightX: 2.0,
          leftY: 0.0,
          rightY: 1.0,
          leftZ: 3.0,
          rightZ: 4.0,
          maxHeight: 10.0,
          minHeight: 0.0,
          minVerticalSeparation: 0.5,
          containerId: null,
        ),
        StandardSlot(
          bay: 2,
          row: 2,
          tier: 2,
          leftX: 1.0,
          rightX: 2.0,
          leftY: 0.0,
          rightY: 1.0,
          leftZ: 0.0,
          rightZ: 1.0,
          maxHeight: 10.0,
          minHeight: 0.0,
          minVerticalSeparation: 0.5,
          containerId: 1,
        ),
        StandardSlot(
          bay: 2,
          row: 2,
          tier: 4,
          leftX: 1.0,
          rightX: 2.0,
          leftY: 1.0,
          rightY: 2.0,
          leftZ: 1.5,
          rightZ: 2.5,
          maxHeight: 10.0,
          minHeight: 0.0,
          minVerticalSeparation: 0.5,
          containerId: null,
        ),
        StandardSlot(
          bay: 2,
          row: 3,
          tier: 2,
          leftX: 1.0,
          rightX: 2.0,
          leftY: 2.0,
          rightY: 3.0,
          leftZ: 0.0,
          rightZ: 1.0,
          maxHeight: 2.0,
          minHeight: 0.0,
          minVerticalSeparation: 0.5,
          containerId: null,
        ),
        StandardSlot(
          bay: 2,
          row: 3,
          tier: 4,
          leftX: 1.0,
          rightX: 2.0,
          leftY: 2.0,
          rightY: 3.0,
          leftZ: 1.5,
          rightZ: 2.5,
          maxHeight: 2.0,
          minHeight: 0.0,
          minVerticalSeparation: 0.5,
          containerId: 1,
        ),
        // BAY No. 03
        // 06         [ ]
        // 04     [ ] [ ] [ ]
        // 02     [ ] [ ] [ ]
        //     04  02  01  03
        StandardSlot(
          bay: 3,
          row: 1,
          tier: 2,
          leftX: 2.0,
          rightX: 3.0,
          leftY: 0.0,
          rightY: 1.0,
          leftZ: 0.0,
          rightZ: 1.0,
          maxHeight: 10.0,
          minHeight: 0.0,
          minVerticalSeparation: 0.5,
          containerId: null,
        ),
        StandardSlot(
          bay: 3,
          row: 1,
          tier: 4,
          leftX: 2.0,
          rightX: 3.0,
          leftY: 0.0,
          rightY: 1.0,
          leftZ: 1.5,
          rightZ: 2.5,
          maxHeight: 10.0,
          minHeight: 0.0,
          minVerticalSeparation: 0.5,
          containerId: null,
        ),
        StandardSlot(
          bay: 3,
          row: 1,
          tier: 6,
          leftX: 2.0,
          rightX: 3.0,
          leftY: 0.0,
          rightY: 1.0,
          leftZ: 3.0,
          rightZ: 4.0,
          maxHeight: 10.0,
          minHeight: 0.0,
          minVerticalSeparation: 0.5,
          containerId: null,
        ),
        StandardSlot(
          bay: 3,
          row: 2,
          tier: 2,
          leftX: 2.0,
          rightX: 3.0,
          leftY: 0.0,
          rightY: 1.0,
          leftZ: 0.0,
          rightZ: 1.0,
          maxHeight: 10.0,
          minHeight: 0.0,
          minVerticalSeparation: 0.5,
          containerId: 1,
        ),
        StandardSlot(
          bay: 3,
          row: 2,
          tier: 4,
          leftX: 2.0,
          rightX: 3.0,
          leftY: 1.0,
          rightY: 2.0,
          leftZ: 1.5,
          rightZ: 2.5,
          maxHeight: 10.0,
          minHeight: 0.0,
          minVerticalSeparation: 0.5,
          containerId: null,
        ),
        StandardSlot(
          bay: 3,
          row: 3,
          tier: 2,
          leftX: 2.0,
          rightX: 3.0,
          leftY: 2.0,
          rightY: 3.0,
          leftZ: 0.0,
          rightZ: 1.0,
          maxHeight: 2.0,
          minHeight: 0.0,
          minVerticalSeparation: 0.5,
          containerId: null,
        ),
        StandardSlot(
          bay: 3,
          row: 3,
          tier: 4,
          leftX: 2.0,
          rightX: 3.0,
          leftY: 2.0,
          rightY: 3.0,
          leftZ: 1.5,
          rightZ: 2.5,
          maxHeight: 2.0,
          minHeight: 0.0,
          minVerticalSeparation: 0.5,
          containerId: 1,
        ),
      ]);
    });
    //
    test('adds new slot with container to collection', () {
      const container = FakeContainer(id: 10);
      const operation = PutContainerOperation(
        bay: 1,
        row: 1,
        tier: 2,
        container: container,
      );
      final result = operation.execute(collection);
      expect(
        result,
        isA<Ok>(),
        reason: 'operation.execute should return Ok',
      );
      final slot = collection.findSlot(1, 1, 2);
      expect(
        slot,
        isNotNull,
        reason: 'slot should not be null after adding container to collection',
      );
      expect(
        slot!.containerId,
        container.id,
        reason: 'slot.containerId should be equal to container.id',
      );
    });
    //
    test('updates slot z coordinates when container is put', () {
      const containerHeight = 2.5; // in m
      const container = FakeContainer(
        id: 1,
        height: containerHeight,
      );
      const operation = PutContainerOperation(
        bay: 1,
        row: 1,
        tier: 2,
        container: container,
      );
      final result = operation.execute(collection);
      expect(
        result,
        isA<Ok>(),
        reason: 'operation.execute should return Ok',
      );
      final slot = collection.findSlot(1, 1, 2);
      expect(
        slot!.leftZ,
        0.0,
        reason: 'slot.leftZ should be equal to 0.0',
      );
      expect(
        slot.rightZ,
        containerHeight,
        reason: 'slot.rightZ should be equal to container.height',
      );
    });
    //
    test('update slot above with correct z coordinates', () {
      const containerHeight = 5.0; // in m
      final slotAbove = collection.findSlot(1, 1, 4);
      final slotAboveHeight = slotAbove!.rightZ - slotAbove.leftZ;
      const container = FakeContainer(id: 1, height: containerHeight);
      const operation = PutContainerOperation(
        bay: 1,
        row: 1,
        tier: 2,
        container: container,
      );
      final result = operation.execute(collection);
      expect(
        result,
        isA<Ok>(),
        reason: 'operation.execute should return Ok',
      );
      final newSlot = collection.findSlot(1, 1, 2);
      final newSlotAbove = collection.findSlot(1, 1, 4);
      expect(
        newSlotAbove!.leftZ,
        newSlot!.rightZ + newSlot.minVerticalSeparation,
        reason:
            'slotAbove.leftZ should be equal to slotBelow.rightZ + slotBelow.minVerticalSeparation',
      );
      expect(
        newSlotAbove.rightZ,
        newSlotAbove.leftZ + slotAboveHeight,
        reason:
            'slotAbove.leftZ should be equal to slotBelow.rightZ + slotBelow.minVerticalSeparation',
      );
    });
    //
    test('update all slots above with correct z coordinates', () {
      const containerHeight = 4.0; // in m
      final slotsAbove = collection.toFilteredSlotList(
        bay: 1,
        row: 1,
        shouldIncludeSlot: (s) => s.tier > 2,
      );
      final slotsAboveHeight =
          slotsAbove.map((s) => s.rightZ - s.leftZ).toList();
      const container = FakeContainer(id: 1, height: containerHeight);
      const operation = PutContainerOperation(
        bay: 1,
        row: 1,
        tier: 2,
        container: container,
      );
      final result = operation.execute(collection);
      expect(
        result,
        isA<Ok>(),
        reason: 'operation.execute should return Ok',
      );
      for (int i = 0; i < slotsAbove.length; i++) {
        final slotAbove = slotsAbove[i];
        final slotAboveHeight = slotsAboveHeight[i];
        final newSlot = collection.findSlot(1, 1, slotAbove.tier - 2);
        final newSlotAbove = collection.findSlot(1, 1, slotAbove.tier);
        expect(
          newSlotAbove!.leftZ,
          newSlot!.rightZ + newSlot.minVerticalSeparation,
          reason:
              'slotAbove.leftZ should be equal to slotBelow.rightZ + slotBelow.minVerticalSeparation',
        );
        expect(
          newSlotAbove.rightZ,
          newSlotAbove.leftZ + slotAboveHeight,
          reason:
              'slotAbove.leftZ should be equal to slotBelow.rightZ + slotBelow.minVerticalSeparation',
        );
      }
    });
    //
    test(
      'updates paired slot (bay - 1) z coordinates when container is put in odd bay',
      () {
        const containerHeight = 2.5; // in m
        const container = FakeContainer(id: 1, height: containerHeight);
        const operation = PutContainerOperation(
          bay: 3,
          row: 1,
          tier: 2,
          container: container,
        );
        final result = operation.execute(collection);
        expect(
          result,
          isA<Ok>(),
          reason: 'operation.execute should return Ok',
        );
        final pairedSlot = collection.findSlot(2, 1, 2);
        expect(
          pairedSlot!.leftZ,
          0.0,
          reason: 'pairedSlot.leftZ should be equal to 0.0',
        );
        expect(
          pairedSlot.rightZ,
          containerHeight,
          reason: 'pairedSlot.rightZ should be equal to container.height',
        );
      },
    );
    //
    test(
      'update slot above for paired slot (bay - 1) with correct z coordinates for odd bay',
      () {
        const containerHeight = 5.0; // in m
        final slotAbovePaired = collection.findSlot(2, 1, 4);
        final slotAboveHeight = slotAbovePaired!.rightZ - slotAbovePaired.leftZ;
        const container = FakeContainer(id: 1, height: containerHeight);
        const operation = PutContainerOperation(
          bay: 3,
          row: 1,
          tier: 2,
          container: container,
        );
        final result = operation.execute(collection);
        expect(
          result,
          isA<Ok>(),
          reason: 'operation.execute should return Ok',
        );
        final newSlot = collection.findSlot(2, 1, 2);
        final newSlotAbove = collection.findSlot(2, 1, 4);
        expect(
          newSlotAbove!.leftZ,
          newSlot!.rightZ + newSlot.minVerticalSeparation,
          reason:
              'slotAbove.leftZ should be equal to slotBelow.rightZ + slotBelow.minVerticalSeparation',
        );
        expect(
          newSlotAbove.rightZ,
          newSlotAbove.leftZ + slotAboveHeight,
          reason:
              'slotAbove.leftZ should be equal to slotBelow.rightZ + slotBelow.minVerticalSeparation',
        );
      },
    );
    //
    test(
      'updates paired slot (bay + 1) z coordinates when container is put in even bay',
      () {
        const containerHeight = 2.5; // in m
        const container = FakeContainer(id: 1, height: containerHeight);
        const operation = PutContainerOperation(
          bay: 2,
          row: 1,
          tier: 2,
          container: container,
        );
        final result = operation.execute(collection);
        expect(
          result,
          isA<Ok>(),
          reason: 'operation.execute should return Ok',
        );
        final pairedSlot = collection.findSlot(3, 1, 2);
        expect(
          pairedSlot!.leftZ,
          0.0,
          reason: 'pairedSlot.leftZ should be equal to 0.0',
        );
        expect(
          pairedSlot.rightZ,
          containerHeight,
          reason: 'pairedSlot.rightZ should be equal to container.height',
        );
      },
    );
    //
    test(
      'update slot above for paired slot (bay + 1) with correct z coordinates for even bay',
      () {
        const containerHeight = 5.0; // in m
        final slotAbovePaired = collection.findSlot(3, 1, 4);
        final slotAboveHeight = slotAbovePaired!.rightZ - slotAbovePaired.leftZ;
        const container = FakeContainer(id: 1, height: containerHeight);
        const operation = PutContainerOperation(
          bay: 2,
          row: 1,
          tier: 2,
          container: container,
        );
        final result = operation.execute(collection);
        expect(
          result,
          isA<Ok>(),
          reason: 'operation.execute should return Ok',
        );
        final newSlot = collection.findSlot(3, 1, 2);
        final newSlotAbove = collection.findSlot(3, 1, 4);
        expect(
          newSlotAbove!.leftZ,
          newSlot!.rightZ + newSlot.minVerticalSeparation,
          reason:
              'slotAbove.leftZ should be equal to slotBelow.rightZ + slotBelow.minVerticalSeparation',
        );
        expect(
          newSlotAbove.rightZ,
          newSlotAbove.leftZ + slotAboveHeight,
          reason:
              'slotAbove.leftZ should be equal to slotBelow.rightZ + slotBelow.minVerticalSeparation',
        );
      },
    );
    //
    test(
      'update all slots above paired (bay - 1) with correct z coordinates for odd bay',
      () {
        const containerHeight = 4.0; // in m
        final slotsAbove = collection.toFilteredSlotList(
          bay: 2,
          row: 1,
          shouldIncludeSlot: (s) => s.tier > 2,
        );
        final slotsAboveHeight =
            slotsAbove.map((s) => s.rightZ - s.leftZ).toList();
        const container = FakeContainer(id: 1, height: containerHeight);
        const operation = PutContainerOperation(
          bay: 3,
          row: 1,
          tier: 2,
          container: container,
        );
        final result = operation.execute(collection);
        expect(
          result,
          isA<Ok>(),
          reason: 'operation.execute should return Ok',
        );
        for (int i = 0; i < slotsAbove.length; i++) {
          final slotAbove = slotsAbove[i];
          final slotAboveHeight = slotsAboveHeight[i];
          final newSlot = collection.findSlot(1, 1, slotAbove.tier - 2);
          final newSlotAbove = collection.findSlot(1, 1, slotAbove.tier);
          expect(
            newSlotAbove!.leftZ,
            newSlot!.rightZ + newSlot.minVerticalSeparation,
            reason:
                'slotAbove.leftZ should be equal to slotBelow.rightZ + slotBelow.minVerticalSeparation',
          );
          expect(
            newSlotAbove.rightZ,
            newSlotAbove.leftZ + slotAboveHeight,
            reason:
                'slotAbove.leftZ should be equal to slotBelow.rightZ + slotBelow.minVerticalSeparation',
          );
        }
      },
    );
    //
    test(
      'update all slots above paired (bay + 1) with correct z coordinates for even bay',
      () {
        const containerHeight = 4.0; // in m
        final slotsAbove = collection.toFilteredSlotList(
          bay: 3,
          row: 1,
          shouldIncludeSlot: (s) => s.tier > 2,
        );
        final slotsAboveHeight =
            slotsAbove.map((s) => s.rightZ - s.leftZ).toList();
        const container = FakeContainer(id: 1, height: containerHeight);
        const operation = PutContainerOperation(
          bay: 2,
          row: 1,
          tier: 2,
          container: container,
        );
        final result = operation.execute(collection);
        expect(
          result,
          isA<Ok>(),
          reason: 'operation.execute should return Ok',
        );
        for (int i = 0; i < slotsAbove.length; i++) {
          final slotAbove = slotsAbove[i];
          final slotAboveHeight = slotsAboveHeight[i];
          final newSlot = collection.findSlot(1, 1, slotAbove.tier - 2);
          final newSlotAbove = collection.findSlot(1, 1, slotAbove.tier);
          expect(
            newSlotAbove!.leftZ,
            newSlot!.rightZ + newSlot.minVerticalSeparation,
            reason:
                'slotAbove.leftZ should be equal to slotBelow.rightZ + slotBelow.minVerticalSeparation',
          );
          expect(
            newSlotAbove.rightZ,
            newSlotAbove.leftZ + slotAboveHeight,
            reason:
                'slotAbove.leftZ should be equal to slotBelow.rightZ + slotBelow.minVerticalSeparation',
          );
        }
      },
    );
  });
}
