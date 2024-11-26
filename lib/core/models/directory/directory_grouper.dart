import 'package:sss_computing_client/core/extensions/lists.dart';
import 'package:sss_computing_client/core/models/directory/dir_merger.dart';

import 'package:sss_computing_client/core/models/directory/directory_info.dart';

/// Directory grouper
abstract interface class DirectoryGrouper {
  List<DirectoryInfo> grouped();
}

/// Groups assets directories
final class AssestDirectoryInfoGrouper implements DirectoryGrouper {
  final List<String> paths;
  final String parentPath;
  AssestDirectoryInfoGrouper(
    this.paths, {
    this.parentPath = 'assets/docs/user-guide/ru',
  });

  @override
  List<AssetsDirectoryInfo> grouped() {
    return AssetsDirectoryInfoMerger(
      paths.map(_group).reduce((e, a) => [...e, ...a]),
    ).merge();
  }

  List<AssetsDirectoryInfo> _group(String path) {
    final List<AssetsDirectoryInfo> directories = [];
    for (var path in paths) {
      final directory = _createDirectory(path, parentPath);
      _addDirectoryRecursively(directory, directories);
    }

    return directories;
  }

  AssetsDirectoryInfo _createDirectory(String path, String parentPath) {
    List<String> pathComponents =
        path.replaceFirst('$parentPath/', '').split('/');
    final subDirectories = pathComponents.sublist(1);
    final directoryName = (pathComponents.isEmpty ? path : pathComponents.first)
        .replaceAll(RegExp(r'\.[^.]+$'), '');
    final directoryPath = '$parentPath/$directoryName';

    final assets = <String>[];
    final subs = <AssetsDirectoryInfo>[];
    if (subDirectories.isNotEmpty) {
      final subdirectory = _createDirectory(path, directoryPath);
      subs.add(subdirectory);
    } else {
      assets.add(path);
    }

    return AssetsDirectoryInfo(
      directoryName,
      directoryPath,
      assets: assets,
      subs: subs,
    );
  }

  /// Add directory down the tree recursively
  ///Recursively add directories and assets to maintain the correct structure
  _addDirectoryRecursively(
    AssetsDirectoryInfo directory,
    List<AssetsDirectoryInfo> directories,
  ) {
    final existing = directories.findByName(directory.name);
    if (existing != null) {
      existing.merge(directory);
    } else {
      directories.add(directory);
    }
  }
}
