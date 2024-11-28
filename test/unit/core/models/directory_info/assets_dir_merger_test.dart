import 'package:flutter_test/flutter_test.dart';
import 'package:hmi_core/hmi_core.dart';
import 'package:sss_computing_client/core/models/directory/dir_merger.dart';
import 'package:sss_computing_client/core/models/directory/directory_grouper.dart';
import 'package:sss_computing_client/core/models/directory/directory_info.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  Log.initialize(level: LogLevel.debug);

  group('Assets Directory merger tests', () {
    late List<AssetsDirectoryInfo> dirs;
    setUp(() {
      dirs = [
        ...AssestDirectoryInfoGrouper([
          'assets/docs/user-guide/ru/part05_loading/chapter01_ballast/chapter01_ballast.md',
          'assets/docs/user-guide/ru/part05_loading/chapter01_ballast/section01_figure.md',
          'assets/docs/user-guide/ru/part05_loading/chapter01_ballast/section02_table.md',
          'assets/docs/user-guide/ru/part05_loading/chapter03_stores/chapter03_stores.md',
          'assets/docs/user-guide/ru/part05_loading/part05_loading.md',
        ]).grouped(),
      ];
    });
    test('Merge same directory', () {
      final merged = AssetsDirectoryInfoMerger(dirs).merge();
      expect(merged.length, 1);
      expect(merged.first.subs.length, 3);
    });
    test('Merge same directory with files only', () {
      final merged = AssetsDirectoryInfoMerger(AssestDirectoryInfoGrouper(
        [
          'assets/docs/user-guide/ru/part02_operatingProcedure/chapter01_hardware.md',
          'assets/docs/user-guide/ru/part02_operatingProcedure/chapter02_settingSetup.md',
          'assets/docs/user-guide/ru/part02_operatingProcedure/chapter03_installation.md',
        ],
      ).grouped())
          .merge();

      expect(merged.length, 1);
      expect(merged.first.subs.length, 3);
    });
    test('Merge different directory', () {
      final merged = AssetsDirectoryInfoMerger(
        [
          ...dirs,
          ...AssestDirectoryInfoGrouper(
            [
              'assets/docs/user-guide/ru/part02_operatingProcedure/chapter01_hardware.md',
              'assets/docs/user-guide/ru/part02_operatingProcedure/chapter02_settingSetup.md',
              'assets/docs/user-guide/ru/part02_operatingProcedure/chapter03_installation.md',
            ],
          ).grouped(),
        ],
      ).merge();
      // merged.forEach(print);
      expect(merged.length, 2);
    });
  });
}
