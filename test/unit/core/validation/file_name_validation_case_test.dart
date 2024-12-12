import 'package:flutter_test/flutter_test.dart';
import 'package:hmi_core/hmi_core.dart';
import 'package:sss_computing_client/core/validation/file_name_validation_case.dart';
//
void main() {
  //
  group('FileNameValidationCase, isSatisfiedBy method', () {
    //
    test('ignores null and empty values, and returns Ok', () {
      const validationCase = FileNameValidationCase();
      final testCases = [
        null,
        '',
      ];
      for (final testCase in testCases) {
        final result = validationCase.isSatisfiedBy(testCase);
        expect(result, isA<Ok>());
      }
    });
    //
    test('returns Ok for valid file name', () {
      const validationCase = FileNameValidationCase();
      final testCases = [
        'valid_file_name',
        'Valid_file_name',
        'VALID_FILE_NAME',
        '1234567890ABXYZ_-()'
      ];
      for (final testCase in testCases) {
        final result = validationCase.isSatisfiedBy(testCase);
        expect(result, isA<Ok>());
      }
    });
    //
    test('returns Err for invalid file name with correct message', () {
      const validationCase = FileNameValidationCase();
      final invalidTestCases = [
        'invalid file name',
        'invalidFileName.txt',
        'invalid_file_name!',
        'invalid_file_name@',
        'invalid_file_name#',
        'invalid_file_name[]',
        'valid_file_name\n',
        '\nvalid_file_name',
        'valid_file_name_1\nvalid_file_name_2',
        '\n',
        ' ',
        '\t',
      ];
      for (final testCase in invalidTestCases) {
        final result = validationCase.isSatisfiedBy(testCase);
        expect(result, isA<Err>());
        expect(
          switch (result) {
            Ok() => '',
            Err(:final error) => '$error',
          },
          'Invalid characters found. Available for use: A-Z, a-z, А-Я, а-я, 0-9, ), (, _, -',
        );
      }
    });
  });
}
