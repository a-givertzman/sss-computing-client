import 'package:hmi_core/hmi_core.dart';
///
/// A contract for localising the localised part title of the directory.
abstract class LocalizedTitle {
  ///
  /// The translated title.
  String get tr;
}
///
/// a class that returns the localised title for the accordion.
final class AccordionLocalizedTitle implements LocalizedTitle {
  final String title;
  AccordionLocalizedTitle(this.title);
  //
  @override
  String get tr => throw UnimplementedError();
}
///
/// Localises the camel case directory name
final class DocsLocalizedTitle implements LocalizedTitle {
  DocsLocalizedTitle({required this.dirName, required this.title});
  /// the camel case directory name
  final String dirName;
  /// the title of the document
  final String title;
  //
  @override
  String get tr => _localizeDirName();
  ///
  /// localises the directory name
  /// - the directory name is camel case and each part is localised deeply
  String _localizeDirName() {
    return dirName.replaceAllMapped(
      RegExp(r'([a-zA-Z]+)(\d+)(_?[a-zA-Z]+)'),
      (m) {
        final leading = m[1] ?? '';
        final digits = m[2] ?? '';
        //final title = m[3] ?? '';
        final formattedDigits = digits.isNotEmpty ? ' $digits. ' : ' ';
        return '${Localized(leading).v}$formattedDigits$title';
      },
    );
  }
}
