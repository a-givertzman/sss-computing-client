import 'dart:async';
import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core.dart';
import 'package:sss_computing_client/core/models/calculation/calculation_status.dart';
import 'package:sss_computing_client/presentation/core/theme/app_theme_switch.dart';
import 'package:sss_computing_client/presentation/main/main_page.dart';
import 'package:window_manager/window_manager.dart';
///
class AppWidget extends StatefulWidget {
  final AppThemeSwitch _themeSwitch;
  ///
  const AppWidget({
    super.key,
    required AppThemeSwitch themeSwitch,
  }) : _themeSwitch = themeSwitch;
  ///
  @override
  State<AppWidget> createState() => _AppWidgetState(themeSwitch: _themeSwitch);
}
///
class _AppWidgetState extends State<AppWidget> {
  final AppThemeSwitch _themeSwitch;
  late final StreamController<DsDataPoint<bool>> _appRefreshController;
  late void Function() _fireRefreshEvent;
  late final CalculationStatus _calculationStatusNotifier;
  ///
  _AppWidgetState({
    required AppThemeSwitch themeSwitch,
  }) : _themeSwitch = themeSwitch;
  //
  @override
  void initState() {
    _themeSwitch.addListener(_themeSwitchListener);
    Future.delayed(
      Duration.zero,
      () async {
        await windowManager.ensureInitialized();
        windowManager.waitUntilReadyToShow(
          const WindowOptions(
            fullScreen: true,
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
    _appRefreshController = StreamController.broadcast();
    _fireRefreshEvent = () => _appRefreshController.add(
          DsDataPoint(
            type: DsDataType.bool,
            name: DsPointName('/refresh'),
            value: true,
            status: DsStatus.ok,
            timestamp: '',
            cot: DsCot.req,
          ),
        );
    _calculationStatusNotifier = CalculationStatus();
    super.initState();
  }
  //
  @override
  void dispose() {
    _themeSwitch.removeListener(_themeSwitchListener);
    super.dispose();
  }
  //
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: _themeSwitch.themeData,
      home: MainPage(
        appRefreshStream: _appRefreshController.stream,
        fireRefreshEvent: _fireRefreshEvent,
        calculationStatusNotifier: _calculationStatusNotifier,
      ),
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
}
