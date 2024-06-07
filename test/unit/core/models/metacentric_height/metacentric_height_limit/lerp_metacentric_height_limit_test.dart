import 'package:sss_computing_client/core/models/metacentric_height/lerp_metacentric_height_limit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sss_computing_client/core/models/metacentric_height/metacentric_height_limit.dart';
///
final class FakeMetacentricHeightLimit implements MetacentricHeightLimit {
  @override
  final double dependentValue;
  @override
  final double value;
  ///
  const FakeMetacentricHeightLimit({
    required this.dependentValue,
    required this.value,
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
            FakeMetacentricHeightLimit(
              dependentValue: 0.0,
              value: 0.0,
            ),
          ],
          'output': const FakeMetacentricHeightLimit(
            dependentValue: 0.0,
            value: 0.0,
          ),
        },
        {
          'inputDisplacement': 0.0,
          'inputLimits': const [
            FakeMetacentricHeightLimit(
              dependentValue: 0.0,
              value: 0.0,
            ),
          ],
          'output': const FakeMetacentricHeightLimit(
            dependentValue: 10.0,
            value: 0.0,
          ),
        },
        {
          'inputDisplacement': 0.0,
          'inputLimits': const [
            FakeMetacentricHeightLimit(
              dependentValue: 0.0,
              value: 0.0,
            ),
          ],
          'output': const FakeMetacentricHeightLimit(
            dependentValue: -10.0,
            value: 0.0,
          ),
        },
        {
          'inputDisplacement': -10.0,
          'inputLimits': const [
            FakeMetacentricHeightLimit(
              dependentValue: -10.0,
              value: -10.0,
            ),
            FakeMetacentricHeightLimit(
              dependentValue: 0.0,
              value: 0.0,
            ),
            FakeMetacentricHeightLimit(
              dependentValue: 10.0,
              value: -20.0,
            ),
          ],
          'output': const FakeMetacentricHeightLimit(
            dependentValue: -20.0,
            value: -10.0,
          ),
        },
        {
          'inputDisplacement': 10.0,
          'inputLimits': const [
            FakeMetacentricHeightLimit(
              dependentValue: -10.0,
              value: -10.0,
            ),
            FakeMetacentricHeightLimit(
              dependentValue: 0.0,
              value: 0.0,
            ),
            FakeMetacentricHeightLimit(
              dependentValue: 10.0,
              value: -20.0,
            ),
          ],
          'output': const FakeMetacentricHeightLimit(
            dependentValue: 20.0,
            value: -20.0,
          ),
        },
        {
          'inputDisplacement': -20.0,
          'inputLimits': const [
            FakeMetacentricHeightLimit(
              dependentValue: -10.0,
              value: -10.0,
            ),
            FakeMetacentricHeightLimit(
              dependentValue: 0.0,
              value: 0.0,
            ),
            FakeMetacentricHeightLimit(
              dependentValue: 10.0,
              value: -20.0,
            ),
          ],
          'output': const FakeMetacentricHeightLimit(
            dependentValue: -20.0,
            value: -10.0,
          ),
        },
        {
          'inputDisplacement': 20.0,
          'inputLimits': const [
            FakeMetacentricHeightLimit(
              dependentValue: -10.0,
              value: -10.0,
            ),
            FakeMetacentricHeightLimit(
              dependentValue: 0.0,
              value: 0.0,
            ),
            FakeMetacentricHeightLimit(
              dependentValue: 10.0,
              value: -20.0,
            ),
          ],
          'output': const FakeMetacentricHeightLimit(
            dependentValue: 20.0,
            value: -20.0,
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
          ).value,
          output.value,
          reason:
              "limit with correct value on border must be returned for limit",
        );
      }
    });
    test("test interpolated limits in intervals", () {
      final testCases = [
        {
          'inputDisplacement': 0.0,
          'inputLimits': const [
            FakeMetacentricHeightLimit(
              dependentValue: -10.0,
              value: -10.0,
            ),
            FakeMetacentricHeightLimit(
              dependentValue: 0.0,
              value: 0.0,
            ),
            FakeMetacentricHeightLimit(
              dependentValue: 10.0,
              value: -20.0,
            ),
          ],
          'output': const FakeMetacentricHeightLimit(
            dependentValue: 0.0,
            value: 0.0,
          ),
        },
        {
          'inputDisplacement': 0.0,
          'inputLimits': const [
            FakeMetacentricHeightLimit(
              dependentValue: -10.0,
              value: -10.0,
            ),
            FakeMetacentricHeightLimit(
              dependentValue: 0.0,
              value: 0.5,
            ),
            FakeMetacentricHeightLimit(
              dependentValue: 10.0,
              value: -20.0,
            ),
          ],
          'output': const FakeMetacentricHeightLimit(
            dependentValue: 0.0,
            value: 0.5,
          ),
        },
        {
          'inputDisplacement': 0.0,
          'inputLimits': const [
            FakeMetacentricHeightLimit(
              dependentValue: -10.0,
              value: -10.0,
            ),
            FakeMetacentricHeightLimit(
              dependentValue: 10.0,
              value: -20.0,
            ),
          ],
          'output': const FakeMetacentricHeightLimit(
            dependentValue: 0.0,
            value: -15.0,
          ),
        },
        {
          'inputDisplacement': 0.0,
          'inputLimits': const [
            FakeMetacentricHeightLimit(
              dependentValue: 10.0,
              value: -20.0,
            ),
            FakeMetacentricHeightLimit(
              dependentValue: -10.0,
              value: -10.0,
            ),
          ],
          'output': const FakeMetacentricHeightLimit(
            dependentValue: 0.0,
            value: -15.0,
          ),
        },
        {
          'inputDisplacement': 0.0,
          'inputLimits': const [
            FakeMetacentricHeightLimit(
              dependentValue: -20.0,
              value: -20.0,
            ),
            FakeMetacentricHeightLimit(
              dependentValue: 20.0,
              value: -20.0,
            ),
          ],
          'output': const FakeMetacentricHeightLimit(
            dependentValue: 0.0,
            value: -20.0,
          ),
        },
        {
          'inputDisplacement': 0.0,
          'inputLimits': const [
            FakeMetacentricHeightLimit(
              dependentValue: -20.0,
              value: -20.0,
            ),
            FakeMetacentricHeightLimit(
              dependentValue: 20.0,
              value: 20.0,
            ),
          ],
          'output': const FakeMetacentricHeightLimit(
            dependentValue: 0.0,
            value: 0.0,
          ),
        },
        {
          'inputDisplacement': -10.0,
          'inputLimits': const [
            FakeMetacentricHeightLimit(
              dependentValue: -20.0,
              value: -20.0,
            ),
            FakeMetacentricHeightLimit(
              dependentValue: 20.0,
              value: 20.0,
            ),
          ],
          'output': const FakeMetacentricHeightLimit(
            dependentValue: -10.0,
            value: -10.0,
          ),
        },
        {
          'inputDisplacement': 10.0,
          'inputLimits': const [
            FakeMetacentricHeightLimit(
              dependentValue: -20.0,
              value: -20.0,
            ),
            FakeMetacentricHeightLimit(
              dependentValue: 20.0,
              value: 20.0,
            ),
          ],
          'output': const FakeMetacentricHeightLimit(
            dependentValue: 10.0,
            value: 10.0,
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
          ).value,
          output.value,
          reason:
              "limit with correct value inside interval must be returned for low limit",
        );
      }
    });
  });
}
