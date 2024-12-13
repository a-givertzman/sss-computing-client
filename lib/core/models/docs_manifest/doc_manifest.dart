// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/services.dart';
import 'package:hmi_core/hmi_core.dart';
import 'package:sss_computing_client/core/extensions/lists.dart';
import 'package:sss_computing_client/core/models/directory/directory_info.dart';
///
/// Type alias for directory item (`MapEntry<String, List<String>>`)
typedef DirectoryItem = MapEntry<String, List<String>>;
/// A list of ``DirectoryItem``
typedef DirectoryItems = List<DirectoryItem>;
/// extension for [List<DirectoryItem>]
extension DirectoryItemExt on List<DirectoryItem> {
  /// finds a [DirectoryItem] by the given `path`
  DirectoryItem? findByPath(String path) {
    return firstWhereOrNull((e) => e.value.contains(path));
  }
}
///
/// a contract to load assets.
abstract interface class DocumentManifest<T> {
  /// Path to the manifest e.g "assets/docs/user-guide/ru"
  String get path;
  /// Load all assets from the manifest and filter by path
  Future<ResultF<List<String>>> loadAssets();
}
///
/// Handle asset loading for markdown docs.
class MarkdownManifest implements DocumentManifest<AssetsDirectoryInfo> {
  @override
  final String path;
  //
  MarkdownManifest(this.path);
  @override
  Future<ResultF<List<String>>> loadAssets() async {
    return await AssetManifest.loadFromAssetBundle(rootBundle)
        .then((e) => e
            .listAssets()
            .where((e) => e.startsWith(path) && e.endsWith('.md'))
            .toList())
        .then((e) => Ok(e));
  }
}
