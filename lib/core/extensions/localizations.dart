import 'package:hmi_core/hmi_core.dart';
///
/// Extension methods for [Localizations]
extension LocalizationsExtension on Localizations {
  ///
  /// Initialize [Localizations] with a given [appLang] from [textFiles].
  Future<void> initializeFromTextFiles(
    AppLang appLang,
    List<TextFile> textFiles,
  ) async {
    await Future.wait(textFiles.map(
      (textFile) => Localizations.initialize(
        appLang,
        jsonMap: JsonMap.fromTextFile(textFile),
      ),
    ));
  }
}
