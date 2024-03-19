import 'package:ext_rw/ext_rw.dart';
import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core_app_settings.dart';
import 'package:sss_computing_client/models/cargos/cargos.dart';
import 'package:sss_computing_client/presentation/cargo_details/cargo_details_page.dart';
import 'package:sss_computing_client/presentation/core/theme/app_theme_switch.dart';
import 'package:sss_computing_client/presentation/strength/strength_page.dart';
import 'package:window_manager/window_manager.dart';

class AppWidget extends StatefulWidget {
  final AppThemeSwitch _themeSwitch;
  const AppWidget({
    super.key,
    required AppThemeSwitch themeSwitch,
  }) : _themeSwitch = themeSwitch;

  @override
  State<AppWidget> createState() => _AppWidgetState();
}

class _AppWidgetState extends State<AppWidget> {
  @override
  void dispose() {
    widget._themeSwitch.removeListener(_themeSwitchListener);
    super.dispose();
  }

  ///
  @override
  void initState() {
    super.initState();
    widget._themeSwitch.addListener(_themeSwitchListener);
    Future.delayed(
      Duration.zero,
      () async {
        await windowManager.ensureInitialized();
        windowManager.waitUntilReadyToShow(
          WindowOptions(
            size: Size(
              const Setting('displaySizeWidth').toDouble,
              const Setting('displaySizeHeight').toDouble,
            ),
            center: true,
            backgroundColor: Colors.transparent,
            skipTaskbar: false,
            // titleBarStyle: TitleBarStyle.hidden,
          ),
          () async {
            await windowManager.show();
            await windowManager.focus();
          },
        );
      },
    );
  }

  ///
  void _themeSwitchListener() {
    if (mounted) {
      setState(() {
        return;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: widget._themeSwitch.themeData,
      home: Scaffold(
        body: CargoDetailsPage(
          cargos: DbCargos(
            dbName: 'sss-computing',
            apiAddress: ApiAddress.localhost(port: 8080),
          ),
        ),
      ),
    );
  }
}
