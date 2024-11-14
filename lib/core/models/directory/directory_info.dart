import 'package:sss_computing_client/core/extensions/lists.dart';

/// A directory info with subdirectories
abstract interface class DirectoryInfo {
  /// Name of the directory
  String get name;

  /// Path to the directory
  String get path;

  /// Subdirectories of this directory
  List<DirectoryInfo> get subs;

  /// includes only assets from subdirectories and themselves
  List<String> get subsAssets;

  /// includes all assets from subdirectories and itself
  List<String> get allAssets;
}

/// Directory info with subdirectories and assets
class AssetsDirectoryInfo implements DirectoryInfo {
  @override
  final String name;
  @override
  final String path;
  final List<String> assets;
  @override
  final List<AssetsDirectoryInfo> subs;

  AssetsDirectoryInfo(
    this.name,
    this.path, {
    List<String>? assets,
    List<AssetsDirectoryInfo>? subs,
  })  : assets = assets ?? [],
        subs = subs ?? [];

  addSub(AssetsDirectoryInfo sub) {
    subs.add(sub);
  }

  /// check if the directory is empty
  bool get isEmpty => subs.isEmpty && assets.isEmpty;

  bool merge(AssetsDirectoryInfo dir) {
    if (name == dir.name) {
      ///
      assets.addAllIfAbsent(dir.assets);

      ///
      final mergedSubs = [
        ...subs,
        ...dir.subs,
      ].fold(<AssetsDirectoryInfo>[], (e, dir) {
        if (!e.any((e) => e.name == dir.name)) e.add(dir);
        return e;
      });
      subs.clear();
      subs.addAll(mergedSubs);

      return true;
    }
    return false;
  }

  @override
  String toString() {
    return 'DirectoryInfo(name: $name, path: $path, assets: $assets, subs: $subs)';
  }

  @override
  List<String> get subsAssets => subs.fold(<String>[], (e, dir) {
        e.addAll(dir.allAssets);
        return e;
      });

  @override
  List<String> get allAssets => [...assets, ...subsAssets];
}
