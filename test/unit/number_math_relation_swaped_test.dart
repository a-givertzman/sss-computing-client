import 'package:flutter_test/flutter_test.dart';
import 'package:sss_computing_client/core/models/criterion/number_math_relation.dart';
///
void main() {
  group('[NumberMathRelation] swaped()', () {
    test(
      '[LessThan]',
      () {
        expect(
          const LessThan().swaped(),
          isA<GreaterThan>(),
          reason: 'Type of the returned relation must be [GreaterThan]',
        );
      },
    );
    //
    test(
      '[GreaterThan]',
      () {
        expect(
          const GreaterThan().swaped(),
          isA<LessThan>(),
          reason: 'Type of the returned relation must be [LessThan]',
        );
      },
    );
    //
    test(
      '[EqualTo]',
      () {
        expect(
          const EqualTo().swaped(),
          isA<EqualTo>(),
          reason: 'Type of the returned relation must be [EqualTo]',
        );
      },
    );
    //
    test(
      '[NotEqualTo]',
      () {
        expect(
          const NotEqualTo().swaped(),
          isA<NotEqualTo>(),
          reason: 'Type of the returned relation must be [NotEqualTo]',
        );
      },
    );
    //
    test(
      '[LessThanOrEqualTo]',
      () {
        expect(
          const LessThanOrEqualTo().swaped(),
          isA<GreaterThanOrEqualTo>(),
          reason:
              'Type of the returned relation must be [GreaterThanOrEqualTo]',
        );
      },
    );
    //
    test(
      '[GreaterThanOrEqualTo]',
      () {
        expect(
          const GreaterThanOrEqualTo().swaped(),
          isA<LessThanOrEqualTo>(),
          reason: 'Type of the returned relation must be [LessThanOrEqualTo]',
        );
      },
    );
  });
}
