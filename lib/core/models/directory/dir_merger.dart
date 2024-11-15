import 'package:sss_computing_client/core/extensions/lists.dart';
import 'package:sss_computing_client/core/models/directory/directory_info.dart';

/// Merge similar directories to one
abstract interface class DirectoryInfoMerger {
  List<DirectoryInfo> get dirs;

  /// Merge similar directories to one and return the result
  List<DirectoryInfo> merge();
}

class AssetsDirectoryInfoMerger implements DirectoryInfoMerger {
  @override
  final List<AssetsDirectoryInfo> dirs;
  AssetsDirectoryInfoMerger(this.dirs);
  @override
  List<AssetsDirectoryInfo> merge() {
    List<AssetsDirectoryInfo> mergedDirs = [];
    for (var dir in dirs) {
      final existingDir =
          mergedDirs.firstWhereOrNull((existing) => existing.name == dir.name);

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
