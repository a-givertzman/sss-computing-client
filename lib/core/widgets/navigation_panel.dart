import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core.dart';
import 'package:sss_computing_client/core/widgets/error_message_widget.dart';
import 'package:sss_computing_client/presentation/main/main_page.dart';
import 'package:sss_computing_client/presentation/strength/strength_page.dart';
///
/// App main navigation widget.
class NavigationPanel extends StatelessWidget {
  final int _selectedPageIndex;
  final Stream<DsDataPoint<bool>> _appRefreshStream;
  final void Function() _fireRefreshEvent;
  ///
  const NavigationPanel({
    super.key,
    required int selectedPageIndex,
    required Stream<DsDataPoint<bool>> appRefreshStream,
    required void Function() fireRefreshEvent,
  })  : _selectedPageIndex = selectedPageIndex,
        _appRefreshStream = appRefreshStream,
        _fireRefreshEvent = fireRefreshEvent;
  //
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Hero(
      tag: 'navigation_panel',
      child: NavigationRail(
        labelType: NavigationRailLabelType.all,
        useIndicator: true,
        indicatorColor: theme.colorScheme.primary,
        selectedIconTheme: IconThemeData(
          color: theme.colorScheme.onPrimary,
        ),
        selectedLabelTextStyle: TextStyle(
          color: theme.colorScheme.primary,
        ),
        unselectedIconTheme: IconThemeData(
          color: theme.colorScheme.primary,
        ),
        unselectedLabelTextStyle: TextStyle(
          color: theme.colorScheme.primary,
        ),
        destinations: [
          NavigationRailDestination(
            icon: const Icon(Icons.home_outlined),
            selectedIcon: const Icon(Icons.home),
            label: Text(const Localized('Main').v),
          ),
          NavigationRailDestination(
            icon: const Icon(Icons.analytics_outlined),
            selectedIcon: const Icon(Icons.analytics),
            label: Text(const Localized('Strength').v),
          ),
        ],
        selectedIndex: _selectedPageIndex,
        onDestinationSelected: (value) => switch (value) {
          0 => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => MainPage(
                  appRefreshStream: _appRefreshStream,
                  fireRefreshEvent: _fireRefreshEvent,
                ),
                settings: const RouteSettings(name: "/MainPage"),
              ),
            ),
          1 => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => StrengthPage(
                  appRefreshStream: _appRefreshStream,
                  fireRefreshEvent: _fireRefreshEvent,
                ),
                settings: const RouteSettings(name: "/StrengthPage"),
              ),
            ),
          _ => Scaffold(
              body: ErrorMessageWidget(
                message: const Localized('Page not found').v,
              ),
            ),
        },
      ),
    );
  }
}
