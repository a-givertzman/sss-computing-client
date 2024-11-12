//
import 'package:flutter_test/flutter_test.dart';
import 'package:sss_computing_client/core/models/field/field_data.dart';
import 'package:sss_computing_client/core/models/field/field_type.dart';
//
void main() {
  //
  group('FieldData refresh method', () {
    late FieldData fieldData;
    //
    setUp(() {
      fieldData = FieldData(
        id: 'test',
        label: 'test',
        fieldType: FieldType.string,
        initialValue: 'initialValue',
        toValue: (text) => text,
        toText: (value) => value,
      );
    });
    //
    test('changes controller text to new value', () async {
      const newValueList = [
        'abc',
        '123456',
        'someTestData1',
        '+=-_()*;&.^,:%\$#№@"!><',
      ];
      for (final newValue in newValueList) {
        fieldData.refreshWith(newValue);
        expect(fieldData.controller.text, newValue);
      }
    });
    //
    test('updates initial value with new one', () async {
      const newValueList = [
        'abc',
        '123456',
        'someTestData1',
        '+=-_()*;&.^,:%\$#№@"!><',
      ];
      for (final newValue in newValueList) {
        fieldData.refreshWith(newValue);
        expect(fieldData.initialValue, newValue);
      }
    });
  });
}
