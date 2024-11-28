import 'package:flutter_test/flutter_test.dart';
import 'package:sss_computing_client/core/models/directory/directory_grouper.dart';

void main() {
  group('Assets Directory info grouper', () {
    late AssestDirectoryInfoGrouper grouper;
    late List<String> assets;
    setUp(() {
      grouper = AssestDirectoryInfoGrouper([
         'assets/docs/user-guide/ru/part05_loading/chapter01_ballast/section01_figure.md',
      ]);
      assets = [
        'assets/docs/user-guide/ru/part01_overview/part01_overview.md',
        //
        'assets/docs/user-guide/ru/part05_loading/chapter01_ballast/chapter01_ballast.md',
        'assets/docs/user-guide/ru/part05_loading/chapter01_ballast/section01_figure.md',
        'assets/docs/user-guide/ru/part05_loading/chapter01_ballast/section02_table.md',
        'assets/docs/user-guide/ru/part05_loading/chapter03_stores/chapter03_stores.md',
        'assets/docs/user-guide/ru/part05_loading/part05_loading.md',
      ];
    });
    test('Grouped tests', () {
      final infos = grouper.grouped();
      expect(infos.length, 1);
      expect(infos.first.subs.length, 1);

    });
    test('Grouped tests 2 subs deeper', () {
      grouper = AssestDirectoryInfoGrouper([
        'assets/docs/user-guide/ru/part01_overview/chapter01_programm/section03_programmFunction.md',
      ]);
      final infos = grouper.grouped();
      expect(infos.length, 1);
      expect(infos.first.subs.length, 1);
    });
    test('Group many', () {
      grouper = AssestDirectoryInfoGrouper(assets);
      final infos = grouper.grouped();
      expect(infos.length, 2);
      final part_05 = infos.last;
      expect(part_05.subs.length, 3);
    });
  });
}
