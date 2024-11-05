import 'package:flutter_test/flutter_test.dart';
import 'package:hmi_core/hmi_core.dart';
import 'package:hmi_core/hmi_core_result_new.dart';
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
  group('FieldData fetch method', () {
    //
    test('returns [Ok] on successful fetching', () async {
      final fetchResult = await fieldDataSuccess.fetch();
      expect(fetchResult, isA<Ok>());
    });
    //
    test('returns [Err] if fetching fails', () async {
      final fetchResult = await fieldDataError.fetch();
      expect(fetchResult, isA<Err>());
    });
    //
    test(
      'returns [Ok] with fetched value on successful fetching',
      () async {
        final fetchResult = await fieldDataSuccess.fetch();
        expect(fetchResult, isA<Ok>());
        expect((fetchResult as Ok).value, 'fetchValue');
      },
    );
    //
    test(
      'updates [initialValue] with fetched value on successful fetching',
      () async {
        final fetchResult = await fieldDataSuccess.fetch();
        expect(fetchResult, isA<Ok>());
        expect(fieldDataSuccess.initialValue, 'fetchValue');
      },
    );
    //
    test(
      'updates [controller] text with fetched value on successful fetching',
      () async {
        final fetchResult = await fieldDataSuccess.fetch();
        expect(fetchResult, isA<Ok>());
        expect(fieldDataSuccess.initialValue, 'fetchValue');
      },
    );
    //
    test(
      'does not modify value stored in record on successful fetching',
      () async {
        final fetchResult = await fieldDataSuccess.fetch();
        expect(fetchResult, isA<Ok>());
        expect(recordSuccess.value, 'fetchValue');
      },
    );
    //
    test(
      'does not modify value stored in record if fetching fails',
      () async {
        final fetchResult = await fieldDataError.fetch();
        expect(fetchResult, isA<Err>());
        expect(recordError.value, 'fetchValue');
      },
    );
    //
    test(
      'sets [isSynced] to true on successful fetching',
      () async {
        final fetchResult = await fieldDataSuccess.fetch();
        expect(fetchResult, isA<Ok>());
        expect(fieldDataSuccess.isSynced, isTrue);
      },
    );
    //
    test(
      'does not modify [isSynced] if fetching fails',
      () async {
        final fetchResult = await fieldDataError.fetch();
        expect(fetchResult, isA<Err>());
        expect(fieldDataError.isSynced, isFalse);
      },
    );
  });
}
