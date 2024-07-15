import 'package:flutter_test/flutter_test.dart';
import 'package:sss_computing_client/core/models/calculation/calculation_status.dart';
import 'package:sss_computing_client/core/models/calculation/calculation_status_state.dart';
void main() {
  test(
    '[CalculationStatusWithError] .errorMessage',
    () {
      //
      final testData = [
        {
          'input': CalculationStatus()
            ..start()
            ..complete(errorMessage: 'some error message'),
          'expect': 'some error message',
        },
        {
          'input': CalculationStatus()
            ..start()
            ..complete(message: 'some message')
            ..start()
            ..complete(errorMessage: 'some error message'),
          'expect': 'some error message',
        },
        {
          'input': CalculationStatus()
            ..start()
            ..complete(errorMessage: 'some old error message')
            ..start()
            ..complete(errorMessage: 'some new error message'),
          'expect': 'some new error message',
        },
      ];
      for (final data in testData) {
        final state = CalculationStatusState.fromStatus(
          data['input'] as CalculationStatus,
        ) as CalculationStatusWithError;
        expect(
          state.errorMessage,
          data['expect'] as String,
          reason: 'Last received error message must be returned',
        );
      }
    },
  );
}
