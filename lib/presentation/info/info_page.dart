import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core.dart';
import 'package:hmi_core/hmi_core_app_settings.dart';
import 'package:provider/provider.dart';
import 'package:sss_computing_client/core/models/calculation/calculation_status.dart';
import 'package:sss_computing_client/core/widgets/general_info_widget.dart';
import 'package:sss_computing_client/core/widgets/mini_side_bar/mini_sidebar.dart';
import 'package:sss_computing_client/core/widgets/navigation_panel.dart';
import 'package:sss_computing_client/presentation/info/widgets/projects/projects_body.dart';
import 'package:sss_computing_client/presentation/info/widgets/voyage/voyage_body.dart';
import 'widgets/ship/ship_body.dart';
///
/// The page is intended for displaying and setting general information
/// on the [ShipBody] and [VoyageBody].
class InfoPage extends StatefulWidget {
  final int _pageIndex;
  ///
  /// The page is intended for displaying and setting general information
  const InfoPage({
    super.key,
    required int pageIndex,
  }) : _pageIndex = pageIndex;
  @override
  State<InfoPage> createState() => _InfoPageState();
}
class _InfoPageState extends State<InfoPage> with TickerProviderStateMixin {
  late TabController _tabController;
  ///
  late List<Tab> _tabs;
  @override
  void initState() {
    _tabs = ['Ship data', 'Voyage data', 'Saved projects']
        .map(
          (e) => Tab(
            text: Localized(e).v,
          ),
        )
        .toList();
    _tabController = TabController(
      length: _tabs.length,
      vsync: this,
    );
    super.initState();
  }
  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    final blockPadding = const Setting('blockPadding').toDouble;
    final theme = Theme.of(context);
    return Scaffold(
      // ignore: deprecated_member_use
      backgroundColor: theme.colorScheme.background,
      body: Consumer<CalculationStatus>(
        builder: (_, status, __) => Row(
          children: [
            NavigationPanel(
              selectedPageIndex: widget._pageIndex,
              calculationStatusNotifier: status,
              trailing: GeneralInfoWidget(
                appRefreshStream: status.refreshStream,
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(blockPadding),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    MiniSidebar(
                      child: Text(
                        'Info Sidebar', // TODO: replace with an image
                        style: theme.textTheme.bodyMedium,
                      ),
                    ),
                    SizedBox(width: blockPadding),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TabBar(
                            dividerColor: theme.colorScheme.surface,
                            indicatorColor: theme.colorScheme.primary,
                            indicatorSize: TabBarIndicatorSize.tab,
                            tabAlignment: TabAlignment.start,
                            isScrollable: true,
                            controller: _tabController,
                            tabs: _tabs,
                          ),
                          SizedBox(height: blockPadding),
                          Expanded(
                            child: TabBarView(
                              physics: const NeverScrollableScrollPhysics(),
                              controller: _tabController,
                              children: [
                                const ShipBody(),
                                const VoyageBody(),
                                ProjectsBody(
                                  appRefreshStream: status.refreshStream,
                                  fireRefreshEvent: status.fireRefreshEvent,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
