import 'package:flutter/material.dart';
import 'package:sss_computing_client/core/widgets/tabs/tab_setting.dart';
///
/// Tab view that construsted based on list of [TabSetting].
class TabViewWidget extends StatelessWidget {
  final List<TabSetting> _tabSettings;
  final bool _isScrollable;
  final Color? _indicatorColor;
  final Color? _dividerColor;
  final ScrollPhysics? _physics;
  ///
  /// Creates tab view that construsted based on list of provided [TabSetting].
  ///
  ///   `tabsSettings` used to construct [TabBarView] and [TabBar].
  ///   `isScrollable`, `indicatorColor`, `dividerColor` and `physics`
  /// used as parameters of [TabBar].
  const TabViewWidget({
    super.key,
    List<TabSetting> tabSettings = const [],
    bool isScrollable = false,
    Color? indicatorColor,
    Color? dividerColor,
    ScrollPhysics? physics,
  })  : _tabSettings = tabSettings,
        _isScrollable = isScrollable,
        _indicatorColor = indicatorColor,
        _dividerColor = dividerColor,
        _physics = physics;
  ///
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final tabsLength = _tabSettings.length;
    return DefaultTabController(
      length: tabsLength,
      child: Column(
        children: [
          TabBar(
            isScrollable: _isScrollable,
            indicatorColor: _indicatorColor ?? theme.colorScheme.primary,
            dividerColor: _dividerColor ?? theme.colorScheme.surface,
            dividerHeight: 2.0,
            tabs: List.generate(
              tabsLength,
              (index) => Tab(
                icon: _tabSettings[index].icon,
                text: _tabSettings[index].label,
              ),
            ),
          ),
          Expanded(
            child: TabBarView(
              physics: _physics,
              children: List.generate(
                tabsLength,
                (index) => _tabSettings[index].content,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
