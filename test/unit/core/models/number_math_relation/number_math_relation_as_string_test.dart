import 'package:flutter_test/flutter_test.dart';
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
  group('[NumberMathRelation] operator', () {
    //
    test(
      '[LessThan] return correct operator value',
      () {
        const relation = LessThan();
        expect(
          relation.operator,
          '<',
          reason: 'operator for [LessThan] should return "<"',
        );
      },
    );
    //
    test(
      '[GreaterThan] return correct operator value',
      () {
        const relation = GreaterThan();
        expect(
          relation.operator,
          '>',
          reason: 'operator for [GreaterThan] should return ">"',
        );
      },
    );
    //
    test(
      '[EqualTo] return correct operator value',
      () {
        const relation = EqualTo();
        expect(
          relation.operator,
          '=',
          reason: 'operator for [EqualTo] should return "="',
        );
      },
    );
    //
    test(
      '[NotEqualTo] return correct operator value',
      () {
        const relation = NotEqualTo();
        expect(
          relation.operator,
          '≠',
          reason: 'operator for [NotEqualTo] should return "≠"',
        );
      },
    );
    //
    test(
      '[LessThanOrEqualTo] return correct operator value',
      () {
        const relation = LessThanOrEqualTo();
        expect(
          relation.operator,
          '≤',
          reason: 'operator for [LessThanOrEqualTo] should return "≤"',
        );
      },
    );
    //
    test(
      '[GreaterThanOrEqualTo] return correct operator value',
      () {
        const relation = GreaterThanOrEqualTo();
        expect(
          relation.operator,
          '≥',
          reason: 'operator for [GreaterThanOrEqualTo] should return "≥"',
        );
      },
    );
    //
    test('[UnimplementedMathRelation] return correct operator value', () {
      final values = ['', '-', '.', '>>', '<<', '><', '=>', '=<', '!!='];
      for (final value in values) {
        final relation = UnimplementedMathRelation(
          stringRepresentaion: value,
        );
        expect(
          relation.operator,
          value,
          reason:
              'operator for [UnimplementedMathRelation] should return stringRepresentaion passed in constructor',
        );
      }
    });
  });
}
