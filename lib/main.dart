import 'dart:async';
import 'package:flutter/material.dart' hide Localizations;
import 'package:hmi_core/hmi_core.dart';
import 'package:sss_computing_client/core/models/subscripting/subscripting.dart';
import 'package:sss_computing_client/presentation/core/theme/app_theme_switch.dart';
import 'package:sss_computing_client/app_widget.dart';

///
void main() async {
  Log.initialize(level: LogLevel.error);
  runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();
      await Localizations.initialize(
        AppLang.ru,
        jsonMap: JsonMap.fromTextFile(
          const TextFile.asset('assets/translations/translations.json'),
        ),
      );
      await AppSettings.initialize(
        jsonMap: JsonMap.fromTextFile(
          const TextFile.asset(
            'assets/settings/app-settings.json',
          ),
        ),
      );
      await AppSubscripting.initialize(
        jsonMap: JsonMap.fromTextFile(
          const TextFile.asset(
            'assets/unicodes/unicodes.json',
          ),
        ),
      );
      final appThemeSwitch = AppThemeSwitch();
      runApp(AppWidget(themeSwitch: appThemeSwitch));
    },
    (error, stackTrace) {
      final trace = stackTrace.toString().isEmpty
          ? StackTrace.current
          : stackTrace.toString();
      const Log('main').error('message: $error\nstackTrace: $trace');
    },
  );
}
