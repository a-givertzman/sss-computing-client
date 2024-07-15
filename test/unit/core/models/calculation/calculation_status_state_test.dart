import 'package:flutter_test/flutter_test.dart';
import 'package:sss_computing_client/core/models/calculation/calculation_status.dart';
import 'package:sss_computing_client/core/models/calculation/calculation_status_state.dart';
void main() {
  group(
    '[CalculationStatusState] .fromStatus() constructor',
    () {
      //
      test('pass [CalculationStatus] for loading case', () {
        final inputs = [
          CalculationStatus()..start(),
          CalculationStatus()
            ..start()
            ..complete()
            ..start(),
          CalculationStatus()
            ..start()
            ..complete(message: 'some message')
            ..start(),
          CalculationStatus()
            ..start()
            ..complete(errorMessage: 'some error message')
            ..start(),
          CalculationStatus()
            ..start()
            ..complete(
              message: 'some message',
              errorMessage: 'some error message',
            )
            ..start(),
        ];
        for (final input in inputs) {
          final state = CalculationStatusState.fromStatus(input);
          expect(
            state,
            isA<CalculationStatusLoading>(),
            reason:
                'Created [CalculationStatusState] must be instance of [CalculationStatusLoading]',
          );
        }
      });
      //
      test('pass [CalculationStatus] for nothing case', () {
        final inputs = [
          CalculationStatus(),
          CalculationStatus()
            ..start()
            ..complete(),
          CalculationStatus()
            ..start()
            ..complete(message: 'some message')
            ..start()
            ..complete(),
          CalculationStatus()
            ..start()
            ..complete(errorMessage: 'some error message')
            ..start()
            ..complete(),
          CalculationStatus()
            ..start()
            ..complete(
              message: 'some message',
              errorMessage: 'some error message',
            )
            ..start()
            ..complete(),
        ];
        for (final input in inputs) {
          final state = CalculationStatusState.fromStatus(input);
          expect(
            state,
            isA<CalculationStatusNothing>(),
            reason:
                'Created [CalculationStatusState] must be instance of [CalculationStatusNothing]',
          );
        }
      });
      //
      test('pass [CalculationStatus] for withMessage case', () {
        final inputs = [
          CalculationStatus()
            ..start()
            ..complete(message: 'some message'),
          CalculationStatus()
            ..start()
            ..complete()
            ..start()
            ..complete(message: 'some message'),
          CalculationStatus()
            ..start()
            ..complete(errorMessage: 'some error message')
            ..start()
            ..complete(message: 'some message'),
          CalculationStatus()
            ..start()
            ..complete(message: 'some message #1')
            ..start()
            ..complete(message: 'some message #2'),
        ];
        for (final input in inputs) {
          final state = CalculationStatusState.fromStatus(input);
          expect(
            state,
            isA<CalculationStatusWithMessage>(),
            reason:
                'Created [CalculationStatusState] must be instance of [CalculationStatusWithMessage]',
          );
        }
      });
      //
      test('pass [CalculationStatus] for withError case', () {
        final inputs = [
          CalculationStatus()
            ..start()
            ..complete(errorMessage: 'some error message'),
          CalculationStatus()
            ..start()
            ..complete()
            ..start()
            ..complete(errorMessage: 'some error message'),
          CalculationStatus()
            ..start()
            ..complete(message: 'some message')
            ..start()
            ..complete(errorMessage: 'some error message'),
          CalculationStatus()
            ..start()
            ..complete(errorMessage: 'some error message #1')
            ..start()
            ..complete(errorMessage: 'some error message #2'),
        ];
        for (final input in inputs) {
          final state = CalculationStatusState.fromStatus(input);
          expect(
            state,
            isA<CalculationStatusWithError>(),
            reason:
                'Created [CalculationStatusState] must be instance of [CalculationStatusWithError]',
          );
        }
      });
    },
  );
}
