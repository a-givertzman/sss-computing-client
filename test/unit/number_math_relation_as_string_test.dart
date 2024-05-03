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
          relation.asString,
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
          relation.asString,
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
          relation.asString,
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
          relation.asString,
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
          relation.asString,
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
          relation.asString,
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
            relation.asString,
            value,
            reason:
                'asString for [UnimplementedMathRelation] should return stringRepresentaion passed in constructor',
          );
        },
      );
    }
  });
}
