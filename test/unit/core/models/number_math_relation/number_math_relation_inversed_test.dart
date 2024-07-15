import 'package:flutter_test/flutter_test.dart';
import 'package:sss_computing_client/core/models/number_math_relation/equal_to.dart';
import 'package:sss_computing_client/core/models/number_math_relation/greater_than.dart';
import 'package:sss_computing_client/core/models/number_math_relation/greater_than_or_equal_to.dart';
import 'package:sss_computing_client/core/models/number_math_relation/less_than.dart';
import 'package:sss_computing_client/core/models/number_math_relation/less_than_or_equal_to.dart';
import 'package:sss_computing_client/core/models/number_math_relation/not_equal_to.dart';
///
void main() {
  //
  group('[NumberMathRelation] inversed()', () {
    //
    test(
      '[LessThan]',
      () {
        expect(
          const LessThan().inversed(),
          isA<GreaterThanOrEqualTo>(),
          reason:
              'Type of the returned relation must be [GreaterThanOrEqualTo]',
        );
      },
    );
    //
    test(
      '[GreaterThan]',
      () {
        expect(
          const GreaterThan().inversed(),
          isA<LessThanOrEqualTo>(),
          reason: 'Type of the returned relation must be [LessThanOrEqualTo]',
        );
      },
    );
    //
    test(
      '[EqualTo]',
      () {
        expect(
          const EqualTo().inversed(),
          isA<NotEqualTo>(),
          reason: 'Type of the returned relation must be [NotEqualTo]',
        );
      },
    );
    //
    test(
      '[NotEqualTo]',
      () {
        expect(
          const NotEqualTo().inversed(),
          isA<EqualTo>(),
          reason: 'Type of the returned relation must be [EqualTo]',
        );
      },
    );
    //
    test(
      '[LessThanOrEqualTo]',
      () {
        expect(
          const LessThanOrEqualTo().inversed(),
          isA<GreaterThan>(),
          reason: 'Type of the returned relation must be [GreaterThan]',
        );
      },
    );
    //
    test(
      '[GreaterThanOrEqualTo]',
      () {
        expect(
          const GreaterThanOrEqualTo().inversed(),
          isA<LessThan>(),
          reason: 'Type of the returned relation must be [LessThan]',
        );
      },
    );
  });
}
