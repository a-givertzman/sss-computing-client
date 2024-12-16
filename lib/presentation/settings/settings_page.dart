import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sss_computing_client/core/models/calculation/calculation_status.dart';
import 'package:sss_computing_client/core/widgets/navigation_panel.dart';
import 'package:sss_computing_client/presentation/settings/widgets/settings_body.dart';
///
///
class SettingsPage extends StatelessWidget {
  final int _pageIndex;
  ///
  const SettingsPage({
    super.key,
    required int pageIndex,
  }) : _pageIndex = pageIndex;
  //
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      // ignore: deprecated_member_use
      backgroundColor: theme.colorScheme.background,
      body: Consumer<CalculationStatus>(
        builder: (_, status, __) => Row(
          children: [
            NavigationPanel(
              selectedPageIndex: _pageIndex,
              calculationStatusNotifier: status,
            ),
            const Expanded(child: SettingsBody()),
          ],
        ),
      ),
    );
  }
}
