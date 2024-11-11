import 'package:flutter_test/flutter_test.dart';
import 'package:sss_computing_client/core/models/field/field_data.dart';
import 'package:sss_computing_client/core/models/field/field_type.dart';
//
void main() {
  //
  group('FieldData constructor', () {
    //
    test('sets controller text to initial value', () async {
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
        expect(fieldData.controller.text, initialValue);
      }
    });
  });
}
