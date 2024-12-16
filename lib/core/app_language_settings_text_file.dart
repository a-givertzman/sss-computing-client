import 'package:hmi_core/hmi_core.dart';
import 'package:sss_computing_client/core/copy_on_write_text_file.dart';
///
/// [TextFile] that stores app language settings.
class AppLanguageSettingsTextFile implements TextFile {
  static const _filePath = 'localization.json';
  static const _assetPath = 'assets/settings/app-language-settings.json';
  final TextFile _file;
  ///
  /// Creates instance of [TextFile] that stores app language settings.
  const AppLanguageSettingsTextFile()
      : _file = const CopyOnWriteTextFile(
          source: TextFile.asset(_assetPath),
          target: TextFile.path(_filePath),
        );
  //
  @override
  Future<ResultF<String>> get content => _file.content;
  //
  @override
  Future<void> write(String content) => _file.write(content);
}
