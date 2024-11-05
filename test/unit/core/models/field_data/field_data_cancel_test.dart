import 'package:flutter_test/flutter_test.dart';
import 'package:sss_computing_client/core/models/field/field_data.dart';
import 'package:sss_computing_client/core/models/field/field_type.dart';
//
void main() {
  //
  group('FieldData cancel method', () {
    //
    test('sets controller text to initial value without updates', () async {
      const initialData = [
        'abc',
        '123456',
        'someTestData1',
        '+=-_()*;&.^,:%\$#№@"!><',
      ];
      for (final initialValue in initialData) {
        final fieldData = FieldData<String>(
          id: 'test',
          label: 'test',
          fieldType: FieldType.string,
          initialValue: initialValue,
          toValue: (text) => text,
          toText: (value) => value,
        );
        fieldData.cancel();
        expect(fieldData.controller.text, initialValue);
      }
    });
    //
    test('sets controller text to initial value after some updates', () async {
      const initialData = [
        'abc',
        '123456',
        'someTestData1',
        '+=-_()*;&.^,:%\$#№@"!><',
      ];
      for (final initialValue in initialData) {
        final fieldData = FieldData<String>(
          id: 'test',
          label: 'test',
          fieldType: FieldType.string,
          initialValue: initialValue,
          toValue: (text) => text,
          toText: (value) => value,
        );
        fieldData.controller.text = 'updateValue1';
        fieldData.controller.text = 'updateValue2';
        fieldData.controller.text = 'updateValue3';
        fieldData.cancel();
        expect(fieldData.controller.text, initialValue);
      }
    });
  });
}
