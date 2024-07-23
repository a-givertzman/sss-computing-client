import 'package:flutter/material.dart';
import 'package:sss_computing_client/core/widgets/tabs/tab_setting.dart';
///
class TabViewWidget extends StatelessWidget {
  final List<TabSetting> _tabsSettings;
  final bool _isScrollable;
  final Color? _indicatorColor;
  final Color? _dividerColor;
  final ScrollPhysics? _physics;
  ///
  const TabViewWidget({
    super.key,
    List<TabSetting> tabsSettings = const [],
    bool isScrollable = false,
    Color? indicatorColor,
    Color? dividerColor,
    ScrollPhysics? physics,
  })  : _tabsSettings = tabsSettings,
        _isScrollable = isScrollable,
        _indicatorColor = indicatorColor,
        _dividerColor = dividerColor,
        _physics = physics;
  ///
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final tabsLength = _tabsSettings.length;
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
                icon: _tabsSettings[index].icon,
                text: _tabsSettings[index].label,
              ),
            ),
          ),
          Expanded(
            child: TabBarView(
              physics: _physics,
              children: List.generate(
                tabsLength,
                (index) => _tabsSettings[index].content,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
