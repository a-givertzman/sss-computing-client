import 'package:flutter_test/flutter_test.dart';
import 'package:sss_computing_client/core/models/criterion/number_math_relation.dart';
///
void main() {
  //
  group('[NumberMathRelation] factory constructor', () {
    //
    test(
      'creates the correct implementation of [NumberMathRelation] from provided string representaion',
      () {
        final testValues = [
          ..._getVariantsOfPadding('<'),
        ];
        for (final value in testValues) {
          final relation = NumberMathRelation.fromString(value);
          expect(
            relation,
            isA<LessThan>(),
            reason: 'Type of the created relation must be [LessThan]',
          );
        }
      },
    );

    //
    test(
      'creates the correct implementation of [NumberMathRelation] from provided string representaion',
      () {
        final testValues = [
          ..._getVariantsOfPadding('>'),
        ];
        for (final value in testValues) {
          final relation = NumberMathRelation.fromString(value);
          expect(
            relation,
            isA<GreaterThan>(),
            reason: 'Type of the created relation must be [GreaterThan]',
          );
        }
      },
    );
    //
    test(
      'creates the correct implementation of [NumberMathRelation] from provided string representaion',
      () {
        final testValues = [
          ..._getVariantsOfPadding('='),
        ];
        for (final value in testValues) {
          final relation = NumberMathRelation.fromString(value);
          expect(
            relation,
            isA<EqualTo>(),
            reason: 'Type of the created relation must be [EqualTo]',
          );
        }
      },
    );
    //
    test(
      'creates the correct implementation of [NumberMathRelation] from provided string representaion',
      () {
        final testValues = [
          ..._getVariantsOfPadding('!='),
          ..._getVariantsOfPadding('≠'),
          ..._getVariantsOfPadding('<>'),
        ];
        for (final value in testValues) {
          final relation = NumberMathRelation.fromString(value);
          expect(
            relation,
            isA<NotEqualTo>(),
            reason: 'Type of the created relation must be [NotEqualTo]',
          );
        }
      },
    );
//
    test(
      'creates the correct implementation of [NumberMathRelation] from provided string representaion',
      () {
        final testValues = [
          ..._getVariantsOfPadding('<='),
          ..._getVariantsOfPadding('≤'),
        ];
        for (final value in testValues) {
          final relation = NumberMathRelation.fromString(value);
          expect(
            relation,
            isA<LessThanOrEqualTo>(),
            reason: 'Type of the created relation must be [LessThanOrEqualTo]',
          );
        }
      },
    );
    //
    test(
      'creates the correct implementation of [NumberMathRelation] from provided string representaion',
      () {
        final testValues = [
          ..._getVariantsOfPadding('>='),
          ..._getVariantsOfPadding('≥'),
        ];
        for (final value in testValues) {
          final relation = NumberMathRelation.fromString(value);
          expect(
            relation,
            isA<GreaterThanOrEqualTo>(),
            reason:
                'Type of the created relation must be [GreaterThanOrEqualTo]',
          );
        }
      },
    );
    //
    test(
      'creates the correct implementation of [NumberMathRelation] from provided string representaion',
      () {
        final testValues = [
          ..._getVariantsOfPadding(''),
          ..._getVariantsOfPadding('-'),
          ..._getVariantsOfPadding('.'),
          ..._getVariantsOfPadding('>>'),
          ..._getVariantsOfPadding('<<'),
          ..._getVariantsOfPadding('><'),
          ..._getVariantsOfPadding('=>'),
          ..._getVariantsOfPadding('=<'),
          ..._getVariantsOfPadding('!!='),
        ];
        for (final value in testValues) {
          final relation = NumberMathRelation.fromString(value);
          expect(
            relation,
            isA<UnimplementedMathRelation>(),
            reason:
                'Type of the created relation must be [UnimplementedMathRelation]',
          );
        }
      },
    );
  });
}
///
List<String> _getVariantsOfPadding(String text, {String paddingValue = ' '}) {
  repeated(int number) => List.filled(number, paddingValue).join();
  return [
    text,
    '$text${repeated(1)}',
    '${repeated(1)}$text',
    '${repeated(1)}$text${repeated(1)}',
    '${repeated(1)}$text${repeated(2)}',
    '${repeated(2)}$text${repeated(1)}',
    '${repeated(4)}$text${repeated(4)}',
  ];
}
