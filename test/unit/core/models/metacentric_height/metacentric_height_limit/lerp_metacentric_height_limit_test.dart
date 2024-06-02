import 'package:sss_computing_client/core/models/metacentric_height/lerp_metacentric_height_limit.dart';
import 'package:sss_computing_client/core/models/metacentric_height/metacentric_height_limit.dart';
import 'package:flutter_test/flutter_test.dart';
///
final class FakeMetacentricHeightLimit implements MetacentricHeightLimit {
  @override
  final double displacement;
  @override
  final double low;
  @override
  final double high;
  ///
  const FakeMetacentricHeightLimit({
    required this.displacement,
    required this.low,
    required this.high,
  });
  @override
  int? get projectId => 0;
  @override
  int get shipId => 0;
}
///
void main() {
  group("[LerpStrengthForceLimit] interpolation", () {
    test("test interpolated limits on borders", () {
      final testCases = [
        {
          'inputDisplacement': 0.0,
          'inputLimits': const [
            FakeMetacentricHeightLimit(displacement: 0.0, low: 0.0, high: 0.0),
          ],
          'output': const FakeMetacentricHeightLimit(
            displacement: 0.0,
            low: 0.0,
            high: 0.0,
          ),
        },
        {
          'inputDisplacement': 0.0,
          'inputLimits': const [
            FakeMetacentricHeightLimit(displacement: 0.0, low: 0.0, high: 0.0),
          ],
          'output': const FakeMetacentricHeightLimit(
            displacement: 10.0,
            low: 0.0,
            high: 0.0,
          ),
        },
        {
          'inputDisplacement': 0.0,
          'inputLimits': const [
            FakeMetacentricHeightLimit(displacement: 0.0, low: 0.0, high: 0.0),
          ],
          'output': const FakeMetacentricHeightLimit(
            displacement: -10.0,
            low: 0.0,
            high: 0.0,
          ),
        },
        {
          'inputDisplacement': -10.0,
          'inputLimits': const [
            FakeMetacentricHeightLimit(
              displacement: -10.0,
              low: -10.0,
              high: 10.0,
            ),
            FakeMetacentricHeightLimit(displacement: 0.0, low: 0.0, high: 0.0),
            FakeMetacentricHeightLimit(
              displacement: 10.0,
              low: -20.0,
              high: 20.0,
            ),
          ],
          'output': const FakeMetacentricHeightLimit(
            displacement: -20.0,
            low: -10.0,
            high: 10.0,
          ),
        },
        {
          'inputDisplacement': 10.0,
          'inputLimits': const [
            FakeMetacentricHeightLimit(
              displacement: -10.0,
              low: -10.0,
              high: 10.0,
            ),
            FakeMetacentricHeightLimit(displacement: 0.0, low: 0.0, high: 0.0),
            FakeMetacentricHeightLimit(
              displacement: 10.0,
              low: -20.0,
              high: 20.0,
            ),
          ],
          'output': const FakeMetacentricHeightLimit(
            displacement: 20.0,
            low: -20.0,
            high: 20.0,
          ),
        },
        {
          'inputDisplacement': -20.0,
          'inputLimits': const [
            FakeMetacentricHeightLimit(
              displacement: -10.0,
              low: -10.0,
              high: 10.0,
            ),
            FakeMetacentricHeightLimit(displacement: 0.0, low: 0.0, high: 0.0),
            FakeMetacentricHeightLimit(
              displacement: 10.0,
              low: -20.0,
              high: 20.0,
            ),
          ],
          'output': const FakeMetacentricHeightLimit(
            displacement: -20.0,
            low: -10.0,
            high: 10.0,
          ),
        },
        {
          'inputDisplacement': 20.0,
          'inputLimits': const [
            FakeMetacentricHeightLimit(
              displacement: -10.0,
              low: -10.0,
              high: 10.0,
            ),
            FakeMetacentricHeightLimit(displacement: 0.0, low: 0.0, high: 0.0),
            FakeMetacentricHeightLimit(
              displacement: 10.0,
              low: -20.0,
              high: 20.0,
            ),
          ],
          'output': const FakeMetacentricHeightLimit(
            displacement: 20.0,
            low: -20.0,
            high: 20.0,
          ),
        },
      ];
      for (final testCase in testCases) {
        final limits = testCase['inputLimits'] as List<MetacentricHeightLimit>;
        final displacement = testCase['inputDisplacement'] as double;
        final output = testCase['output'] as MetacentricHeightLimit;
        expect(
          LerpMetacentricHeightLimit(
            shipId: limits.first.shipId,
            displacement: displacement,
            limits: limits,
          ).low,
          output.low,
          reason:
              "limit with correct value on border must be returned for low limit",
        );
        expect(
          LerpMetacentricHeightLimit(
            shipId: limits.first.shipId,
            displacement: displacement,
            limits: limits,
          ).high,
          output.high,
          reason:
              "limit with correct value on border must be returned for high limit",
        );
      }
    });
    test("test interpolated limits in intervals", () {
      final testCases = [
        {
          'inputDisplacement': 0.0,
          'inputLimits': const [
            FakeMetacentricHeightLimit(
              displacement: -10.0,
              low: -10.0,
              high: 10.0,
            ),
            FakeMetacentricHeightLimit(displacement: 0.0, low: 0.0, high: 0.0),
            FakeMetacentricHeightLimit(
              displacement: 10.0,
              low: -20.0,
              high: 20.0,
            ),
          ],
          'output': const FakeMetacentricHeightLimit(
            displacement: 0.0,
            low: 0.0,
            high: 0.0,
          ),
        },
        {
          'inputDisplacement': 0.0,
          'inputLimits': const [
            FakeMetacentricHeightLimit(
              displacement: -10.0,
              low: -10.0,
              high: 10.0,
            ),
            FakeMetacentricHeightLimit(displacement: 0.0, low: 0.5, high: -0.5),
            FakeMetacentricHeightLimit(
              displacement: 10.0,
              low: -20.0,
              high: 20.0,
            ),
          ],
          'output': const FakeMetacentricHeightLimit(
            displacement: 0.0,
            low: 0.5,
            high: -0.5,
          ),
        },
        {
          'inputDisplacement': 0.0,
          'inputLimits': const [
            FakeMetacentricHeightLimit(
              displacement: -10.0,
              low: -10.0,
              high: 10.0,
            ),
            FakeMetacentricHeightLimit(
              displacement: 10.0,
              low: -20.0,
              high: 20.0,
            ),
          ],
          'output': const FakeMetacentricHeightLimit(
            displacement: 0.0,
            low: -15.0,
            high: 15.0,
          ),
        },
        {
          'inputDisplacement': 0.0,
          'inputLimits': const [
            FakeMetacentricHeightLimit(
              displacement: 10.0,
              low: -20.0,
              high: 20.0,
            ),
            FakeMetacentricHeightLimit(
              displacement: -10.0,
              low: -10.0,
              high: 10.0,
            ),
          ],
          'output': const FakeMetacentricHeightLimit(
            displacement: 0.0,
            low: -15.0,
            high: 15.0,
          ),
        },
        {
          'inputDisplacement': 0.0,
          'inputLimits': const [
            FakeMetacentricHeightLimit(
              displacement: -20.0,
              low: -20.0,
              high: 20.0,
            ),
            FakeMetacentricHeightLimit(
              displacement: 20.0,
              low: -20.0,
              high: 20.0,
            ),
          ],
          'output': const FakeMetacentricHeightLimit(
            displacement: 0.0,
            low: -20.0,
            high: 20.0,
          ),
        },
        {
          'inputDisplacement': 0.0,
          'inputLimits': const [
            FakeMetacentricHeightLimit(
              displacement: -20.0,
              low: -20.0,
              high: -20.0,
            ),
            FakeMetacentricHeightLimit(
              displacement: 20.0,
              low: 20.0,
              high: 20.0,
            ),
          ],
          'output': const FakeMetacentricHeightLimit(
            displacement: 0.0,
            low: 0.0,
            high: 0.0,
          ),
        },
        {
          'inputDisplacement': -10.0,
          'inputLimits': const [
            FakeMetacentricHeightLimit(
              displacement: -20.0,
              low: -20.0,
              high: -20.0,
            ),
            FakeMetacentricHeightLimit(
              displacement: 20.0,
              low: 20.0,
              high: 20.0,
            ),
          ],
          'output': const FakeMetacentricHeightLimit(
            displacement: -10.0,
            low: -10.0,
            high: -10.0,
          ),
        },
        {
          'inputDisplacement': 10.0,
          'inputLimits': const [
            FakeMetacentricHeightLimit(
              displacement: -20.0,
              low: -20.0,
              high: -20.0,
            ),
            FakeMetacentricHeightLimit(
              displacement: 20.0,
              low: 20.0,
              high: 20.0,
            ),
          ],
          'output': const FakeMetacentricHeightLimit(
            displacement: 10.0,
            low: 10.0,
            high: 10.0,
          ),
        },
      ];
      for (final testCase in testCases) {
        final limits = testCase['inputLimits'] as List<MetacentricHeightLimit>;
        final displacement = testCase['inputDisplacement'] as double;
        final output = testCase['output'] as MetacentricHeightLimit;
        expect(
          LerpMetacentricHeightLimit(
            shipId: limits.first.shipId,
            displacement: displacement,
            limits: limits,
          ).low,
          output.low,
          reason:
              "limit with correct value inside interval must be returned for low limit",
        );
        expect(
          LerpMetacentricHeightLimit(
            shipId: limits.first.shipId,
            displacement: displacement,
            limits: limits,
          ).high,
          output.high,
          reason:
              "limit with correct value inside interval must be returned for high limit",
        );
      }
    });
  });
}
