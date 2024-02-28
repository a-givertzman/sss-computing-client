import 'dart:async';
import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core.dart';
import 'package:sss_computing_client/presentation/core/theme/app_theme_switch.dart';
import 'package:sss_computing_client/app_widget.dart';

void main() async {
  Log.initialize(level: LogLevel.all);

  runZonedGuarded(
    () async {
      const Log('main').debug('Initializing the application...');
      WidgetsFlutterBinding.ensureInitialized();
      const Log('main').debug('Initializing settings of application...');
      await AppSettings.initialize(
        jsonMap: JsonMap.fromTextFile(
          const TextFile.asset(
            'assets/settings/app-settings.json',
          ),
        ),
      );
      const Log('main').debug('Creating App Theme switcher...');
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
