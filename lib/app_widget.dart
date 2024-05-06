import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core_app_settings.dart';
import 'package:sss_computing_client/presentation/core/theme/app_theme_switch.dart';
import 'package:sss_computing_client/presentation/main/main_page.dart';
import 'package:sss_computing_client/presentation/stability/stability_page.dart';
import 'package:window_manager/window_manager.dart';
///
final appRoutes = {
  MainPage.routeName: (BuildContext context) => const MainPage(),
  StabilityPage.routeName: (BuildContext context) => const StabilityPage(),
};
///
class AppWidget extends StatefulWidget {
  final AppThemeSwitch _themeSwitch;
  ///
  const AppWidget({
    super.key,
    required AppThemeSwitch themeSwitch,
  }) : _themeSwitch = themeSwitch;
  //
  @override
  State<AppWidget> createState() => _AppWidgetState();
}
///
class _AppWidgetState extends State<AppWidget> {
  //
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
          ),
          () async {
            await windowManager.show();
            await windowManager.focus();
          },
        );
      },
    );
  }
  //
  @override
  void dispose() {
    widget._themeSwitch.removeListener(_themeSwitchListener);
    super.dispose();
  }
  ///
  void _themeSwitchListener() {
    if (mounted) {
      setState(() {
        return;
      });
    }
  }
  //
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: appRoutes,
      initialRoute: MainPage.routeName,
      theme: widget._themeSwitch.themeData,
    );
  }
}
