import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core.dart';
import 'package:hmi_core/hmi_core_app_settings.dart';
import 'package:sss_computing_client/core/models/calculation/calculation_status.dart';
import 'package:sss_computing_client/core/widgets/calculation/run_calculation_button.dart';
import 'package:sss_computing_client/core/widgets/error_message_widget.dart';
import 'package:sss_computing_client/presentation/drafts/drafts_page.dart';
import 'package:sss_computing_client/presentation/loading/loading_page.dart';
import 'package:sss_computing_client/presentation/main/main_page.dart';
import 'package:sss_computing_client/presentation/stability/stability_page.dart';
import 'package:sss_computing_client/presentation/strength/strength_page.dart';
///
/// App main navigation widget.
class NavigationPanel extends StatelessWidget {
  final int? _selectedPageIndex;
  final Stream<DsDataPoint<bool>> _appRefreshStream;
  final void Function() _fireRefreshEvent;
  final CalculationStatus _calculationStatusNotifier;
  ///
  /// Creates app main navigation widget.
  const NavigationPanel({
    super.key,
    required int? selectedPageIndex,
    required Stream<DsDataPoint<bool>> appRefreshStream,
    required void Function() fireRefreshEvent,
    required CalculationStatus calculationStatusNotifier,
  })  : _selectedPageIndex = selectedPageIndex,
        _appRefreshStream = appRefreshStream,
        _fireRefreshEvent = fireRefreshEvent,
        _calculationStatusNotifier = calculationStatusNotifier;
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
        leading: Padding(
          padding: EdgeInsets.all(const Setting('blockPadding').toDouble),
          child: RunCalculationButton(
            fireRefreshEvent: _fireRefreshEvent,
            calculationStatusNotifier: _calculationStatusNotifier,
          ),
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
          NavigationRailDestination(
            icon: const Icon(Icons.video_stable_outlined),
            selectedIcon: const Icon(Icons.video_stable),
            label: Text(const Localized('Stability').v),
          ),
          NavigationRailDestination(
            icon: const RotatedBox(
              quarterTurns: 1,
              child: Icon(Icons.straighten_outlined),
            ),
            selectedIcon: const RotatedBox(
              quarterTurns: 1,
              child: Icon(Icons.straighten_outlined),
            ),
            label: Text(const Localized('Drafts').v),
          ),
          NavigationRailDestination(
            icon: const Icon(Icons.pallet),
            selectedIcon: const Icon(Icons.pallet),
            label: Text(const Localized('Loading').v),
          ),
        ],
        selectedIndex: _selectedPageIndex,
        onDestinationSelected: (index) {
          if (index == _selectedPageIndex) return;
          switch (index) {
            case 0:
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => MainPage(
                    appRefreshStream: _appRefreshStream,
                    fireRefreshEvent: _fireRefreshEvent,
                    calculationStatusNotifier: _calculationStatusNotifier,
                  ),
                  settings: const RouteSettings(name: '/MainPage'),
                ),
              );
              return;
            case 1:
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => StrengthPage(
                    appRefreshStream: _appRefreshStream,
                    fireRefreshEvent: _fireRefreshEvent,
                    calculationStatusNotifier: _calculationStatusNotifier,
                  ),
                  settings: const RouteSettings(name: '/StrengthPage'),
                ),
              );
              return;
            case 2:
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => StabilityPage(
                    appRefreshStream: _appRefreshStream,
                    fireRefreshEvent: _fireRefreshEvent,
                    calculationStatusNotifier: _calculationStatusNotifier,
                  ),
                  settings: const RouteSettings(name: '/StabilityPage'),
                ),
              );
              return;
            case 3:
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => DraftsPage(
                    appRefreshStream: _appRefreshStream,
                    fireRefreshEvent: _fireRefreshEvent,
                    calculationStatusNotifier: _calculationStatusNotifier,
                  ),
                  settings: const RouteSettings(name: '/DraftsPage'),
                ),
              );
              return;
            case 4:
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => LoadingPage(
                    appRefreshStream: _appRefreshStream,
                    fireRefreshEvent: _fireRefreshEvent,
                    calculationStatusNotifier: _calculationStatusNotifier,
                  ),
                  settings: const RouteSettings(name: '/LoadingPage'),
                ),
              );
              return;
            default:
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => Row(
                    children: [
                      NavigationPanel(
                        selectedPageIndex: null,
                        appRefreshStream: _appRefreshStream,
                        fireRefreshEvent: _fireRefreshEvent,
                        calculationStatusNotifier: _calculationStatusNotifier,
                      ),
                      Expanded(
                        child: Scaffold(
                          body: ErrorMessageWidget(
                            message: const Localized('Page not found').v,
                          ),
                        ),
                      ),
                    ],
                  ),
                  settings: const RouteSettings(name: '/NotFoundPage'),
                ),
              );
          }
        },
      ),
    );
  }
}
