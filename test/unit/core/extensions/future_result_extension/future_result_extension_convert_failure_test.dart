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
        'convertFailure should return Future<Ok> with the same value when Result is Ok',
        () async {
          final List<Ok<dynamic, Failure<dynamic>>> okResults = [
            const Ok<int, Failure<dynamic>>(42), // int
            const Ok<String, Failure<dynamic>>('42'), // String
            const Ok<double, Failure<dynamic>>(42.0), // double
            const Ok<bool, Failure<dynamic>>(true), // bool
            const Ok<void, Failure<dynamic>>(null), // null
            const Ok<List<int>, Failure<dynamic>>([42]), // List
            const Ok<Map<String, int>, Failure<dynamic>>({
              '42': 42,
            }), // Map
          ];
          for (final okResult in okResults) {
            final mappedResult =
                await Future<Result<dynamic, Failure<dynamic>>>.value(okResult)
                    .convertFailure();
            expect(
              mappedResult,
              isA<Ok<dynamic, Failure<String>>>(),
              reason:
                  'convertFailure should return Future<Ok<T, Failure<String>>> when Result is Ok',
            );
            expect(
              (mappedResult as Ok).value,
              okResult.value,
              reason:
                  'convertFailure should return Future<Ok> with the same value when Result is Ok',
            );
          }
        },
      );
      //
      test(
        'convertFailure should return Future<Err> with string representation of error when Result is Err',
        () async {
          final List<Failure> failureResults = [
            Failure<int>(message: 42, stackTrace: StackTrace.current), // int
            Failure<String>(
              message: '42',
              stackTrace: StackTrace.current,
            ), // String
            Failure<double>(
              message: 42.0,
              stackTrace: StackTrace.current,
            ), // double
            Failure<bool>(
              message: true,
              stackTrace: StackTrace.current,
            ), // bool
            Failure<void>(
              message: null,
              stackTrace: StackTrace.current,
            ), // null
            Failure<List<int>>(
              message: [42],
              stackTrace: StackTrace.current,
            ), // List
            Failure<Map<String, int>>(
              message: {'42': 42},
              stackTrace: StackTrace.current,
            ), // Map
          ];
          for (final failure in failureResults) {
            final mappedResult = await Future.value(
              Err<dynamic, Failure<dynamic>>(failure),
            ).convertFailure();
            expect(
              mappedResult,
              isA<Err<dynamic, Failure<String>>>(),
              reason:
                  'convertFailure should return Future<Err<T, Failure<String>>> when Result is Err',
            );
            expect(
              (mappedResult as Err).error.message,
              '${failure.message}',
              reason:
                  'convertFailure should return Future<Err> with string representation of error when Result is Err',
            );
          }
        },
      );
      //
      test(
        'convertFailure should return Future<Err> with string representation of error when Future throws an error',
        () async {
          final futureErrors = [
            42, // int
            '42', // String
            42.0, // double
            true, // bool
            [42], // List
            {'42': 42}, // Map
          ];
          for (final error in futureErrors) {
            final mappedResult =
                await Future<Result<dynamic, Failure<dynamic>>>.error(error)
                    .convertFailure();
            expect(
              mappedResult,
              isA<Err<dynamic, Failure<String>>>(),
              reason:
                  'convertFailure should return Future<Err<T, Failure<String>>> when Future throws an error',
            );
            expect(
              (mappedResult as Err).error.message,
              '$error',
              reason:
                  'convertFailure should return Future<Err> with string representation of error when Future throws an error',
            );
          }
        },
      );
    },
  );
}
