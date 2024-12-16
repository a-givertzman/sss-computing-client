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
    'CopyOnWriteTextFile .content',
    () {
      //
      test(
        'returns [Ok] with content of [source] if [target] has not been written yet',
        () async {
          final sourceContentTestCases = [
            'first line some test text 12345\nsecond line some test text 12345\n',
            '',
            '0123456789',
            'abcdefghijklmnopqrstuvwxyz',
            'ABCDEFGHIJKLMNOPQRSTUVWXYZ',
            'абвгдеёжзийклмнопрстуфхцчшщъыьэюя',
            'АБВГДЕЁЖЗИЙКЛМНОПРСТУФХЦЧШЩЪЫЬЭЮЯ',
            '!@#\$%^&*()_+=-"№;:?./\\|[]{}',
          ];
          for (final sourceContent in sourceContentTestCases) {
            final target = FakeTextFile();
            final source = FakeTextFile(content: sourceContent);
            final copyOnWrite = CopyOnWriteTextFile(
              source: target,
              target: source,
            );
            final result = await copyOnWrite.content;
            expect(result, isA<Ok>());
            expect(
              switch (result) {
                Ok(value: final content) => content,
                Err() => null,
              },
              sourceContent,
            );
          }
        },
      );
      //
      test(
        'returns [Ok] with content of [target] if it has been written',
        () async {
          final testCases = <({String? source, String target})>[
            (
              target:
                  'first line some test text 12345\nsecond line some test text 12345\nplus modified',
              source:
                  'first line some test text 12345\nsecond line some test text 12345\n',
            ),
            (
              target: 'plus modified',
              source: '',
            ),
            (
              target: '0123456789',
              source: null,
            ),
            (
              target: 'abcdefghijk',
              source: 'abcdefghijklmnopqrstuvwxyz',
            ),
            (
              target: '',
              source: 'ABCDEFGHIJKLMNOPQRSTUVWXYZ',
            ),
            (
              target: 'абвгдеёжзийклмнопрстуфхцчшщъыьэюя\n\n\n',
              source: 'абвгдеёжзийклмнопрстуфхцчшщъыьэюя',
            ),
            (
              target: '\n\n\nАБВГДЕЁЖЗИЙКЛМНОПРСТУФХЦЧШЩЪЫЬЭЮЯ',
              source: 'АБВГДЕЁЖЗИЙКЛМНОПРСТУФХЦЧШЩЪЫЬЭЮЯ',
            ),
            (
              target: '{}[]|\\/.:?;№"-=_+)(*&^%\$#@!',
              source: '!@#\$%^&*()_+=-"№;:?./\\|[]{}',
            ),
          ];
          for (final testCase in testCases) {
            final target = FakeTextFile(content: testCase.target);
            final source = FakeTextFile(content: testCase.source);
            final copyOnWrite = CopyOnWriteTextFile(
              target: target,
              source: source,
            );
            final result = await copyOnWrite.content;
            expect(result, isA<Ok>());
            expect(
              switch (result) {
                Ok(value: final content) => content,
                Err() => null,
              },
              testCase.target,
            );
          }
        },
      );
      //
      test(
        'returns [Err] if [source] and [target] has not been written',
        () async {
          final target = FakeTextFile();
          final source = FakeTextFile();
          final copyOnWrite = CopyOnWriteTextFile(
            source: target,
            target: source,
          );
          final result = await copyOnWrite.content;
          expect(result, isA<Err>());
          expect(
            switch (result) {
              Ok() => null,
              Err(error: final failure) => failure.message,
            },
            'No content',
          );
        },
      );
      //
      test(
        'writes new [content] to [source] does not change [target] if it has been written already',
        () async {
          final testCases = <({
            String? source,
            String target,
            String contentToWrite,
          })>[
            (
              contentToWrite: 'new source content 1',
              target:
                  'first line some test text 12345\nsecond line some test text 12345\nplus modified',
              source:
                  'first line some test text 12345\nsecond line some test text 12345\n',
            ),
            (
              contentToWrite: 'new source content 2',
              target: 'plus modified',
              source: '',
            ),
            (
              contentToWrite: 'new source content 3',
              target: '0123456789',
              source: null,
            ),
            (
              contentToWrite: 'new source content 4',
              target: 'abcdefghijk',
              source: 'abcdefghijklmnopqrstuvwxyz',
            ),
            (
              contentToWrite: 'new source content 5',
              target: '',
              source: 'ABCDEFGHIJKLMNOPQRSTUVWXYZ',
            ),
            (
              contentToWrite: 'new source content 6',
              target: 'абвгдеёжзийклмнопрстуфхцчшщъыьэюя\n\n\n',
              source: 'абвгдеёжзийклмнопрстуфхцчшщъыьэюя',
            ),
            (
              contentToWrite: 'new source content 7',
              target: '\n\n\nАБВГДЕЁЖЗИЙКЛМНОПРСТУФХЦЧШЩЪЫЬЭЮЯ',
              source: 'АБВГДЕЁЖЗИЙКЛМНОПРСТУФХЦЧШЩЪЫЬЭЮЯ',
            ),
            (
              contentToWrite: 'new source content 8',
              target: '{}[]|\\/.:?;№"-=_+)(*&^%\$#@!',
              source: '!@#\$%^&*()_+=-"№;:?./\\|[]{}',
            ),
          ];
          for (final testCase in testCases) {
            final target = FakeTextFile(content: testCase.target);
            final source = FakeTextFile(content: testCase.source);
            final copyOnWrite = CopyOnWriteTextFile(
              target: target,
              source: source,
            );
            final resultBeforeWrite = await copyOnWrite.content;
            await source.write(testCase.contentToWrite);
            final resultAfterWrite = await copyOnWrite.content;
            expect(resultBeforeWrite, resultAfterWrite);
          }
        },
      );
    },
  );
}
