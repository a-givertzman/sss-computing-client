import 'package:hmi_core/hmi_core.dart';
import 'package:sss_computing_client/core/models/accordion/localized_title.dart';
import 'package:sss_computing_client/core/models/directory/dir_merger.dart';
import 'package:sss_computing_client/core/models/directory/directory_title.dart';
import 'package:sss_computing_client/core/models/directory/overview_asset.dart';
import 'directory_grouper.dart';
import 'directory_info.dart';
///
/// A contract for loading a directory info
abstract class LoadDirectoryInfo {
  /// Load a directory info
  /// - Returns a list of [DirectoryInfo] with:
  /// - grouped directories
  /// - merged directories
  /// - loaded titles
  Future<ResultF<List<DirectoryInfo>>> load();
}
///
/// Load markdown directory and return a list of [DirectoryInfo] with:
/// - grouped directories
/// - merged directories
/// - localised titles
final class LoadMarkdownInfo implements LoadDirectoryInfo {
  final Future<ResultF<List<String>>> _assets;
  LoadMarkdownInfo(this._assets);
  @override
  Future<ResultF<List<AssetsDirectoryInfo>>> load() async {
    final res = await _assets;
    switch (res) {
      case Ok(:final value):
        final grouped = AssestDirectoryInfoGrouper(value).grouped();
        final items = AssetsDirectoryInfoMerger(grouped).merge();
        return Ok(await _loadTitles(items));
      case Err():
        return const Ok([]);
    }
  }
  Future<List<AssetsDirectoryInfo>> _loadTitles(
    List<AssetsDirectoryInfo> items,
  ) async {
    return await Future.wait(items.map(_loadTitle));
  }
  Future<AssetsDirectoryInfo> _loadTitle(AssetsDirectoryInfo info) async {
    final overviewPath = MarkdownOverviewAsset(
      directoryName: info.name,
      assets: info.allAssets,
    ).findPath();
    final title = switch (overviewPath.isEmpty) {
      false => await MarkdownDirectoryTitle().loadTitle(overviewPath),
      _ => info.name
    };
    final localisedTitle = DocsLocalizedTitle(
      dirName: info.name,
      title: CleanMarkdownTitle(title).clean(),
    ).tr;
    return info.copyWith(
      titleError: title == info.name,
      title: localisedTitle,
      subs: await _loadTitles(info.subs),
    );
  }
}
///
/// Clean the markdown overview.
/// - removes special characters from the overview.
/// - removes empty lines from the overview.
/// - returns the cleaned overview.
final class CleanMarkdownTitle {
  final String _title;
  CleanMarkdownTitle(this._title);
  /// Clean the markdown overview.
  /// - removes special characters from the overview.
  String clean() {
    //final headerPattern = RegExp(r'^\#+\s*(.*)');
    //final pattern = RegExp(r'\#+');
    return _title
        .trim()
        //.replaceAll(headerPattern, '')
        .replaceAll('#', '')
        .trim();
  }
}
