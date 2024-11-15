import 'package:flutter/foundation.dart';
import 'package:sss_computing_client/core/extensions/lists.dart';

import 'package:sss_computing_client/core/models/directory/directory_info.dart';

/// Directory grouper
abstract interface class DirectoryGrouper {
  List<DirectoryInfo> grouped();
}

/// Groups assets directories
class AssestDirectoryInfoGrouper implements DirectoryGrouper {
  final List<String> paths;
  final String parentPath;
  AssestDirectoryInfoGrouper(
    this.paths, {
    this.parentPath = 'assets/docs/user-guide/ru',
  });

  @override
  List<AssetsDirectoryInfo> grouped() {
    return paths.map(group).reduce((e, a) => [...e, ...a]);
  }

  @protected
  List<AssetsDirectoryInfo> group(String path) {
    final List<AssetsDirectoryInfo> directories = [];
    for (var path in paths) {
      List<String> pathComponents =
          path.replaceFirst('$parentPath/', '').split('/');
      _addDirectoryRecursively(directories, pathComponents,path);
    }

    return directories;
  }

  /// Recursively add directories and assets to maintain the correct structure
  void _addDirectoryRecursively(
    List<AssetsDirectoryInfo> directories,
    List<String> pathComponents,String path,
  ) {
    if (pathComponents.isEmpty) return;

    String currentDirName = pathComponents.first.replaceAll(RegExp(r'\.[^.]+$'), '');
    String currentPath =
        '$parentPath/${pathComponents.sublist(0, pathComponents.length - 1).join('/')}';

    /// The directory at the current level
    var directory =
        directories.firstWhereOrNull((dir) => dir.path == currentPath);

    if (directory == null) {
      directory = AssetsDirectoryInfo(currentDirName, currentPath);
      directories.add(directory);
    }

    // If there are still more subdirectories, recursively go deeper
    if (pathComponents.length > 1) {
      // Remove the first component and go deeper into the subdirectories
      _addDirectoryRecursively(directory.subs, pathComponents.sublist(1), path);
    } else {
      // If it's the last component, we add the asset here
      directory.assets.add(path);
    }
  }
}
