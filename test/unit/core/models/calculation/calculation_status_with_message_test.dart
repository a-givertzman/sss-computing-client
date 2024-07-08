import 'package:flutter_test/flutter_test.dart';
import 'package:sss_computing_client/core/models/calculation/calculation_status.dart';
import 'package:sss_computing_client/core/models/calculation/calculation_status_state.dart';
void main() {
  test(
    '[CalculationStatusWithMessage] .message',
    () {
      //
      final testData = [
        {
          'input': CalculationStatus()
            ..start()
            ..complete(message: 'some message'),
          'expect': 'some message',
        },
        {
          'input': CalculationStatus()
            ..start()
            ..complete(errorMessage: 'some error message')
            ..start()
            ..complete(message: 'some message'),
          'expect': 'some message',
        },
        {
          'input': CalculationStatus()
            ..start()
            ..complete(message: 'some old message')
            ..start()
            ..complete(message: 'some new message'),
          'expect': 'some new message',
        },
      ];
      for (final data in testData) {
        final state = CalculationStatusState.fromStatus(
          data['input'] as CalculationStatus,
        ) as CalculationStatusWithMessage;
        expect(
          state.message,
          data['expect'] as String,
          reason: 'Last received message must be returned',
        );
      }
    },
  );
}
