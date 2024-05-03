import 'package:flutter_test/flutter_test.dart';
import 'package:hmi_core/hmi_core_result_new.dart';
import 'package:sss_computing_client/core/models/criterion/number_math_relation.dart';
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
    ];
    for (final values in okTrueValues) {
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
          if (result is Ok) {
            final resultValue = (result as Ok).value;
            expect(
              resultValue,
              true,
              reason:
                  'Type returned from process() must be [Ok] with true value for "$firstValue" and "$secondValue" provided',
            );
          }
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
          if (result is Ok) {
            final resultValue = (result as Ok).value;
            expect(
              resultValue,
              false,
              reason:
                  'Type returned from process() must be [Ok] with false value for "$firstValue" and "$secondValue" provided',
            );
          }
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
          if (result is Ok) {
            final resultValue = (result as Ok).value;
            expect(
              resultValue,
              true,
              reason:
                  'Type returned from process() must be [Ok] with true value for "$firstValue" and "$secondValue" provided',
            );
          }
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
          if (result is Ok) {
            final resultValue = (result as Ok).value;
            expect(
              resultValue,
              false,
              reason:
                  'Type returned from process() must be [Ok] with false value for "$firstValue" and "$secondValue" provided',
            );
          }
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
          if (result is Ok) {
            final resultValue = (result as Ok).value;
            expect(
              resultValue,
              true,
              reason:
                  'Type returned from process() must be [Ok] with true value for "$firstValue" and "$secondValue" provided',
            );
          }
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
          if (result is Ok) {
            final resultValue = (result as Ok).value;
            expect(
              resultValue,
              false,
              reason:
                  'Type returned from process() must be [Ok] with false value for "$firstValue" and "$secondValue" provided',
            );
          }
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
          if (result is Ok) {
            final resultValue = (result as Ok).value;
            expect(
              resultValue,
              true,
              reason:
                  'Type returned from process() must be [Ok] with true value for "$firstValue" and "$secondValue" provided',
            );
          }
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
          if (result is Ok) {
            final resultValue = (result as Ok).value;
            expect(
              resultValue,
              false,
              reason:
                  'Type returned from process() must be [Ok] with false value for "$firstValue" and "$secondValue" provided',
            );
          }
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
          if (result is Ok) {
            final resultValue = (result as Ok).value;
            expect(
              resultValue,
              true,
              reason:
                  'Type returned from process() must be [Ok] with true value for "$firstValue" and "$secondValue" provided',
            );
          }
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
          if (result is Ok) {
            final resultValue = (result as Ok).value;
            expect(
              resultValue,
              false,
              reason:
                  'Type returned from process() must be [Ok] with false value for "$firstValue" and "$secondValue" provided',
            );
          }
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
          if (result is Ok) {
            final resultValue = (result as Ok).value;
            expect(
              resultValue,
              true,
              reason:
                  'Type returned from process() must be [Ok] with true value for "$firstValue" and "$secondValue" provided',
            );
          }
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
          if (result is Ok) {
            final resultValue = (result as Ok).value;
            expect(
              resultValue,
              false,
              reason:
                  'Type returned from process() must be [Ok] with false value for "$firstValue" and "$secondValue" provided',
            );
          }
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
    ];
    for (final values in values) {
      final (firstValue, secondValue) = values;
      test(
        'return correct type',
        () {
          const relation = UnimplementedMathRelation(stringRepresentaion: '');
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
