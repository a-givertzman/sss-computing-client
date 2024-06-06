import 'package:sss_computing_client/core/models/frame/frame.dart';
import 'package:sss_computing_client/core/models/limit_type.dart';
import 'package:sss_computing_client/core/models/strength/strength_force_limit.dart';
import 'package:flutter_test/flutter_test.dart';
///
final class FakeFrame implements Frame {
  final int? _projectId;
  final int _shipId;
  final int _index;
  final double _x;
  ///
  const FakeFrame({
    int? projectId,
    int shipId = 0,
    int index = 0,
    required double x,
  })  : _projectId = projectId,
        _shipId = shipId,
        _index = index,
        _x = x;
  @override
  int? get projectId => _projectId;
  @override
  int get shipId => _shipId;
  @override
  int get index => _index;
  @override
  double get x => _x;
}
///
final class FakeStrengthForceLimit implements StrengthForceLimit {
  final int? _projectId;
  final int _shipId;
  final Frame _frame;
  final LimitType _type;
  final double _value;
  ///
  const FakeStrengthForceLimit({
    int? projectId,
    int shipId = 0,
    required Frame frame,
    required LimitType type,
    required double value,
  })  : _projectId = projectId,
        _shipId = shipId,
        _frame = frame,
        _type = type,
        _value = value;
  @override
  int? get projectId => _projectId;
  @override
  int get shipId => _shipId;
  @override
  Frame get frame => _frame;
  @override
  LimitType get type => _type;
  @override
  double? get value => _value;
}
///
void main() {
  group(
    "[LerpStrengthForceLimit] interpolation",
    () {
      //
      test("if limit values doesn't exist on both sides", () {
        final testCases = [
          ([], 0.0, null),
          ([], 10.0, null),
          ([], -10.0, null),
        ];
        for (final testCase in testCases) {
          final (limitsValueOffset, frameOffset, output) = testCase;
          final frame = FakeFrame(x: frameOffset);
          final limits = limitsValueOffset
              .map((el) => FakeStrengthForceLimit(
                    frame: FakeFrame(x: el.$1),
                    type: LimitType.low,
                    value: el.$2,
                  ))
              .toList();
          expect(
            LerpStrengthForceLimit(
              frame: frame,
              limits: limits,
              limitType: LimitType.low,
            ).value,
            output,
            reason: "limit with null value must be returned",
          );
        }
      });
      //
      test("if limit values exists only on one sides", () {
        final testCases = [
          ([(0.0, 0.0)], 10.0, null),
          ([(0.0, 0.0)], -10.0, null),
          ([(20.0, 0.0)], 10.0, null),
          ([(-20.0, 0.0)], -10.0, null),
        ];
        for (final testCase in testCases) {
          final (limitsValueOffset, frameOffset, output) = testCase;
          final frame = FakeFrame(x: frameOffset);
          final limits = limitsValueOffset
              .map((el) => FakeStrengthForceLimit(
                    frame: FakeFrame(x: el.$1),
                    type: LimitType.low,
                    value: el.$2,
                  ))
              .toList();
          expect(
            LerpStrengthForceLimit(
              frame: frame,
              limits: limits,
              limitType: LimitType.low,
            ).value,
            output,
            reason: "limit with null value must be returned",
          );
        }
      });
      //
      test("if limit values exists on both sides", () {
        final testCases = [
          ([(0.0, -10.0), (0.0, 10.0)], 0.0, 0.0),
          ([(0.0, 0.0), (10.0, 10.0)], 0.0, 0.0),
          ([(0.0, 0.0), (10.0, 10.0)], 5.0, 5.0),
          ([(0.0, 0.0), (10.0, 10.0)], 10.0, 10.0),
          ([(0.0, 0.0), (-10.0, -10.0)], 0.0, 0.0),
          ([(0.0, 0.0), (-10.0, -10.0)], -5.0, -5.0),
          ([(0.0, 0.0), (-10.0, -10.0)], -10.0, -10.0),
          ([(-20.0, -10.0), (20.0, 10.0)], 0.0, 0.0),
          ([(-20.0, -10.0), (0.0, 10.0)], 0.0, -10.0),
          ([(10.0, -10.0), (10.0, 10.0)], 0.0, 10.0),
          ([(-20.0, -20.0), (0.0, -10.0), (0.0, 10.0), (20.0, 20.0)], 0.0, 0.0),
        ];
        for (final testCase in testCases) {
          final (limitsValueOffset, frameOffset, output) = testCase;
          final frame = FakeFrame(x: frameOffset);
          final limits = limitsValueOffset
              .map((el) => FakeStrengthForceLimit(
                    frame: FakeFrame(x: el.$2),
                    type: LimitType.low,
                    value: el.$1,
                  ))
              .toList();
          expect(
            LerpStrengthForceLimit(
              frame: frame,
              limits: limits,
              limitType: LimitType.low,
            ).value,
            output,
            reason: "limit with correctly iterpolated value must be returned",
          );
        }
      });
      //
      test("if limits on right and left matched", () {
        final testCases = [
          ([(0.0, 0.0)], 0.0, 0.0),
          ([(10.0, 0.0)], 0.0, 10.0),
          ([(-10.0, 0.0)], 0.0, -10.0),
          ([(10.0, 10.0)], 10.0, 10.0),
          ([(-10.0, -10.0)], -10.0, -10.0),
          ([(0.0, 0.0), (0.0, 0.0)], 0.0, 0.0),
        ];
        for (final testCase in testCases) {
          final (limitsValueOffset, frameOffset, output) = testCase;
          final frame = FakeFrame(x: frameOffset);
          final limits = limitsValueOffset
              .map((el) => FakeStrengthForceLimit(
                    frame: FakeFrame(x: el.$2),
                    type: LimitType.low,
                    value: el.$1,
                  ))
              .toList();
          expect(
            LerpStrengthForceLimit(
              frame: frame,
              limits: limits,
              limitType: LimitType.low,
            ).value,
            output,
            reason: "limit with correctly iterpolated value must be returned",
          );
        }
      });
    },
  );
}
