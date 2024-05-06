import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core.dart';
import 'package:sss_computing_client/core/widgets/error_message_widget.dart';
import 'package:sss_computing_client/presentation/main/main_page.dart';
import 'package:sss_computing_client/presentation/stability/stability_page.dart';
///
class NavigatedPage extends StatefulWidget {
  ///
  const NavigatedPage({super.key});
  @override
  State<NavigatedPage> createState() => _NavigatedPageState();
}
class _NavigatedPageState extends State<NavigatedPage> {
  int selectedIndex = 0;
  //
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        NavigationRail(
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
              icon: const Icon(Icons.video_stable_outlined),
              selectedIcon: const Icon(Icons.video_stable),
              label: Text(const Localized('Stability').v),
            ),
          ],
          selectedIndex: selectedIndex,
          onDestinationSelected: (value) => setState(() {
            selectedIndex = value;
          }),
        ),
        Expanded(
          child: _buildPage(selectedIndex),
        ),
      ],
    );
  }
  ///
  Widget _buildPage(int pageIndex) {
    return switch (pageIndex) {
      0 => const MainPage(),
      1 => const StabilityPage(),
      _ => Center(
          child: ErrorMessageWidget(
            message: const Localized('Page not found').v,
          ),
        ),
    };
  }
}
