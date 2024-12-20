import 'package:flutter_test/flutter_test.dart';
import 'package:hmi_core/hmi_core.dart';
import 'package:sss_computing_client/core/models/number_math_relation/equal_to.dart';
import 'package:sss_computing_client/core/models/number_math_relation/greater_than.dart';
import 'package:sss_computing_client/core/models/number_math_relation/greater_than_or_equal_to.dart';
import 'package:sss_computing_client/core/models/number_math_relation/less_than.dart';
import 'package:sss_computing_client/core/models/number_math_relation/less_than_or_equal_to.dart';
import 'package:sss_computing_client/core/models/number_math_relation/not_equal_to.dart';
import 'package:sss_computing_client/core/models/number_math_relation/unimplemented_math_relation.dart';
///
void main() {
  //
  group('[NumberMathRelation] process(), [LessThan] | ', () {
    final okTrueValues = [
      (0.0, 0.25),
      (0, 25),
    ];
    final okFalseValues = [
      (0.25, 0.0),
      (25, 0),
      (0.0, 0.0),
      (0, 0),
      (double.nan, 0),
      (0, double.nan),
      (double.nan, 0.0),
      (0.0, double.nan),
      (double.nan, double.nan),
    ];
    for (final values in okTrueValues) {
      final (firstValue, secondValue) = values;
      //
      test(
        'return correct type and value',
        () {
          const relation = LessThan();
          final result = relation.process(firstValue, secondValue);
          expect(
            result,
            isA<Ok>(),
            reason:
                'Type returned from process() must be [Ok] if [num] values of the same type provided',
          );
          expect(
            result.value,
            true,
            reason:
                'Type returned from process() must be [Ok] with true value for "$firstValue" and "$secondValue" provided',
          );
        },
      );
    }
    for (final values in okFalseValues) {
      final (firstValue, secondValue) = values;
      test(
        'return correct type and value',
        () {
          const relation = LessThan();
          final result = relation.process(firstValue, secondValue);
          expect(
            result,
            isA<Ok>(),
            reason:
                'Type returned from process() must be [Ok] if [num] values of the same type provided',
          );
          expect(
            result.value,
            false,
            reason:
                'Type returned from process() must be [Ok] with false value for "$firstValue" and "$secondValue" provided',
          );
        },
      );
    }
  });
  //
  group('[NumberMathRelation] process(), [GreaterThan] | ', () {
    final okTrueValues = [
      (0.25, 0.0),
      (25, 0),
    ];
    final okFalseValues = [
      (0.0, 0.25),
      (0, 25),
      (0.0, 0.0),
      (0, 0),
      (double.nan, 0),
      (0, double.nan),
      (double.nan, 0.0),
      (0.0, double.nan),
      (double.nan, double.nan),
    ];
    for (final values in okTrueValues) {
      final (firstValue, secondValue) = values;
      test(
        'return correct type and value',
        () {
          const relation = GreaterThan();
          final result = relation.process(firstValue, secondValue);
          expect(
            result,
            isA<Ok>(),
            reason:
                'Type returned from process() must be [Ok] if [num] values of the same type provided',
          );
          expect(
            result.value,
            true,
            reason:
                'Type returned from process() must be [Ok] with true value for "$firstValue" and "$secondValue" provided',
          );
        },
      );
    }
    for (final values in okFalseValues) {
      final (firstValue, secondValue) = values;
      test(
        'return correct type and value',
        () {
          const relation = GreaterThan();
          final result = relation.process(firstValue, secondValue);
          expect(
            result,
            isA<Ok>(),
            reason:
                'Type returned from process() must be [Ok] if [num] values of the same type provided',
          );
          expect(
            result.value,
            false,
            reason:
                'Type returned from process() must be [Ok] with false value for "$firstValue" and "$secondValue" provided',
          );
        },
      );
    }
  });
  //
  group('[NumberMathRelation] process(), [EqualTo] | ', () {
    final okTrueValues = [
      (0.0, 0.0),
      (25.0, 25.0),
      (0, 0),
      (25, 25),
    ];
    final okFalseValues = [
      (0.25, 0.0),
      (25, 0),
      (0.0, 0.25),
      (0, 25),
      (double.nan, 0),
      (0, double.nan),
      (double.nan, 0.0),
      (0.0, double.nan),
      (double.nan, double.nan),
    ];
    for (final values in okTrueValues) {
      final (firstValue, secondValue) = values;
      test(
        'return correct type and value',
        () {
          const relation = EqualTo();
          final result = relation.process(firstValue, secondValue);
          expect(
            result,
            isA<Ok>(),
            reason:
                'Type returned from process() must be [Ok] if [num] values of the same type provided',
          );
          expect(
            result.value,
            true,
            reason:
                'Type returned from process() must be [Ok] with true value for "$firstValue" and "$secondValue" provided',
          );
        },
      );
    }
    for (final values in okFalseValues) {
      final (firstValue, secondValue) = values;
      test(
        'return correct type and value',
        () {
          const relation = EqualTo();
          final result = relation.process(firstValue, secondValue);
          expect(
            result,
            isA<Ok>(),
            reason:
                'Type returned from process() must be [Ok] if [num] values of the same type provided',
          );
          expect(
            result.value,
            false,
            reason:
                'Type returned from process() must be [Ok] with false value for "$firstValue" and "$secondValue" provided',
          );
        },
      );
    }
  });
  //
  group('[NumberMathRelation] process(), [NotEqualTo] | ', () {
    final okTrueValues = [
      (0.25, 0.0),
      (25, 0),
      (0.0, 0.25),
      (0, 25),
      (double.nan, 0),
      (0, double.nan),
      (double.nan, 0.0),
      (0.0, double.nan),
      (double.nan, double.nan),
    ];
    final okFalseValues = [
      (0.0, 0.0),
      (25.0, 25.0),
      (0, 0),
      (25, 25),
    ];
    for (final values in okTrueValues) {
      final (firstValue, secondValue) = values;
      test(
        'return correct type and value',
        () {
          const relation = NotEqualTo();
          final result = relation.process(firstValue, secondValue);
          expect(
            result,
            isA<Ok>(),
            reason:
                'Type returned from process() must be [Ok] if [num] values of the same type provided',
          );
          expect(
            result.value,
            true,
            reason:
                'Type returned from process() must be [Ok] with true value for "$firstValue" and "$secondValue" provided',
          );
        },
      );
    }
    for (final values in okFalseValues) {
      final (firstValue, secondValue) = values;
      test(
        'return correct type and value',
        () {
          const relation = NotEqualTo();
          final result = relation.process(firstValue, secondValue);
          expect(
            result,
            isA<Ok>(),
            reason:
                'Type returned from process() must be [Ok] if [num] values of the same type provided',
          );
          expect(
            result.value,
            false,
            reason:
                'Type returned from process() must be [Ok] with false value for "$firstValue" and "$secondValue" provided',
          );
        },
      );
    }
  });
  //
  group('[NumberMathRelation] process(), [LessThanOrEqualTo] | ', () {
    final okTrueValues = [
      (0.0, 0.25),
      (0, 25),
      (0.0, 0.0),
      (25.0, 25.0),
    ];
    final okFalseValues = [
      (0.25, 0.0),
      (25, 0),
      (double.nan, 0),
      (0, double.nan),
      (double.nan, 0.0),
      (0.0, double.nan),
      (double.nan, double.nan),
    ];
    for (final values in okTrueValues) {
      final (firstValue, secondValue) = values;
      test(
        'return correct type and value',
        () {
          const relation = LessThanOrEqualTo();
          final result = relation.process(firstValue, secondValue);
          expect(
            result,
            isA<Ok>(),
            reason:
                'Type returned from process() must be [Ok] if [num] values of the same type provided',
          );
          expect(
            result.value,
            true,
            reason:
                'Type returned from process() must be [Ok] with true value for "$firstValue" and "$secondValue" provided',
          );
        },
      );
    }
    for (final values in okFalseValues) {
      final (firstValue, secondValue) = values;
      test(
        'return correct type and value',
        () {
          const relation = LessThanOrEqualTo();
          final result = relation.process(firstValue, secondValue);
          expect(
            result,
            isA<Ok>(),
            reason:
                'Type returned from process() must be [Ok] if [num] values of the same type provided',
          );
          expect(
            result.value,
            false,
            reason:
                'Type returned from process() must be [Ok] with false value for "$firstValue" and "$secondValue" provided',
          );
        },
      );
    }
  });
  //
  group('[NumberMathRelation] process(), [GreaterThanOrEqualTo] | ', () {
    final okTrueValues = [
      (0.25, 0.0),
      (25, 0),
      (0.0, 0.0),
      (25.0, 25.0),
    ];
    final okFalseValues = [
      (0.0, 0.25),
      (0, 25),
      (double.nan, 0),
      (0, double.nan),
      (double.nan, 0.0),
      (0.0, double.nan),
      (double.nan, double.nan),
    ];
    for (final values in okTrueValues) {
      final (firstValue, secondValue) = values;
      test(
        'return correct type and value',
        () {
          const relation = GreaterThanOrEqualTo();
          final result = relation.process(firstValue, secondValue);
          expect(
            result,
            isA<Ok>(),
            reason:
                'Type returned from process() must be [Ok] if [num] values of the same type provided',
          );
          expect(
            result.value,
            true,
            reason:
                'Type returned from process() must be [Ok] with true value for "$firstValue" and "$secondValue" provided',
          );
        },
      );
    }
    for (final values in okFalseValues) {
      final (firstValue, secondValue) = values;
      test(
        'return correct type and value',
        () {
          const relation = GreaterThanOrEqualTo();
          final result = relation.process(firstValue, secondValue);
          expect(
            result,
            isA<Ok>(),
            reason:
                'Type returned from process() must be [Ok] if [num] values of the same type provided',
          );
          expect(
            result.value,
            false,
            reason:
                'Type returned from process() must be [Ok] with false value for "$firstValue" and "$secondValue" provided',
          );
        },
      );
    }
  });
  //
  group('[NumberMathRelation] process(), [UnimplementedMathRelation] | ', () {
    final values = [
      (0.25, 0.0),
      (25, 0),
      (0.0, 0.0),
      (25.0, 25.0),
      (0.0, 0.25),
      (0, 25),
      (double.nan, 0),
      (0, double.nan),
      (double.nan, 0.0),
      (0.0, double.nan),
      (double.nan, double.nan),
    ];
    for (final values in values) {
      final (firstValue, secondValue) = values;
      test(
        'return correct type',
        () {
          const relation = UnimplementedMathRelation(stringRepresentation: '');
          final result = relation.process(firstValue, secondValue);
          expect(
            result,
            isA<Err>(),
            reason: 'Type returned from process() must be [Err] for any values',
          );
        },
      );
    }
  });
}
