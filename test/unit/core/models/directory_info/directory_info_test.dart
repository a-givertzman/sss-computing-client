import 'package:flutter_test/flutter_test.dart';
import 'package:sss_computing_client/core/models/directory/directory_info.dart';

void main() {
  group('Assets Directory info', () {
    late AssetsDirectoryInfo dir, dir2;

    setUp(() {
      dir2 = AssetsDirectoryInfo(
        'part01_overview',
        'part01_overview',
        assets: [
          'assets/docs/user-guide/ru/part01_overview/part01_overview.md',
        ],
        subs: [
          AssetsDirectoryInfo(
            'chapter03_programmFunction',
            'part01_overview/chapter03_programmFunction',
            subs: [],
            assets: [
              'assets/docs/user-guide/ru/part01_overview/chapter03_programmFunction/chapter03_programmFunction.md',
            ],
          ),
          AssetsDirectoryInfo(
            'chapter01_programm',
            'part01_overview/chapter01_programmInfo',
            subs: [],
            assets: [
              'assets/docs/user-guide/ru/part01_overview/chapter01_programmInfo/chapter01_programmInfo.md'
            ],
          ),
        ],
      );
      dir = AssetsDirectoryInfo(
        'part01_overview',
        'part01_overview',
        assets: [
          'assets/docs/user-guide/ru/part01_overview/part01_overview.md',
        ],
        subs: [
          AssetsDirectoryInfo(
            'chapter01_programmInfo',
            'part01_overview/chapter01_programmInfo',
            subs: [],
            assets: [
              'assets/docs/user-guide/ru/part01_overview/chapter01_programmInfo/chapter01_programmInfo.md',
            ],
          ),
          AssetsDirectoryInfo(
            'chapter02_programmPurpose',
            'part01_overview/chapter02_programmPurpose',
            subs: [],
            assets: [
              'assets/docs/user-guide/ru/part01_overview/chapter02_programmPurpose/chapter02_programmPurpose.md',
            ],
          ),
        ],
      );
    });
    test('merge Dir2 and Dir', () {
      final merged = dir2.merge(dir);
      expect(merged, true);
      expect(dir2.assets.length, 1);
      expect(dir2.subs.length, 3);
    });
    test('merge dir and dir2', () {
      final merged = dir.merge(dir2);
      expect(merged, true);
      expect(dir.assets.length, 1);
      expect(dir.subs.length, 3);
    });
  });
}
