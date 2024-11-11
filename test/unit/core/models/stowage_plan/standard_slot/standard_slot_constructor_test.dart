//
import 'package:flutter_test/flutter_test.dart';
import 'package:sss_computing_client/core/models/stowage_plan/slot/standard_slot.dart';
void main() {
  //
  group('StandardSlot constructor', () {
    //
    test('creates a StandardSlot object with valid parameters', () {
      const slot = StandardSlot(
        bay: 1,
        row: 2,
        tier: 4,
        leftX: 10.0,
        rightX: 16.0,
        leftY: 2.0,
        rightY: 6.0,
        leftZ: 1.0,
        rightZ: 3.59,
        maxHeight: 10.0,
        minHeight: 0.0,
        minVerticalSeparation: 0.5,
        containerId: 123,
      );
      expect(slot.bay, 1, reason: 'bay should be equal to 1');
      expect(slot.row, 2, reason: 'row should be equal to 2');
      expect(slot.tier, 4, reason: 'tier should be equal to 4');
      expect(slot.leftX, 10.0, reason: 'leftX should be equal to 10.0');
      expect(slot.rightX, 16.0, reason: 'rightX should be equal to 16.0');
      expect(slot.leftY, 2.0, reason: 'leftY should be equal to 2.0');
      expect(slot.rightY, 6.0, reason: 'rightY should be equal to 6.0');
      expect(slot.leftZ, 1.0, reason: 'leftZ should be equal to 1.0');
      expect(slot.rightZ, 3.59, reason: 'rightZ should be equal to 3.59');
      expect(slot.maxHeight, 10.0, reason: 'maxHeight should be equal to 10.0');
      expect(slot.minHeight, 0.0, reason: 'minHeight should be equal to 10.0');
      expect(
        slot.minVerticalSeparation,
        0.5,
        reason: 'minVerticalSeparation should be equal to 0.5',
      );
      expect(
        slot.containerId,
        123,
        reason: 'containerId should be equal to 123',
      );
    });
    //
    test('creates a StandardSlot object with null containerId', () {
      const slot = StandardSlot(
        bay: 1,
        row: 2,
        tier: 4,
        leftX: 10.0,
        rightX: 16.0,
        leftY: 2.0,
        rightY: 6.0,
        leftZ: 1.0,
        rightZ: 3.59,
        maxHeight: 10.0,
        minHeight: 0.0,
        minVerticalSeparation: 0.5,
      );
      expect(slot.containerId, isNull, reason: 'containerId should be null');
    });
  });
}
