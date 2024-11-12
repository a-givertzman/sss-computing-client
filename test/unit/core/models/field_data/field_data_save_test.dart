import 'package:flutter_test/flutter_test.dart';
import 'package:hmi_core/hmi_core.dart';
import 'package:sss_computing_client/core/models/field/field_data.dart';
import 'package:sss_computing_client/core/models/field/field_type.dart';
import 'package:sss_computing_client/core/models/record/value_record.dart';
///
/// Fake [ValueRecord] for [FieldData]
/// that does not store value in any source.
final class FakeRecord<T> implements ValueRecord<T> {
  final bool isSuccess;
  T value;
  final T Function(String text) toValue;
  ///
  FakeRecord(
    this.value,
    this.toValue, {
    this.isSuccess = true,
  });
  @override
  Future<ResultF<T>> fetch() {
    return isSuccess
        ? Future.value(Ok(value))
        : Future.value(Err(Failure(
            message: 'fetch error',
            stackTrace: StackTrace.current,
          )));
  }
  @override
  Future<ResultF<T>> persist(String newValue) {
    if (isSuccess) value = toValue(newValue);
    return isSuccess
        ? Future.value(Ok(value))
        : Future.value(Err(Failure(
            message: 'persist error',
            stackTrace: StackTrace.current,
          )));
  }
}
//
void main() {
  late FakeRecord<String> recordSuccess;
  late FakeRecord<String> recordError;
  late FieldData fieldDataSuccess;
  late FieldData fieldDataError;
  //
  setUp(() {
    recordSuccess = FakeRecord<String>(
      'fetchValue',
      (text) => text,
      isSuccess: true,
    );
    recordError = FakeRecord<String>(
      'fetchValue',
      (text) => text,
      isSuccess: false,
    );
    fieldDataSuccess = FieldData<String>(
      id: 'test',
      label: 'test',
      fieldType: FieldType.string,
      initialValue: 'initialValue',
      toValue: (text) => text,
      toText: (value) => value,
      record: recordSuccess,
      isSynced: false,
    );
    fieldDataError = FieldData<String>(
      id: 'test',
      label: 'test',
      fieldType: FieldType.string,
      initialValue: 'initialValue',
      toValue: (text) => text,
      toText: (value) => value,
      record: recordError,
      isSynced: false,
    );
  });
  //
  group('FieldData save method', () {
    //
    test('returns [Ok] on successful saving', () async {
      final fetchResult = await fieldDataSuccess.save();
      expect(fetchResult, isA<Ok>());
    });
    //
    test('returns [Err] if saving fails', () async {
      final fetchResult = await fieldDataError.save();
      expect(fetchResult, isA<Err>());
    });
    //
    test(
      'updates value stored in record on successful saving',
      () async {
        final fetchResult = await fieldDataSuccess.save();
        expect(fetchResult, isA<Ok>());
        expect(recordSuccess.value, 'initialValue');
      },
    );
    //
    test(
      'updates value stored in record on successful saving after some updates',
      () async {
        fieldDataSuccess.controller.text = 'newValue';
        final fetchResult = await fieldDataSuccess.save();
        expect(fetchResult, isA<Ok>());
        expect(recordSuccess.value, 'newValue');
      },
    );
    //
    test(
      'updates [initialValue] on successful record saving',
      () async {
        fieldDataSuccess.controller.text = 'newValue';
        final fetchResult = await fieldDataSuccess.save();
        expect(fetchResult, isA<Ok>());
        expect(fieldDataSuccess.initialValue, 'newValue');
      },
    );
    //
    test(
      'sets [isSynced] to true on successful record saving',
      () async {
        final fetchResult = await fieldDataSuccess.save();
        expect(fetchResult, isA<Ok>());
        expect(fieldDataSuccess.isSynced, isTrue);
      },
    );
    //
    test(
      'does not modify [isSynced] if record saving fails',
      () async {
        final fetchResult = await fieldDataError.save();
        expect(fetchResult, isA<Err>());
        expect(fieldDataError.isSynced, isFalse);
      },
    );
  });
}
