import 'package:flutter_test/flutter_test.dart';
import 'package:sss_computing_client/core/models/accordion/localized_title.dart';

void main() {
  group('Docs Tests', () {
    test('Should localise a simple camel case string', () {
      final localised =
          DocsLocalizedTitle(dirName: 'test01_okay', title: 'Okay').tr;
      expect(localised, 'test 01. Okay');
    });
    test('Should localise a camel case string without digits', () {
      final localised =
          DocsLocalizedTitle(dirName: 'test_okay', title: 'Okay').tr;
      expect(localised, 'test_okay');
    });
  });
}
