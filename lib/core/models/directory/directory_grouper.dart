import 'package:flutter/foundation.dart';

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
    List<AssetsDirectoryInfo> directories = [];
    List<String> pathComponents =
        path.replaceFirst('$parentPath/', '').split('/');

    for (int i = 0; i < pathComponents.length - 1; i++) {
      String directoryPath =
          '$parentPath/${pathComponents.sublist(0, i + 1).join('/')}';
      String asset = '$directoryPath/${pathComponents[i + 1]}';
      final item = AssetsDirectoryInfo(
        pathComponents[i],
        directoryPath,
        assets: asset.endsWith('.md') ? [asset] : [],
      );
      if (directories.isEmpty) {
        directories.add(item);
      } else {
        directories.last.addSub(item);
      }
    }
    return directories;
  }
}
