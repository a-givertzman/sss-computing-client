import 'package:flutter_test/flutter_test.dart';
import 'package:hmi_core/hmi_core.dart';
import 'package:sss_computing_client/core/copy_on_write_text_file.dart';
///
/// Fake implementation of [TextFile]
class FakeTextFile implements TextFile {
  String? _content;
  ///
  /// Creates [FakeTextFile] with a given [content] if provided.
  FakeTextFile({String? content}) : _content = content;
  //
  @override
  Future<ResultF<String>> get content {
    if (_content != null) {
      return Future.value(
        Ok(_content!),
      );
    } else {
      return Future.value(
        Err(Failure(
          message: 'No content',
          stackTrace: StackTrace.current,
        )),
      );
    }
  }
  //
  @override
  Future<void> write(String content) {
    _content = content;
    return Future.value();
  }
}
//
void main() {
  //
  group(
    'CopyOnWriteTextFile .write',
    () {
      //
      test(
        'writes [content] to [target] if [source] and [target] has not been written yet',
        () async {
          final contentToWriteTestCases = [
            'first line some test text 12345\nsecond line some test text 12345\n',
            '',
            '0123456789',
            'abcdefghijklmnopqrstuvwxyz',
            'ABCDEFGHIJKLMNOPQRSTUVWXYZ',
            'абвгдеёжзийклмнопрстуфхцчшщъыьэюя',
            'АБВГДЕЁЖЗИЙКЛМНОПРСТУФХЦЧШЩЪЫЬЭЮЯ',
            '!@#\$%^&*()_+=-"№;:?./\\|[]{}',
          ];
          for (final content in contentToWriteTestCases) {
            final target = FakeTextFile();
            final source = FakeTextFile();
            final copyOnWrite = CopyOnWriteTextFile(
              source: target,
              target: source,
            );
            await copyOnWrite.write(content);
            final result = await copyOnWrite.content;
            expect(result, isA<Ok>());
            expect(
              switch (result) {
                Ok(value: final content) => content,
                Err() => null,
              },
              content,
            );
          }
        },
      );
      //
      test(
        'writes [content] to [target] if it has not been written yet and left [source] unchanged',
        () async {
          final testCases = <({String? source, String contentToWrite})>[
            (
              contentToWrite:
                  'first line some test text 12345\nsecond line some test text 12345\nplus modified',
              source:
                  'first line some test text 12345\nsecond line some test text 12345\n',
            ),
            (
              contentToWrite: 'plus modified',
              source: '',
            ),
            (
              contentToWrite: '0123456789',
              source: null,
            ),
            (
              contentToWrite: 'abcdefghijk',
              source: 'abcdefghijklmnopqrstuvwxyz',
            ),
            (
              contentToWrite: '',
              source: 'ABCDEFGHIJKLMNOPQRSTUVWXYZ',
            ),
            (
              contentToWrite: 'абвгдеёжзийклмнопрстуфхцчшщъыьэюя\n\n\n',
              source: 'абвгдеёжзийклмнопрстуфхцчшщъыьэюя',
            ),
            (
              contentToWrite: '\n\n\nАБВГДЕЁЖЗИЙКЛМНОПРСТУФХЦЧШЩЪЫЬЭЮЯ',
              source: 'АБВГДЕЁЖЗИЙКЛМНОПРСТУФХЦЧШЩЪЫЬЭЮЯ',
            ),
            (
              contentToWrite: '{}[]|\\/.:?;№"-=_+)(*&^%\$#@!',
              source: '!@#\$%^&*()_+=-"№;:?./\\|[]{}',
            ),
          ];
          for (final testCase in testCases) {
            final target = FakeTextFile();
            final source = FakeTextFile(content: testCase.source);
            final copyOnWrite = CopyOnWriteTextFile(
              target: target,
              source: source,
            );
            final sourceResultBeforeWrite = await source.content;
            await copyOnWrite.write(testCase.contentToWrite);
            final sourceResultAfterWrite = await source.content;
            final targetResult = await target.content;
            expect(targetResult, isA<Ok>());
            expect(
              switch (targetResult) {
                Ok(value: final content) => content,
                Err() => null,
              },
              testCase.contentToWrite,
            );
            expect(
              switch (sourceResultBeforeWrite) {
                Ok(value: final content) => content,
                Err(error: final failure) => failure.message,
              },
              switch (sourceResultAfterWrite) {
                Ok(value: final content) => content,
                Err(error: final failure) => failure.message,
              },
            );
          }
        },
      );
      //
      test(
        'writes new [content] to [target] if it has been written already and left [source] unchanged',
        () async {
          final testCases = <({
            String? source,
            String target,
            String contentToWrite,
          })>[
            (
              contentToWrite: 'new target content 1',
              target:
                  'first line some test text 12345\nsecond line some test text 12345\nplus modified',
              source:
                  'first line some test text 12345\nsecond line some test text 12345\n',
            ),
            (
              contentToWrite: 'new target content 2',
              target: 'plus modified',
              source: '',
            ),
            (
              contentToWrite: 'new target content 3',
              target: '0123456789',
              source: null,
            ),
            (
              contentToWrite: 'new target content 4',
              target: 'abcdefghijk',
              source: 'abcdefghijklmnopqrstuvwxyz',
            ),
            (
              contentToWrite: 'new target content 5',
              target: '',
              source: 'ABCDEFGHIJKLMNOPQRSTUVWXYZ',
            ),
            (
              contentToWrite: 'new target content 6',
              target: 'абвгдеёжзийклмнопрстуфхцчшщъыьэюя\n\n\n',
              source: 'абвгдеёжзийклмнопрстуфхцчшщъыьэюя',
            ),
            (
              contentToWrite: 'new target content 7',
              target: '\n\n\nАБВГДЕЁЖЗИЙКЛМНОПРСТУФХЦЧШЩЪЫЬЭЮЯ',
              source: 'АБВГДЕЁЖЗИЙКЛМНОПРСТУФХЦЧШЩЪЫЬЭЮЯ',
            ),
            (
              contentToWrite: 'new target content 8',
              target: '{}[]|\\/.:?;№"-=_+)(*&^%\$#@!',
              source: '!@#\$%^&*()_+=-"№;:?./\\|[]{}',
            ),
          ];
          for (final testCase in testCases) {
            final target = FakeTextFile();
            final source = FakeTextFile(content: testCase.source);
            final copyOnWrite = CopyOnWriteTextFile(
              target: target,
              source: source,
            );
            final sourceResultBeforeWrite = await source.content;
            await copyOnWrite.write(testCase.contentToWrite);
            final sourceResultAfterWrite = await source.content;
            final targetResult = await target.content;
            expect(targetResult, isA<Ok>());
            expect(
              switch (targetResult) {
                Ok(value: final content) => content,
                Err() => null,
              },
              testCase.contentToWrite,
            );
            expect(
              switch (sourceResultBeforeWrite) {
                Ok(value: final content) => content,
                Err(error: final failure) => failure.message,
              },
              switch (sourceResultAfterWrite) {
                Ok(value: final content) => content,
                Err(error: final failure) => failure.message,
              },
            );
          }
        },
      );
    },
  );
}
