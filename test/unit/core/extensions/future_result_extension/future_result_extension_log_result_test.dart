import 'package:flutter_test/flutter_test.dart';
import 'package:hmi_core/hmi_core.dart';
import 'package:sss_computing_client/core/extensions/future_result_extension.dart';
//
void main() {
  //
  group(
    'FutureResultExtension',
    () {
      //
      test(
        'logResult returns [Future] with original result if [Ok]',
        () async {
          final testResults = <Ok<dynamic, Failure<dynamic>>>[
            const Ok('value'), // String
            const Ok(42), // int
            const Ok(42.0), // double
            const Ok(true), // bool
            const Ok(null), // null
            const Ok([42]), // List
            const Ok({'42': 42}), // Map
          ];
          for (final testResult in testResults) {
            final loggedResult = await Future.value(
              testResult,
            ).logResult(
              const Log('test log'),
            );
            expect(
              loggedResult,
              isA<Ok>(),
              reason: 'logResult should return [Ok] when result is [Ok]',
            );
            expect(
              (loggedResult as Ok).value,
              testResult.value,
              reason: 'logResult should return [Ok] with original value',
            );
          }
        },
      );
      //
      test(
        'logResult returns [Future] with original result if [Err]',
        () async {
          final testResults = <Err<dynamic, Failure<dynamic>>>[
            Err(Failure(
              message: 'error',
              stackTrace: StackTrace.empty,
            )), // String
            Err(Failure(
              message: 42,
              stackTrace: StackTrace.empty,
            )), // int
            Err(Failure(
              message: 42.0,
              stackTrace: StackTrace.empty,
            )), // double
            Err(Failure(
              message: true,
              stackTrace: StackTrace.empty,
            )), // bool
            Err(Failure(
              message: null,
              stackTrace: StackTrace.empty,
            )), // null
            Err(Failure(
              message: [42],
              stackTrace: StackTrace.empty,
            )), // List
            Err(Failure(
              message: {'42': 42},
              stackTrace: StackTrace.empty,
            )), // Map
          ];
          for (final testResult in testResults) {
            final loggedResult = await Future.value(
              testResult,
            ).logResult(
              const Log('test log'),
            );
            expect(
              loggedResult,
              isA<Err>(),
              reason: 'logResult should return [Err] when result is [Err]',
            );
            expect(
              (loggedResult as Err).error.message,
              testResult.error.message,
              reason: 'logResult should return [Err] with original value',
            );
          }
        },
      );
    },
  );
}
