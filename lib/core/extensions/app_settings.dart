import 'package:hmi_core/hmi_core.dart';
///
/// Extension methods for [AppSettings]
extension AppSettingsExtension on AppSettings {
  ///
  /// Initialize [AppSettings] from [textFiles].
  Future<void> initializeFromTextFiles(List<TextFile> textFiles) async {
    await Future.wait(textFiles.map(
      (textFile) => AppSettings.initialize(
        jsonMap: JsonMap.fromTextFile(textFile),
      ),
    ));
  }
}
