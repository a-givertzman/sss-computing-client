import 'dart:async';
import 'package:flutter/material.dart' hide Localizations;
import 'package:hmi_core/hmi_core.dart';
import 'package:hmi_core/hmi_core_app_settings.dart';
import 'package:sss_computing_client/core/copy_on_write_text_file.dart';
import 'package:sss_computing_client/core/extensions/app_settings.dart';
import 'package:sss_computing_client/core/extensions/localizations.dart';
import 'package:sss_computing_client/presentation/core/theme/app_theme_switch.dart';
import 'package:sss_computing_client/app_widget.dart';
///
void main() async {
  Log.initialize(level: LogLevel.error);
  runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();
      const defaultAppLang = AppLang.ru;
      await AppSettings().initializeFromTextFiles([
        const TextFile.asset('assets/settings/app-settings.json'),
        const TextFile.asset('assets/settings/api-server-settings.json'),
        const TextFile.asset('assets/settings/ship-settings.json'),
        const CopyOnWriteTextFile(
          target: TextFile.path('localization-settings.json'),
          source: TextFile.asset('assets/settings/localization-settings.json'),
        ),
      ]);
      await Localizations().initializeFromTextFiles(
        switch (const Setting('currentLocalization').toString()) {
          'en' => AppLang.en,
          'ru' => AppLang.ru,
          _ => defaultAppLang,
        },
        [
          const TextFile.asset('assets/translations/ui-translations.json'),
          const TextFile.asset('assets/translations/c.json'),
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
