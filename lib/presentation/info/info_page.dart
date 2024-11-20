import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core.dart';
import 'package:hmi_core/hmi_core_app_settings.dart';
import 'package:sss_computing_client/core/models/calculation/calculation_status.dart';
import 'package:sss_computing_client/core/widgets/mini_side_bar/mini_sidebar.dart';
import 'package:sss_computing_client/core/widgets/navigation_panel.dart';
import 'package:sss_computing_client/presentation/info/widgets/voyage/voyage_body.dart';
import 'widgets/ship/ship_body.dart';
/// The page is intended for displaying and setting general information
///  on the [Ship] and [VoyageDetails].
class InfoPage extends StatefulWidget {
  final Stream<DsDataPoint<bool>> _appRefreshStream;
  final void Function() _fireRefreshEvent;
  final CalculationStatus _calculationStatusNotifier;
  ///
  /// Creates page for configuring ship cargos.
  ///
  ///   [appRefreshStream] – stream with events causing data to be updated.
  ///   [fireRefreshEvent] – callback for triggering refresh event, called
  /// when calculation succeeds or fails;
  ///   [calculationStatusNotifier] – passed to control calculation status
  /// between many instances of calculation button.
  const InfoPage({
    super.key,
    required Stream<DsDataPoint<bool>> appRefreshStream,
    required void Function() fireRefreshEvent,
    required CalculationStatus calculationStatusNotifier,
  })  : _appRefreshStream = appRefreshStream,
        _fireRefreshEvent = fireRefreshEvent,
        _calculationStatusNotifier = calculationStatusNotifier;
  //
  @override
  State<InfoPage> createState() => _InfoPageState();
}
class _InfoPageState extends State<InfoPage> with TickerProviderStateMixin {
  late TabController _tabController;
  ///
  late List<Tab> _tabs;
  @override
  void initState() {
    _tabs = ['Ship data', 'Voyage data']
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
      body: Row(
        children: [
          NavigationPanel(
            selectedPageIndex: 5,
            appRefreshStream: widget._appRefreshStream,
            fireRefreshEvent: widget._fireRefreshEvent,
            calculationStatusNotifier: widget._calculationStatusNotifier,
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(blockPadding),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MiniSidebar(
                    child: Text(
                      'Info Sidebar', //todo: replace with an image
                      style: theme.textTheme.bodyMedium,
                    ),
                  ),
                  SizedBox(width: blockPadding),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TabBar(
                          // dividerColor: theme.colorScheme.surface,
                          controller: _tabController,
                          indicatorColor: theme.colorScheme.primary,
                          tabs: _tabs,
                          indicatorSize: TabBarIndicatorSize.tab,
                          tabAlignment: TabAlignment.start,
                          isScrollable: true,
                        ),
                        SizedBox(height: blockPadding),
                        Expanded(
                          child: TabBarView(
                            controller: _tabController,
                            children: const [
                              ShipBody(),
                              VoyageBody(),
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
    );
  }
}
