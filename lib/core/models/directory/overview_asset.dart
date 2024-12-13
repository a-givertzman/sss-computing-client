import 'package:collection/collection.dart';
///
/// A contract to find a overview asset.
abstract class OverviewAsset {
  ///
  /// finds a overview asset.
  String findPath();
}
///
/// [OverviewAsset] for markdown.
/// - finds an overview asset path from [_assets].
/// - the overview asset name matches the directory name.
/// - returns an empty string if not found.
final class MarkdownOverviewAsset implements OverviewAsset {
  ///
  final String _directoryName;
  ///
  final List<String> _assets;
  ///
  MarkdownOverviewAsset({
    required String directoryName,
    required List<String> assets,
  })  : _assets = assets,
        _directoryName = directoryName;
  //
  @override
  String findPath() {
    final pattern = RegExp(r'\b' + RegExp.escape(_directoryName) + r'\.md$');
    final firstLine =
        _assets.firstWhereOrNull((asset) => pattern.hasMatch(asset)) ?? '';
    return firstLine;
  }
}
