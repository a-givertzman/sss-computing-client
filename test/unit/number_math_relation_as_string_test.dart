import 'package:flutter_test/flutter_test.dart';
import 'package:sss_computing_client/core/models/criterion/number_math_relation.dart';
///
void main() {
  //
  group('[NumberMathRelation] asString, [LessThan] |', () {
    test(
      'return correct asString value',
      () {
        const relation = LessThan();
        expect(
          relation.operator,
          '<',
          reason: 'asString for [LessThan] should return "<"',
        );
      },
    );
  });
  //
  group('[NumberMathRelation] asString, [GreaterThan] |', () {
    test(
      'return correct asString value',
      () {
        const relation = GreaterThan();
        expect(
          relation.operator,
          '>',
          reason: 'asString for [GreaterThan] should return ">"',
        );
      },
    );
  });
  //
  group('[NumberMathRelation] asString, [EqualTo] |', () {
    test(
      'return correct asString value',
      () {
        const relation = EqualTo();
        expect(
          relation.operator,
          '=',
          reason: 'asString for [EqualTo] should return "="',
        );
      },
    );
  });
  //
  group('[NumberMathRelation] asString, [NotEqualTo] |', () {
    test(
      'return correct asString value',
      () {
        const relation = NotEqualTo();
        expect(
          relation.operator,
          '≠',
          reason: 'asString for [NotEqualTo] should return "≠"',
        );
      },
    );
  });
  //
  group('[NumberMathRelation] asString, [LessThanOrEqualTo] |', () {
    test(
      'return correct asString value',
      () {
        const relation = LessThanOrEqualTo();
        expect(
          relation.operator,
          '≤',
          reason: 'asString for [LessThanOrEqualTo] should return "≤"',
        );
      },
    );
  });
  //
  group('[NumberMathRelation] asString, [GreaterThanOrEqualTo] |', () {
    test(
      'return correct asString value',
      () {
        const relation = GreaterThanOrEqualTo();
        expect(
          relation.operator,
          '≥',
          reason: 'asString for [GreaterThanOrEqualTo] should return "≥"',
        );
      },
    );
  });
  //
  group('[NumberMathRelation] asString, [UnimplementedMathRelation] |', () {
    final values = ['', '-', '.', '>>', '<<', '><', '=>', '=<', '!!='];
    for (final value in values) {
      test(
        'return correct asString value',
        () {
          final relation = UnimplementedMathRelation(
            stringRepresentaion: value,
          );
          expect(
            relation.operator,
            value,
            reason:
                'asString for [UnimplementedMathRelation] should return stringRepresentaion passed in constructor',
          );
        },
      );
    }
  });
}
