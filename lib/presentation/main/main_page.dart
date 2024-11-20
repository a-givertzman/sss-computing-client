import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sss_computing_client/core/models/calculation/calculation_status.dart';
import 'package:sss_computing_client/core/widgets/navigation_panel.dart';
import 'package:sss_computing_client/presentation/main/widgets/main_page_body.dart';
///
class MainPage extends StatelessWidget {
  ///
  const MainPage({super.key});
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
              selectedPageIndex: 0,
              calculationStatusNotifier: status,
            ),
            Expanded(
              child: MainPageBody(
                appRefreshStream: status.refreshStream,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
