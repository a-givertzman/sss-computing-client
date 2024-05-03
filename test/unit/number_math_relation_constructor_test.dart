import 'package:flutter_test/flutter_test.dart';
import 'package:sss_computing_client/core/models/criterion/number_math_relation.dart';
///
void main() {
  //
  group('[NumberMathRelation] factory constructor, [LessThan] | ', () {
    final testValues = [
      ..._getVariantsOfPadding('<'),
    ];
    for (final value in testValues) {
      test(
        'created the correct implementation of [NumberMathRelation] from provided string representaion: "$value"',
        () {
          final relation = NumberMathRelation.fromString(value);
          expect(
            relation,
            isA<LessThan>(),
            reason: 'Type of the created relation must be [LessThan]',
          );
        },
      );
    }
  });
  //
  group('[NumberMathRelation] factory constructor, [GreaterThan] | ', () {
    final testValues = [
      ..._getVariantsOfPadding('>'),
    ];
    for (final value in testValues) {
      test(
        'created the correct implementation of [NumberMathRelation] from provided string representaion: "$value"',
        () {
          final relation = NumberMathRelation.fromString(value);
          expect(
            relation,
            isA<GreaterThan>(),
            reason: 'Type of the created relation must be [GreaterThan]',
          );
        },
      );
    }
  });
  //
  group('[NumberMathRelation] factory constructor, [EqualTo] | ', () {
    final testValues = [
      ..._getVariantsOfPadding('='),
    ];
    for (final value in testValues) {
      test(
        'created the correct implementation of [NumberMathRelation] from provided string representaion: "$value"',
        () {
          final relation = NumberMathRelation.fromString(value);
          expect(
            relation,
            isA<EqualTo>(),
            reason: 'Type of the created relation must be [EqualTo]',
          );
        },
      );
    }
  });
  //
  group('[NumberMathRelation] factory constructor, [NotEqualTo] | ', () {
    final testValues = [
      ..._getVariantsOfPadding('!='),
      ..._getVariantsOfPadding('≠'),
      ..._getVariantsOfPadding('<>'),
    ];
    for (final value in testValues) {
      test(
        'created the correct implementation of [NumberMathRelation] from provided string representaion: "$value"',
        () {
          final relation = NumberMathRelation.fromString(value);
          expect(
            relation,
            isA<NotEqualTo>(),
            reason: 'Type of the created relation must be [NotEqualTo]',
          );
        },
      );
    }
  });
  //
  group('[NumberMathRelation] factory constructor, [LessThanOrEqualTo] | ', () {
    final testValues = [
      ..._getVariantsOfPadding('<='),
      ..._getVariantsOfPadding('≤'),
    ];
    for (final value in testValues) {
      test(
        'created the correct implementation of [NumberMathRelation] from provided string representaion: "$value"',
        () {
          final relation = NumberMathRelation.fromString(value);
          expect(
            relation,
            isA<LessThanOrEqualTo>(),
            reason: 'Type of the created relation must be [LessThanOrEqualTo]',
          );
        },
      );
    }
  });
  //
  group(
    '[NumberMathRelation] factory constructor, [GreaterThanOrEqualTo] | ',
    () {
      final testValues = [
        ..._getVariantsOfPadding('>='),
        ..._getVariantsOfPadding('≥'),
      ];
      for (final value in testValues) {
        test(
          'created the correct implementation of [NumberMathRelation] from provided string representaion: "$value"',
          () {
            final relation = NumberMathRelation.fromString(value);
            expect(
              relation,
              isA<GreaterThanOrEqualTo>(),
              reason:
                  'Type of the created relation must be [GreaterThanOrEqualTo]',
            );
          },
        );
      }
    },
  );
  //
  group(
    '[NumberMathRelation] factory constructor, [UnimplementedMathRelation] | ',
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
        test(
          'created the correct implementation of [NumberMathRelation] from provided string representaion: "$value"',
          () {
            final relation = NumberMathRelation.fromString(value);
            expect(
              relation,
              isA<UnimplementedMathRelation>(),
              reason:
                  'Type of the created relation must be [UnimplementedMathRelation]',
            );
          },
        );
      }
    },
  );
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
