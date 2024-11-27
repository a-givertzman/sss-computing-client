import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core.dart';
import 'package:hmi_core/hmi_core_app_settings.dart';
import 'package:provider/provider.dart';
import 'package:sss_computing_client/core/models/calculation/calculation_status.dart';
import 'package:sss_computing_client/core/widgets/calculation/run_calculation_button.dart';
import 'package:sss_computing_client/core/widgets/error_message_widget.dart';
import 'package:sss_computing_client/presentation/drafts/drafts_page.dart';
import 'package:sss_computing_client/presentation/info/info_page.dart';
import 'package:sss_computing_client/presentation/loading/loading_page.dart';
import 'package:sss_computing_client/presentation/main/main_page.dart';
import 'package:sss_computing_client/presentation/stability/stability_page.dart';
import 'package:sss_computing_client/presentation/strength/strength_page.dart';
///
/// App main navigation widget.
class NavigationPanel extends StatelessWidget {
  final int? _selectedPageIndex;
  final CalculationStatus _calculationStatusNotifier;
  final Widget? _trailing;
  ///
  /// Creates app main navigation widget.
  const NavigationPanel({
    super.key,
    required int? selectedPageIndex,
    required CalculationStatus calculationStatusNotifier,
    Widget? trailing,
  })  : _selectedPageIndex = selectedPageIndex,
        _calculationStatusNotifier = calculationStatusNotifier,
        _trailing = trailing;
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
            fireRefreshEvent: _calculationStatusNotifier.fireRefreshEvent,
            calculationStatusNotifier: _calculationStatusNotifier,
          ),
        ),
        trailing: _trailing != null
            ? Expanded(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: _trailing,
                ),
              )
            : null,
        destinations: [
          NavigationRailDestination(
            icon: const Icon(Icons.home_outlined),
            selectedIcon: const Icon(Icons.home),
            label: Text(const Localized('Main').v),
          ),
          NavigationRailDestination(
            icon: const Icon(Icons.pallet),
            selectedIcon: const Icon(Icons.pallet),
            label: Text(const Localized('Loading').v),
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
            icon: const Icon(Icons.info_outline),
            selectedIcon: const Icon(Icons.info),
            label: Text(const Localized('Info').v),
          ),
        ],
        selectedIndex: _selectedPageIndex,
        onDestinationSelected: (index) {
          if (index == _selectedPageIndex) return;
          switch (index) {
            case 0:
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => const MainPage(pageIndex: 0),
                  settings: const RouteSettings(name: '/MainPage'),
                ),
              );
              return;
            case 1:
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => const LoadingPage(pageIndex: 1),
                  settings: const RouteSettings(name: '/LoadingPage'),
                ),
              );
              return;
            case 2:
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => const DraftsPage(pageIndex: 2),
                  settings: const RouteSettings(name: '/DraftsPage'),
                ),
              );
              return;
            case 3:
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => const StrengthPage(pageIndex: 3),
                  settings: const RouteSettings(name: '/StrengthPage'),
                ),
              );
              return;
            case 4:
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => const StabilityPage(pageIndex: 4),
                  settings: const RouteSettings(name: '/StabilityPage'),
                ),
              );
              return;
            case 5:
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => const InfoPage(pageIndex: 5),
                  settings: const RouteSettings(name: '/InfoPage'),
                ),
              );
              return;
            default:
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => Consumer<CalculationStatus>(
                    builder: (_, status, __) => Row(
                      children: [
                        NavigationPanel(
                          selectedPageIndex: null,
                          calculationStatusNotifier: status,
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
