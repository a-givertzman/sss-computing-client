import 'package:hmi_core/hmi_core.dart';
import 'directory_info.dart';
///
/// Load the title of the directory
/// and create a new [DirectoryInfo] with the title.
abstract class DirectoryTitle {
  /// load the title of the directory from the given `assetPath`.
  Future<String> loadTitle(String assetPath);
}
///
/// Load the title
/// - Title is the first line of the file.
final class MarkdownDirectoryTitle implements DirectoryTitle {
  //
  @override
  Future<String> loadTitle(String assetPath) async {
    final res = await TextFile.asset(assetPath).content;
    switch (res) {
      case Ok(:final value):
        final title = value.split('\n').firstOrNull ?? '';
        return title.trim();
      case Err():
        return '';
    }
  }
}
