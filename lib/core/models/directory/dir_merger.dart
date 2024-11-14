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
    return dirs.fold(<AssetsDirectoryInfo>[], (e, dir) {
      final merged = e.firstWhereOrNull((e) => e.path == dir.path)?.merge(dir);
      if (merged == null) e.add(dir);
      return e;
    });
  }

  List<AssetsDirectoryInfo> _clean(List<AssetsDirectoryInfo> assets) {
    return assets
      ..removeWhere((e) {
        e.subs.removeWhere((e) => e.isEmpty);
        return e.isEmpty;
      });
  }
}
