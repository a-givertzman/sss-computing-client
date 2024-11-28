import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sss_computing_client/core/models/calculation/calculation_status.dart';
import 'package:sss_computing_client/core/widgets/general_info_widget.dart';
import 'package:sss_computing_client/core/widgets/navigation_panel.dart';
import 'package:sss_computing_client/presentation/drafts/widgets/drafts_page_body.dart';
///
/// Page displaying drafts data.
class DraftsPage extends StatelessWidget {
  final int _pageIndex;
  ///
  const DraftsPage({
    super.key,
    required int pageIndex,
  }) : _pageIndex = pageIndex;
  //
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
              trailing: GeneralInfoWidget(
                appRefreshStream: status.refreshStream,
              ),
            ),
            Expanded(
              child: DraftsPageBody(
                appRefreshStream: status.refreshStream,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
