import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sss_computing_client/core/models/calculation/calculation_status.dart';
import 'package:sss_computing_client/core/widgets/navigation_panel.dart';
import 'package:sss_computing_client/presentation/stability/widgets/stability_body.dart';
///
class StabilityPage extends StatelessWidget {
  ///
  const StabilityPage({super.key});
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
              selectedPageIndex: 2,
              calculationStatusNotifier: status,
            ),
            Expanded(
              child: StabilityBody(
                appRefreshStream: status.refreshStream,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
