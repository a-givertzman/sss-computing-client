import 'package:sss_computing_client/core/extensions/lists.dart';
import 'package:sss_computing_client/core/models/directory/directory_info.dart';
///
/// Merge similar directories to one.
/// - Used with [DirectoryGrouper].
abstract interface class DirectoryInfoMerger {
  /// List of directories to merge.
  List<DirectoryInfo> get dirs;
  /// Merge similar directories to one and return the result
  List<DirectoryInfo> merge();
}
///
/// Merge similar [AssetsDirectoryInfo] directories into one.
/// - Merge assets if they are the same directory.
class AssetsDirectoryInfoMerger implements DirectoryInfoMerger {
  AssetsDirectoryInfoMerger(this.dirs);
  //
  @override
  final List<AssetsDirectoryInfo> dirs;
  //
  @override
  List<AssetsDirectoryInfo> merge() {
    List<AssetsDirectoryInfo> mergedDirs = [];
    for (var dir in dirs) {
      final existingDir =
          mergedDirs.firstWhereOrNull((existing) => existing.path == dir.path);
      if (existingDir == null) {
        mergedDirs.add(dir);
      } else {
        existingDir.merge(dir);
      }
    }
    return _clean(mergedDirs);
  }
  /// Clean subdirectories
  List<AssetsDirectoryInfo> _clean(List<AssetsDirectoryInfo> assets) {
    return assets.where((dir) {
      dir.subs.removeWhere((subDir) => subDir.isEmpty);
      return !dir.isEmpty;
    }).toList();
  }
}
