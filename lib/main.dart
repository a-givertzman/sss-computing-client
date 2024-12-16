import 'dart:async';
import 'package:flutter/material.dart' hide Localizations;
import 'package:hmi_core/hmi_core.dart';
import 'package:hmi_core/hmi_core_app_settings.dart';
import 'package:sss_computing_client/core/app_language_settings_text_file.dart';
import 'package:sss_computing_client/core/extensions/app_settings.dart';
import 'package:sss_computing_client/core/extensions/localizations.dart';
import 'package:sss_computing_client/presentation/core/theme/app_theme_switch.dart';
import 'package:sss_computing_client/app_widget.dart';
///
void main() async {
  Log.initialize(level: LogLevel.error);
  runZonedGuarded(
    () async {
      const defaultAppLang = AppLang.ru;
      WidgetsFlutterBinding.ensureInitialized();
      await AppSettings().initializeFromTextFiles([
        const TextFile.asset('assets/settings/app-settings.json'),
        const TextFile.asset('assets/settings/api-server-settings.json'),
        const TextFile.asset('assets/settings/ship-settings.json'),
        const AppLanguageSettingsTextFile(),
      ]);
      await Localizations().initializeFromTextFiles(
        switch (const Setting('currentLanguage').toString()) {
          'en' => AppLang.en,
          'ru' => AppLang.ru,
          _ => defaultAppLang,
        },
        [
          const TextFile.asset('assets/translations/ui-translations.json'),
          const TextFile.asset('assets/translations/ship-translations.json'),
        ],
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
