import 'package:hmi_core/hmi_core.dart';
import 'package:hmi_core/hmi_core_result_new.dart';

import 'package:sss_computing_client/core/models/subscripting/unicode.dart';

///  To handle subscript and superscript for [Text] using Unicode
class AppSubscripting {
  static const _log = Log('AppSubscripting');
  static final _map = <String, AppUnicode>{};

  /// initialize the map from json
  /// logs an error if failed
  static Future<void> initialize({JsonMap<dynamic>? jsonMap}) async {
    if (jsonMap != null) {
      await jsonMap.decoded.then((result) => switch (result) {
            Ok(value: final map) => _map.addAll(
                map.entries
                    .map((e) => {e.key: AppUnicode.fromMap(e.value)})
                    .reduce(
                      (prev, current) => {...prev, ...current},
                    ),
              ),
            Err() =>
              _log.warning('Failed to initialize app settings from file.'),
          });
    }
  }

  /// Returns the subscript of the given [str]
  /// if the [str] is not in the map, returns the [str]
  static String getSubscript(String str) {
    return str.split('').map((e) => _map[e]?.subs ?? e).join();
  }

  /// Returns the superscript of the given [str]
  /// if the [str] is not in the map, returns the [str]
  static String getSuperscript(String str) {
    return str.split('').map((e) => _map[e]?.sup ?? e).join();
  }

  /// Returns a localised maths expression of the given [str]
  /// This is for known maths expressions
  /// if the [str] is not in the map, returns the [str]
  static String getMathsExpression(String str) {
    switch (str) {
      case 't/m^3':
        return '[${const Localized('t/m').v}${getSuperscript('3')}]';
      case 't/s^-2':
        return '[${const Localized('t/s').v}${getSuperscript('-2')}]';
      default:
        return Localized(str).v;
    }
  }
}
