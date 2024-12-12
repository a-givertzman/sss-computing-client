import 'package:flutter_test/flutter_test.dart';
import 'package:sss_computing_client/core/models/directory/overview_asset.dart';

void main() {
  group('MarkdownOverviewAsset', () {
    test('should correctly handle empty assets', () {
      final overviewAsset = MarkdownOverviewAsset(
        assets: [],
        directoryName: 'part01_overview',
      );
      expect(overviewAsset.findPath(), '');
    });
    test('should correctly find overview asset', () {
      final assets = [
        'assets/docs/user-guide/ru/part01_overview/part01_overview.md',
        'assets/docs/user-guide/ru/part01_overview/chapter02_ship/section02_documentation.md',
        'assets/docs/user-guide/ru/part01_overview/chapter02_ship/chapter02_ship.md',
      ];
      final overviewAsset = MarkdownOverviewAsset(
        assets: assets,
        directoryName: 'part01_overview',
      );
      expect(
        overviewAsset.findPath(),
        'assets/docs/user-guide/ru/part01_overview/part01_overview.md',
      );
    });
  });
}
