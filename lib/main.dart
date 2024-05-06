import 'dart:async';
import 'package:flutter/material.dart' hide Localizations;
import 'package:hmi_core/hmi_core.dart';
import 'package:sss_computing_client/presentation/core/theme/app_theme_switch.dart';
import 'package:sss_computing_client/app_widget.dart';
///
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Log.initialize(level: LogLevel.warning);
  await Localizations.initialize(
    AppLang.en,
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
  final appThemeSwitch = AppThemeSwitch();
  runZonedGuarded(
    () async {
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
